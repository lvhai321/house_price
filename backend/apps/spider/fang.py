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
    房天下 (Fang.com) 爬虫实现类。
    负责从房天下网站抓取二手房数据。
    
    基础 URL 结构: https://{city}.esf.fang.com/
    """
    def __init__(self, region=None, pages=3, city_subdomain="bj", use_proxy=False):
        """
        初始化房天下爬虫。
        
        参数:
            region (str): 爬取区域，默认为 None (通常对应城市或行政区)。
            pages (int): 爬取的页数，默认为 3。
            city_subdomain (str): 城市子域名，默认为 'bj'。
            use_proxy (bool): 是否使用代理池。
        """
        super().__init__(region=region)
        self.pages = pages
        self.city_subdomain = city_subdomain
        self.use_proxy = use_proxy
        self.session = get_session()
        # 房天下反爬策略较严，配置速率限制器
        self.limiter = RateLimiter(jitter_range=(2.0, 3.5))

    def _get_subdomain(self):
        """
        获取城市子域名。
        规则：
        1. 直辖市（北京、上海、天津、重庆）强制使用首字母缩写 (bj, sh, tj, cq)。
        2. 其他输入支持中文自动转全拼，或直接使用全拼。
        """
        raw_input = self.city_subdomain.lower().strip()
        
        # 1. 直辖市特例处理 (支持中文、全拼、缩写)
        # 映射表: 统一映射到官方缩写
        # 增加部分省会/自治区的特殊映射（如乌鲁木齐 -> xj, 呼和浩特 -> nm）
        direct_city_map = {
            # 直辖市
            '北京': 'bj', 'beijing': 'bj', 'bj': 'bj',
            '上海': 'sh', 'shanghai': 'sh', 'sh': 'sh',
            '天津': 'tj', 'tianjin': 'tj', 'tj': 'tj',
            '重庆': 'cq', 'chongqing': 'cq', 'cq': 'cq',
            # 特殊省会/首府 (使用省级缩写)
            '乌鲁木齐': 'xj', 'wulumuqi': 'xj', 'xj': 'xj', # 新疆
            '呼和浩特': 'nm', 'huhehaote': 'nm', 'nm': 'nm', # 内蒙古
            '乌兰察布': 'wlcb', 'wulanchabu': 'wlcb', 'wlcb': 'wlcb', # 乌兰察布比较特殊，是拼音首字母
        }
        
        if raw_input in direct_city_map:
            return direct_city_map[raw_input]
            
        # 2. 中文转全拼
        # 如果包含非 ASCII 字符 (即中文)，则调用 pypinyin
        if any(ord(char) > 127 for char in raw_input):
            try:
                # lazy_pinyin 返回列表 ['xiao', 'gan'] -> join -> 'xiaogan'
                pinyin_list = lazy_pinyin(raw_input)
                return "".join(pinyin_list)
            except Exception:
                # 转换失败回退到原输入
                return raw_input
        
        # 3. 英文直接作为全拼使用
        return raw_input

    def _list_urls(self):
        """
        生成待爬取的列表页 URL 列表。
        
        返回:
            list: URL 字符串列表。
        """
        subdomain = self._get_subdomain()
        
        # 特殊处理：xj (乌鲁木齐/新疆), nm (呼和浩特/内蒙), wlcb (乌兰察布)
        # 这些站点的域名规则是 https://xj.fang.com/ (不带 esf)
        # 但有些是 https://wlcb.esf.fang.com/
        
        # 经过调研：
        # 乌鲁木齐: https://xj.esf.fang.com/ (二手房) 
        # 呼和浩特: https://nm.esf.fang.com/
        # 乌兰察布: https://wlcb.esf.fang.com/
        
        # 之前用户提到 "乌鲁木齐的地址为： https://xj.fang.com/"，这通常是新房或首页。
        # 二手房通常还是需要 esf 子域名。
        # 让我们统一尝试构建 https://{subdomain}.esf.fang.com
        # 如果某些城市确实没有 esf 子域名（极少见），可能需要特殊处理。
        # 但对于大多数情况，包括 xj, nm, wlcb，二手房频道都是 {subdomain}.esf.fang.com
        
        # 修正：
        # 实际上，乌鲁木齐二手房是 https://xj.esf.fang.com/
        # 呼和浩特二手房是 https://nm.esf.fang.com/
        # 乌兰察布二手房是 https://wlcb.esf.fang.com/
        # 所以原有逻辑 `https://{subdomain}.esf.fang.com` 是通用的，关键是 subdomain 要对。
        
        base = f"https://{subdomain}.esf.fang.com"
        
        urls = []
        for i in range(1, self.pages + 1):
            # 统一使用 /house/ 路径，兼容性更好
            # 首页: https://sh.esf.fang.com/house/
            # 分页: https://sh.esf.fang.com/house/i3{page}/
            
            # 如果是第一页，尝试不带页码或带 i31
            # 房天下规则：/house/i3{page}/
            # 搜索规则：/house/i3{page}-kw{keyword}/
            
            path = f"/house/i3{i}"
            if self.region:
                path += f"-kw{self.region}"
            path += "/"
            
            urls.append(f"{base}{path}")
            
        return urls

    def _parse_list(self, html):
        """
        解析房源列表页 HTML，提取房源信息。
        
        参数:
            html (str): 页面 HTML 内容。
            
        返回:
            list: 提取出的房源字典列表。
        """
        soup = BeautifulSoup(html, "html.parser")
        items = []
        
        # 城市名称映射 (用于 Region 回退)
        city_name_map = {
            'bj': '北京', 'beijing': '北京',
            'sh': '上海', 'shanghai': '上海',
            'tj': '天津', 'tianjin': '天津',
            'cq': '重庆', 'chongqing': '重庆',
            'wh': '武汉', 'wuhan': '武汉',
            'gz': '广州', 'guangzhou': '广州',
            'sz': '深圳', 'shenzhen': '深圳',
            'hz': '杭州', 'hangzhou': '杭州',
            'cd': '成都', 'chengdu': '成都',
            'nj': '南京', 'nanjing': '南京',
            'su': '苏州', 'suzhou': '苏州',
            'xa': '西安', 'xian': '西安',
            'cs': '长沙', 'changsha': '长沙',
            'xg': '孝感', 'xiaogan': '孝感',
        }
        
        # 选择所有房源列表项
        # 房天下通常使用 <dl> 标签，位于 <div class="shop_list"> 内，或 id 以 'lp_' 开头的 <dl>
        dls = soup.select("div.shop_list dl, dl[id^='lp_']")
        
        for dl in dls:
            try:
                # --- 解析标题 (优化：优先使用 小区+户型+面积) ---
                original_title_el = dl.select_one("h4.clearfix a, p.title a, .tit_shop a")
                original_title = original_title_el.get_text(strip=True) if original_title_el else None
                
                # --- 解析房源基本信息 (面积, 户型) ---
                # 通常在 <p class="tel_shop"> 或 <p class="content"> 中
                info_el = dl.select_one("p.tel_shop, p.content")
                info_text = info_el.get_text(" ", strip=True) if info_el else ""
                
                area_m2 = None
                layout = None
                
                # 提取面积
                area_match = re.search(r'(\d+(?:\.\d+)?)(?:㎡|平米)', info_text)
                if area_match:
                    area_m2 = float(area_match.group(1))
                
                # 提取户型
                layout_match = re.search(r'\d+室\d+厅', info_text)
                if layout_match:
                    layout = layout_match.group(0)

                # --- 提取小区名 ---
                # 通常在 p.add_shop 的第一个 a 标签
                community_el = dl.select_one("p.add_shop a")
                community_name = community_el.get_text(strip=True) if community_el else ""
                
                # --- 构建标准化标题 ---
                if community_name and layout and area_m2:
                    # 格式: 小区名 户型 面积平
                    # 例如: 融创公园壹号三期 3室2厅 104.72平
                    title = f"{community_name} {layout} {area_m2}平"
                else:
                    title = original_title

                # --- 解析详情页链接 ---
                url = None
                if original_title_el and original_title_el.has_attr("href"):
                    href = original_title_el["href"]
                    url = href
                
                # --- 解析价格 ---
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
                
                if not url:
                    continue
                
                # --- 解析区域 (修复 Unknown 问题) ---
                # 优先级 1: 使用用户指定的 region (如 "朝阳")
                region_extracted = self.region
                
                # 优先级 2: 如果未指定 region (全城搜索)，则尝试从 HTML 提取子区域
                # 但为了保证一致性，如果不确定，也可以回退到城市名
                # 用户要求: "region应该读取前端输入的地区，如‘武汉’"
                
                if not region_extracted:
                    # 尝试从 p.add_shop span 提取 (例如 "塔子湖")
                    # HTML 结构: <p class="add_shop"><a>小区</a> <span>塔子湖 地址...</span></p>
                    add_shop_span = dl.select_one("p.add_shop span")
                    if add_shop_span:
                        span_text = add_shop_span.get_text(strip=True)
                        # 通常是 "区域 地址" 或 "区域 商圈 地址"
                        # 取第一个空格前的内容
                        parts = span_text.split()
                        if parts:
                            region_extracted = parts[0] # 例如 "塔子湖"
                
                # 优先级 3: 如果还是提取不到，或者为了兜底，使用城市名
                if not region_extracted or region_extracted == "Unknown":
                     # 回退到城市名 (例如 "武汉")
                     region_extracted = city_name_map.get(self.city_subdomain.lower(), self.city_subdomain)

                # --- URL 清理与补全 ---
                if url.startswith("/"):
                    # 使用 _get_subdomain 获取正确的全拼 (如 xiaogan)
                    subdomain = self._get_subdomain()
                    domain = "esf.fang.com" if subdomain == 'bj' else f"{subdomain}.esf.fang.com"
                    url = f"https://{domain}{url}"

                # 构造房源数据字典
                item = {
                    "title": title,
                    "region": region_extracted,
                    "area": area_m2,
                    "layout": layout or "",
                    "total_price": total_price_wan,
                    "unit_price": unit_price,
                    "source": "Fang",
                    "url": url
                }
                items.append(item)
            except Exception as e:
                continue
                
        return items

    def crawl(self):
        """
        执行爬取任务。
        遍历分页 URL，获取并解析数据。
        
        返回:
            list: 所有爬取到的房源数据列表。
        """
        results = []
        # 尝试动态导入 House 模型以进行去重检查
        try:
            from apps.spider.models import House
            db_check_available = True
        except ImportError:
            db_check_available = False

        # 智能翻页逻辑：
        # 目标是收集到足够数量的新数据
        # 假设每页约 60 条数据，目标总数 = pages * 60
        
        target_count = self.pages * 60
        collected_count = 0
        
        current_page = 1
        consecutive_empty_pages = 0 # 连续空页计数（防死循环）
        
        subdomain = self._get_subdomain()
        base = f"https://{subdomain}.esf.fang.com"

        print(f"[Fang] 开始爬取，目标: {self.pages} 页 (约 {target_count} 条新数据)")

        while collected_count < target_count:
            # 构造当前页 URL
            path = f"/house/i3{current_page}"
            if self.region:
                path += f"-kw{self.region}"
            path += "/"
            url = f"{base}{path}"
            
            print(f"[Fang] 正在抓取第 {current_page} 页: {url}")
            
            try:
                # 获取页面内容，使用速率限制
                html = fetch(url, session=self.session, rate_limiter=self.limiter, use_proxy=self.use_proxy)
                # 解析页面
                items = self._parse_list(html)
                
                if not items:
                    print(f"[Fang] 第 {current_page} 页无数据。")
                    consecutive_empty_pages += 1
                    if consecutive_empty_pages >= 3:
                        print("[Fang] 连续 3 页无数据，停止翻页。")
                        break
                    current_page += 1
                    continue
                else:
                    consecutive_empty_pages = 0

                # 数据库去重逻辑
                valid_items = []
                if db_check_available:
                    try:
                        current_urls = [item['url'] for item in items if item.get('url')]
                        if current_urls:
                            existing_urls = set(House.objects.filter(url__in=current_urls).values_list('url', flat=True))
                            
                            for item in items:
                                if item.get('url') not in existing_urls:
                                    valid_items.append(item)
                    except Exception as db_e:
                        print(f"[Fang] 数据库去重检查失败: {db_e}")
                        valid_items = items # 降级：保留所有
                else:
                    valid_items = items

                # 智能翻页判断
                if len(items) > 0 and len(valid_items) == 0:
                    print(f"[Fang] 第 {current_page} 页全是旧数据 ({len(items)}条)，跳过并尝试下一页...")
                    current_page += 1
                    # 限制最大跳跃页数，防止无限向后翻
                    if current_page > 100: 
                        print("[Fang] 已达到最大翻页限制 (100页)，停止。")
                        break
                    time.sleep(random.uniform(0.5, 1.5)) # 快速跳过时的短休眠
                    continue
                
                print(f"[Fang] 第 {current_page} 页包含 {len(valid_items)}/{len(items)} 条新数据。")
                
                if valid_items:
                    results.extend(valid_items)
                    collected_count += len(valid_items)
                    print(f"[Fang] 当前进度: {collected_count}/{target_count}")

                current_page += 1
                
                # 随机休眠
                time.sleep(random.uniform(1.0, 3.0))

            except Exception as e:
                print(f"[Fang] 获取 {url} 失败: {e}")
                # 出错也算尝试过，避免死循环
                current_page += 1
                
        return results
