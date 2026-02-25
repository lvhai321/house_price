from .base import BaseSpider
from bs4 import BeautifulSoup
from apps.spider.utils.http import get_session, RateLimiter, fetch
from apps.spider.utils.normalize import to_total_price_wan, to_area_m2, compute_unit_price
import time
import random
import re
from pypinyin import lazy_pinyin

class FangSpider(BaseSpider):
    """
    【房天下 (Fang.com) 二手房核心爬虫】
    -----------------------------------
    该爬虫专门负责抓取房天下平台的二手房挂牌数据。
    
    核心能力：
    1. 智能域名解析：支持中文（如“武汉”）、拼音（“wuhan”）或简写（“wh”）自动匹配子域名。
    2. 动态搜索构造：根据用户输入的区域关键字实时生成搜索 URL。
    3. 增量抓取机制：通过与数据库比对 URL，识别新房源与旧房源。
    4. 智能翻页控制：当收集到足够的新房源，或遇到连续空页/反爬时，自动停止抓取。
    
    URL 结构示例：
        https://{城市子域名}.esf.fang.com/house/i3{页码}-kw{搜索词}/
    """
    def __init__(self, region=None, pages=1, city_subdomain="bj", use_proxy=False):
        """
        初始化房天下爬虫。
        
        参数:
            region (str): 区域搜索词（如：“白沙洲”、“塔子湖”）。
            pages (int): 目标抓取页数。每页约包含 60 条记录。
            city_subdomain (str): 城市标识（如：“bj”、“sh”、“wuhan”）。
            use_proxy (bool): 是否使用代理（用于规避反爬风险）。
        """
        super().__init__(region=region)
        self.pages = pages
        self.city_subdomain = city_subdomain
        self.use_proxy = use_proxy
        self.session = get_session()
        # 配置速率限制，模拟真人操作，降低被封 IP 的风险
        self.limiter = RateLimiter(jitter_range=(2.0, 3.5))

    def _get_subdomain(self):
        """
        解析并获取合法的城市子域名。
        
        解析流程：
        1. 查表法：匹配内置的常用城市缩写映射表。
        2. 拼音法：如果输入是中文，自动调用 pypinyin 库转为全拼。
        3. 原样返回：如果输入已是英文全拼，则直接使用。
        """
        raw_input = self.city_subdomain.lower().strip()
        
        direct_city_map = {
            '北京': 'bj', 'beijing': 'bj', 'bj': 'bj',
            '上海': 'sh', 'shanghai': 'sh', 'sh': 'sh',
            '天津': 'tj', 'tianjin': 'tj', 'tj': 'tj',
            '重庆': 'cq', 'chongqing': 'cq', 'cq': 'cq',
            '武汉': 'wuhan', 'wh': 'wuhan',
            '孝感': 'xiaogan', 'xg': 'xiaogan',
            '乌鲁木齐': 'xj', 'xj': 'xj',
            '呼和浩特': 'nm', 'nm': 'nm',
            '乌兰察布': 'wlcb',
        }
        
        if raw_input in direct_city_map:
            return direct_city_map[raw_input]
            
        # 如果包含中文，执行转拼音逻辑
        if any(ord(char) > 127 for char in raw_input):
            try:
                pinyin_list = lazy_pinyin(raw_input)
                return "".join(pinyin_list)
            except Exception:
                return raw_input
        
        return raw_input

    def _list_urls(self):
        """
        【调试工具】生成待抓取的列表页 URL 集合。
        注意：在主流程的 crawl 方法中，为了更灵活地控制翻页，我们会动态构造 URL。
        """
        subdomain = self._get_subdomain()
        base = f"https://{subdomain}.esf.fang.com"
        
        urls = []
        for i in range(1, self.pages + 1):
            path = f"/house/i3{i}"
            if self.region:
                path += f"-kw{self.region}"
            path += "/"
            urls.append(f"{base}{path}")
        return urls

    def _parse_list(self, html):
        """
        解析房源列表页的 HTML 内容，提取核心字段。
        
        提取字段包括：
        - 标题：由“小区名 + 户型 + 面积”重新组合而成的标准化标题。
        - 区域：复合字段（搜索词 + 实际板块名），解决房天下页面区域信息不全的问题。
        - 价格：提取总价（万元）并自动计算单价（元/㎡）。
        - 详情链接：房源的唯一访问地址（用于去重）。
        """
        soup = BeautifulSoup(html, "html.parser")
        items = []
        
        # 房天下列表项通常包裹在 dl 标签中
        dls = soup.select("div.shop_list dl, dl[id^='lp_']")
        
        for dl in dls:
            try:
                # 1. 提取原始标题和详情页链接
                original_title_el = dl.select_one("h4.clearfix a, p.title a, .tit_shop a")
                original_title = original_title_el.get_text(strip=True) if original_title_el else None
                
                # 2. 提取房屋基本信息文本
                info_el = dl.select_one("p.tel_shop, p.content")
                info_text = info_el.get_text(" ", strip=True) if info_el else ""
                
                area_m2 = None
                layout = None
                
                # 正则匹配面积
                area_match = re.search(r'(\d+(?:\.\d+)?)(?:㎡|平米)', info_text)
                if area_match:
                    area_m2 = float(area_match.group(1))
                
                # 正则匹配户型
                layout_match = re.search(r'\d+室\d+厅', info_text)
                if layout_match:
                    layout = layout_match.group(0)

                # 3. 提取小区名
                community_el = dl.select_one("p.add_shop a")
                community_name = community_el.get_text(strip=True) if community_el else ""
                
                # 4. 构建标准化标题（提高可读性）
                if community_name and layout and area_m2:
                    title = f"{community_name} {layout} {area_m2}平"
                else:
                    title = original_title

                url = None
                if original_title_el and original_title_el.has_attr("href"):
                    url = original_title_el["href"]
                
                # 5. 提取并清洗价格数据
                total_el = dl.select_one("span.red, span.price_right")
                total_price_wan = None
                if total_el:
                    t = total_el.get_text(strip=True).replace("万", "")
                    try:
                        total_price_wan = float(t)
                    except ValueError:
                        pass
                
                unit_price = None
                if total_price_wan and area_m2:
                    unit_price = compute_unit_price(total_price_wan, area_m2)
                
                if not url: continue
                
                # 6. 解析并组合区域信息
                # 策略：前端输入词 (如:武汉) + 页面解析词 (如:白沙洲) = 武汉-白沙洲
                search_prefix = self.region if self.region else "未知"
                extracted_suffix = "未知"
                
                add_shop_span = dl.select_one("p.add_shop span")
                if add_shop_span:
                    span_text = add_shop_span.get_text(strip=True)
                    parts = span_text.split()
                    if parts: extracted_suffix = parts[0]
                
                final_region = f"{search_prefix}-{extracted_suffix}"
                
                # 7. 补全相对路径 URL
                if url.startswith("/"):
                    subdomain = self._get_subdomain()
                    domain = "esf.fang.com" if subdomain == 'bj' else f"{subdomain}.esf.fang.com"
                    url = f"https://{domain}{url}"

                item = {
                    "title": title,
                    "region": final_region,
                    "area": area_m2,
                    "layout": layout or "",
                    "total_price": total_price_wan,
                    "unit_price": unit_price,
                    "source": "Fang",
                    "url": url
                }
                items.append(item)
            except Exception:
                continue
                
        return items

    def crawl(self):
        """
        【爬虫主执行引擎】
        ----------------
        采用“智能增量抓取”策略：
        1. 循环抓取每一页数据，直到收集到足够数量的“新房源”。
        2. 如果某一页房源已经在数据库中存在，则将其标记为 is_new = False。
        3. 具备容错机制：遇到连续 3 个空页或网络故障时会自动熔断，保护程序不崩溃。
        """
        results = []
        try:
            from apps.spider.models import House
            db_check_available = True
        except ImportError:
            db_check_available = False

        # 设定目标新房源数量（页数 * 60）
        target_new = self.pages * 60
        new_collected = 0
        total_collected = 0
        
        current_page = 1
        consecutive_empty_pages = 0
        
        subdomain = self._get_subdomain()
        base = f"https://{subdomain}.esf.fang.com"

        print(f"[Fang] 任务启动：目标抓取 {self.pages} 页 (约 {target_new} 条新房源)")

        # 设定最大尝试页数，防止死循环
        max_pages = max(self.pages * 5, self.pages)

        while new_collected < target_new and current_page <= max_pages:
            path = f"/house/i3{current_page}"
            if self.region: path += f"-kw{self.region}"
            path += "/"
            url = f"{base}{path}"
            
            print(f"[Fang] 正在抓取第 {current_page} 页: {url}")
            
            try:
                html = fetch(url, session=self.session, rate_limiter=self.limiter, use_proxy=self.use_proxy)
                items = self._parse_list(html)
                
                if not items:
                    consecutive_empty_pages += 1
                    if consecutive_empty_pages >= 3:
                        print("[Fang] 连续 3 页无数据，可能已到末尾或被反爬，停止抓取。")
                        break
                    current_page += 1
                    continue
                else:
                    consecutive_empty_pages = 0

                # 数据库去重与标记
                new_items_count = 0
                if db_check_available:
                    try:
                        current_urls = [item['url'] for item in items if item.get('url')]
                        if current_urls:
                            existing_urls = set(House.objects.filter(url__in=current_urls).values_list('url', flat=True))
                            for item in items:
                                if item.get('url') in existing_urls:
                                    item['is_new'] = False
                                else:
                                    item['is_new'] = True
                                    new_items_count += 1
                    except Exception as db_e:
                        for item in items: item['is_new'] = True
                        new_items_count = len(items)
                else:
                    for item in items: item['is_new'] = True
                    new_items_count = len(items)

                print(f"[Fang] 第 {current_page} 页完成。抓取: {len(items)} 条, 其中新房源: {new_items_count} 条")
                
                if items:
                    results.extend(items)
                    total_collected += len(items)
                    new_collected += new_items_count
                    print(f"[Fang] 累积进度：新数据 {new_collected}/{target_new}")

                current_page += 1
                # 动态休眠，模拟真实浏览行为
                time.sleep(random.uniform(1.0, 3.0))

            except Exception as e:
                print(f"[Fang] 抓取失败 (网络异常): {e}")
                break
                
        return results
