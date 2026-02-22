from .base import BaseSpider
from bs4 import BeautifulSoup
from apps.spider.utils.http import get_session, RateLimiter, fetch, USER_AGENTS
from apps.spider.utils.normalize import to_total_price_wan, to_area_m2, compute_unit_price
import time
import random


class LianjiaSpider(BaseSpider):
    """
    链家 (Lianjia.com) 爬虫实现类。
    
    注意: 链家有严格的反爬机制（IP频率限制、验证码）。
    建议在生产环境配合高质量代理IP池使用。
    """
    def __init__(self, region=None, city_subdomain="bj", pages=3, use_proxy=False):
        """
        初始化链家爬虫。
        
        参数:
            region (str): 区域代码 (如 'chaoyang'), 默认为 None。
            city_subdomain (str): 城市子域名 (如 'bj' 代表北京), 默认为 'bj'。
            pages (int): 爬取页数。
            use_proxy (bool): 是否使用代理池。
        """
        super().__init__(region=region)
        self.city_subdomain = city_subdomain
        self.pages = pages
        self.use_proxy = use_proxy
        self.session = get_session()
        # 链家限制较严，设置 jitter 以随机化请求间隔
        self.limiter = RateLimiter(jitter_range=(2.0, 5.0))

    def _list_urls(self):
        """
        生成待爬取的列表页 URL。
        URL 结构: https://{city}.lianjia.com/ershoufang/{region}/pg{page}/
        """
        region_path = f"{self.region}/" if self.region else ""
        base = f"https://{self.city_subdomain}.lianjia.com/ershoufang/{region_path}"
        return [f"{base}pg{i}/" for i in range(1, self.pages + 1)]

    def _parse_list(self, html):
        """
        解析链家房源列表页 HTML。
        """
        soup = BeautifulSoup(html, "html.parser")
        
        # 检查是否触发了反爬验证页面
        if soup.title and ("验证" in soup.title.get_text() or "系统限制" in soup.title.get_text()):
             print(f"[Lianjia] 警告: 检测到反爬验证页面 - {soup.title.get_text()}")
             return []
             
        items = []
        # 链家列表项选择器
        for li in soup.select(".sellListContent li, .listContent li, .sellListContent .LOGVIEWDATA"):
            # 提取各个字段元素
            title_el = li.select_one(".title a")
            price_el = li.select_one(".total-price span, .total .price")
            unit_el = li.select_one(".unitPrice span, .unitPrice")
            info_el = li.select_one(".houseInfo, .info")
            link_el = li.select_one(".title a[href]")
            
            title = title_el.get_text(strip=True) if title_el else None
            # 处理总价
            total_price_wan = to_total_price_wan(price_el.get_text(strip=True) if price_el else None)
            
            area_m2 = None
            layout = None
            
            # 解析房源信息文本 (如 "2室1厅 | 88平米 | 南 | 精装")
            if info_el:
                text = info_el.get_text("|", strip=True)
                parts = [p.strip() for p in text.split("|") if p.strip()]
                for p in parts:
                    # 尝试提取面积
                    if "平米" in p or "m²" in p:
                        a = to_area_m2(p)
                        if a:
                            area_m2 = a
                    # 尝试提取户型
                    if "室" in p and "厅" in p:
                        layout = p
            
            # 计算单价 (优先计算，因为有时候页面上的单价格式不统一)
            if area_m2 and total_price_wan:
                unit_price = compute_unit_price(total_price_wan, area_m2)
            else:
                unit_price = None
                
            url = link_el["href"] if link_el else None
            
            item = {
                "title": title,
                "region": self.region or "Unknown",
                "area": area_m2,
                "layout": layout or "",
                "total_price": total_price_wan,
                "unit_price": unit_price,
                "source": "Lianjia", # 来源标记
                "url": url
            }
            items.append(item)
        return items

    def crawl(self):
        """
        执行爬取任务。
        包含动态设置 Referer 和 User-Agent 以规避简单的反爬检测。
        """
        results = []
        for url in self._list_urls():
            # 为每个请求动态伪造 Referer，模拟从百度搜索进入
            referer = f"https://www.baidu.com/s?wd={self.city_subdomain}%20lianjia%20{self.region}"
            self.session.headers.update({
                "Referer": referer
            })
            
            try:
                html = fetch(url, session=self.session, rate_limiter=self.limiter, use_proxy=self.use_proxy)
                items = self._parse_list(html)
                if not items:
                     print(f"[Lianjia] 未找到房源或被拦截: {url}")
                results.extend(items)
                # 随机休眠
                time.sleep(random.uniform(5.0, 10.0))
            except Exception as e:
                print(f"[Lianjia] 获取 {url} 失败: {e}")
        return results
