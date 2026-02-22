from .base import BaseSpider
from bs4 import BeautifulSoup
from apps.spider.utils.http import get_session, RateLimiter, fetch
from apps.spider.utils.normalize import to_total_price_wan, to_area_m2, compute_unit_price
import time
import random
import re

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
        1. 直辖市（北京、上海、天津、重庆）使用首字母缩写 (bj, sh, tj, cq)。
        2. 其他城市使用全拼 (如 wuhan, guangzhou)。
        """
        city = self.city_subdomain.lower()
        
        # 直辖市缩写白名单
        direct_cities = {'bj', 'sh', 'tj', 'cq'}
        if city in direct_cities:
            return city
            
        # 常见缩写转全拼映射
        abbr_map = {
            'wh': 'wuhan',
            'gz': 'guangzhou',
            'sz': 'shenzhen',
            'hz': 'hangzhou',
            'cd': 'chengdu',
            'nj': 'nanjing',
            'su': 'suzhou',
            'xa': 'xian',
            'cs': 'changsha',
            'cq': 'chongqing', # 重庆通常用 cq，但也防全拼
        }
        return abbr_map.get(city, city)

    def _list_urls(self):
        """
        生成待爬取的列表页 URL 列表。
        
        返回:
            list: URL 字符串列表。
        """
        subdomain = self._get_subdomain()
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
        
        # 选择所有房源列表项
        # 房天下通常使用 <dl> 标签，位于 <div class="shop_list"> 内，或 id 以 'lp_' 开头的 <dl>
        dls = soup.select("div.shop_list dl, dl[id^='lp_']")
        
        for dl in dls:
            try:
                # --- 解析标题 ---
                title_el = dl.select_one("h4.clearfix a, p.title a, .tit_shop a")
                title = title_el.get_text(strip=True) if title_el else None
                
                # --- 解析详情页链接 ---
                url = None
                if title_el and title_el.has_attr("href"):
                    href = title_el["href"]
                    # 房天下链接可能是相对路径，也可能是绝对路径，稍后统一处理
                    url = href
                
                # --- 解析房源基本信息 (面积, 户型) ---
                # 通常在 <p class="tel_shop"> 或 <p class="content"> 中
                # 文本示例: "2室1厅 | 88平米 | ..."
                info_el = dl.select_one("p.tel_shop, p.content")
                info_text = info_el.get_text(" ", strip=True) if info_el else ""
                
                area_m2 = None
                layout = None
                
                # 提取面积: 查找类似 "88㎡" 或 "88平米" 的模式
                area_match = re.search(r'(\d+(?:\.\d+)?)(?:㎡|平米)', info_text)
                if area_match:
                    area_m2 = float(area_match.group(1))
                
                # 提取户型: 查找类似 "2室1厅" 的模式
                layout_match = re.search(r'\d+室\d+厅', info_text)
                if layout_match:
                    layout = layout_match.group(0)

                # --- 解析价格 ---
                # 总价: 通常在 <span class="red">200</span>万
                total_el = dl.select_one("span.red, span.price_right")
                total_price_wan = None
                if total_el:
                    # 有时文本是 "200万" 或仅 "200"，去除 "万" 字
                    t = total_el.get_text(strip=True).replace("万", "")
                    try:
                        total_price_wan = float(t)
                    except ValueError:
                        pass
                
                # 单价: 通常在 <span>10000元/平米</span>
                # 如果找不到直接的单价元素，可以通过 总价/面积 计算
                unit_price = None
                if total_price_wan and area_m2:
                    unit_price = compute_unit_price(total_price_wan, area_m2)
                
                if not url:
                    continue
                
                # --- 解析区域 (修复 Unknown 问题) ---
                region_extracted = self.region
                if not region_extracted:
                    # 尝试从地址段提取区域，如 [朝阳 大望路]
                    add_shop_el = dl.select_one("p.add_shop")
                    if add_shop_el:
                        add_text = add_shop_el.get_text(strip=True)
                        match = re.search(r'\[(.*?)\s+.*?\]', add_text)
                        if match:
                            # 提取中文区域名，后续处理逻辑中建议转为拼音以保持一致
                            region_extracted = match.group(1)
                            # 简单的拼音转换 (如果已安装 pypinyin)
                            try:
                                from pypinyin import lazy_pinyin
                                region_extracted = "".join(lazy_pinyin(region_extracted))
                            except ImportError:
                                pass # 如果没装库，就存中文，但在 API 层可能需要适配

                # --- URL 清理与补全 ---
                # 如果是相对路径，需要补全域名
                if url.startswith("/"):
                    city = self.city_subdomain
                    domain = "esf.fang.com" if city == 'bj' else f"{city}.esf.fang.com"
                    url = f"https://{domain}{url}"

                # 构造房源数据字典
                item = {
                    "title": title,
                    "region": region_extracted or "Unknown",
                    "area": area_m2,
                    "layout": layout or "",
                    "total_price": total_price_wan,
                    "unit_price": unit_price,
                    "source": "Fang", # 来源标记为房天下
                    "url": url
                }
                items.append(item)
            except Exception as e:
                # 忽略解析错误的单个条目，继续解析下一个
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
