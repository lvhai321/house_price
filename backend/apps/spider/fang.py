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

    def _list_urls(self):
        """
        生成待爬取的列表页 URL 列表。
        
        返回:
            list: URL 字符串列表。
        """
        # 使用城市子域名构建基础 URL
        city = self.city_subdomain
        
        # 构建基础 URL
        # 通常格式为 https://{city}.esf.fang.com/
        if city == 'bj':
            base = "https://esf.fang.com"
        else:
            base = f"https://{city}.esf.fang.com"

        # 构造分页 URL
        # 如果指定了 region，使用搜索接口以支持区域筛选
        # 否则默认使用 /house/i3{page}/
        if self.region:
            # 搜索接口: https://esf.fang.com/?kw=朝阳&rfss=1-8070ad6d2673295842-1c
            # 分页通常是 /?kw=...&page=2
            # 但房天下的搜索结果页分页比较特殊，有时是 /house-a0{code}/i3{page}/
            # 为了简单起见，我们尝试直接在 URL 路径中包含关键词
            # https://esf.fang.com/house/kw%E6%9C%9D%E9%98%B3/
            # 分页: /house/i3{page}-kw{region}/
            
            # 尝试使用搜索关键词路径
            return [f"{base}/house/i3{i}-kw{self.region}/" for i in range(1, self.pages + 1)]
        else:
            # 模式: /house/i3{page}/
            return [f"{base}/house/i3{i}/" for i in range(1, self.pages + 1)]

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

                # --- URL 清理与补全 ---
                # 如果是相对路径，需要补全域名
                if url.startswith("/"):
                    city = self.city_subdomain
                    domain = "esf.fang.com" if city == 'bj' else f"{city}.esf.fang.com"
                    url = f"https://{domain}{url}"

                # 构造房源数据字典
                item = {
                    "title": title,
                    "region": self.region or "Unknown",
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
        for url in self._list_urls():
            try:
                # 获取页面内容，使用速率限制
                html = fetch(url, session=self.session, rate_limiter=self.limiter, use_proxy=self.use_proxy)
                # 解析页面
                items = self._parse_list(html)
                results.extend(items)
                # 随机休眠，模拟人类行为
                time.sleep(random.uniform(1.0, 3.0))
            except Exception as e:
                print(f"[Fang] 获取 {url} 失败: {e}")
        return results
