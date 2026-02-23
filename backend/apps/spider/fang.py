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
    房天下 (Fang.com) 二手房爬虫。
    
    主要职责：
    1. 根据城市子域名和可选区域关键字，构造列表页 URL；
    2. 抓取并解析每一页的房源列表，生成结构化字段；
    3. 通过数据库 URL 去重，标记每条房源是否为“新数据”(is_new)；
    4. 按“目标新数据条数”智能翻页，避免无意义的重复抓取。
    
    默认列表页基础结构为：
        https://{city_subdomain}.esf.fang.com/house/i3{page}-kw{region}/
    例如：
        武汉塔子湖 → https://wuhan.esf.fang.com/house/i31-kw武汉/
    """
    def __init__(self, region=None, pages=1, city_subdomain="bj", use_proxy=False):
        """
        初始化房天下爬虫实例。
        
        参数说明：
            region (str):
                - 用于构造搜索关键字 kw，通常为中文，如“武汉”“白沙洲”“塔子湖”；
                - 最终会出现在数据库 region 字段中，组合成“搜索词-实际区域”。
            pages (int):
                - 期望的“新数据页数”，每页约 60 条；
                - 实际翻页数可能大于 pages，以满足“新数据条数”目标。
            city_subdomain (str):
                - 城市子域名输入，支持中文、全拼或常见缩写；
                - 例如 “武汉”“wuhan”“wh” → 统一解析为 wuhan。
            use_proxy (bool):
                - 是否启用代理池访问（当前实现未强制依赖，可按需扩展）。
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
        根据 city_subdomain 输入解析出最终用于拼接 URL 的城市子域名。
        
        解析规则：
        1. 先在 direct_city_map 中查找常见城市及别名（直辖市、少数民族地区、常用缩写等）；
        2. 若包含中文且不在映射表中，则使用 pypinyin 转为全拼（如“孝感”→“xiaogan”）；
        3. 其他情况直接原样返回，认为调用方已经给出了合法的全拼子域名。
        """
        raw_input = self.city_subdomain.lower().strip()
        
        direct_city_map = {
            '北京': 'bj', 'beijing': 'bj', 'bj': 'bj',
            '上海': 'sh', 'shanghai': 'sh', 'sh': 'sh',
            '天津': 'tj', 'tianjin': 'tj', 'tj': 'tj',
            '重庆': 'cq', 'chongqing': 'cq', 'cq': 'cq',
            '武汉': 'wuhan', 'wuhan': 'wuhan', 'wh': 'wuhan',
            '孝感': 'xiaogan', 'xiaogan': 'xiaogan', 'xg': 'xiaogan',
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
        基于当前城市子域名与区域关键字生成列表页 URL 集合。
        
        说明：
            - 当前实现中的 crawl 方法已经自行构造分页 URL，
              _list_urls 保留主要用于调试或扩展，不在主流程中调用；
            - URL 模式统一为：
                https://{subdomain}.esf.fang.com/house/i3{page}-kw{region}/
        返回值：
            list[str]: 列表页 URL 字符串列表。
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
        
        # 城市名称映射（当前主要用于调试和可读性，需要时可通过子域名反查城市名）
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
        
        # 选择所有房源列表项：
        # 房天下通常使用 <dl> 标签承载单个房源，位于 <div class="shop_list"> 内，
        # 或者 id 以 'lp_' 开头的 <dl>。
        dls = soup.select("div.shop_list dl, dl[id^='lp_']")
        
        for dl in dls:
            try:
                # --- 解析标题 (优化：优先使用 小区+户型+面积) ---
                original_title_el = dl.select_one("h4.clearfix a, p.title a, .tit_shop a")
                original_title = original_title_el.get_text(strip=True) if original_title_el else None
                
                # --- 解析房源基本信息 (面积, 户型) ---
                # 这类信息通常出现在 <p class="tel_shop"> 或 <p class="content"> 中，
                # 包含面积、户型、朝向、装修等文本。
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
                # 区域字段策略：
                #   final_region = "搜索关键字-实际区域"
                # 1. 搜索关键字前缀 (self.region)，通常来自前端输入，例如“武汉”“白沙洲”
                search_prefix = self.region if self.region else "未知"
                
                # 2. 实际区域后缀（从页面结构中解析出的更细分区域，如“塔子湖”）
                extracted_suffix = "未知"
                
                # 从 p.add_shop span 中提取区域信息（例如 "塔子湖" 或 "白沙洲"）
                add_shop_span = dl.select_one("p.add_shop span")
                if add_shop_span:
                    span_text = add_shop_span.get_text(strip=True)
                    # 通常是 "区域 地址" 或 "区域 商圈 地址"
                    # 取第一个空格前的内容
                    parts = span_text.split()
                    if parts:
                        extracted_suffix = parts[0] # 例如 "塔子湖"
                
                # 组合最终区域字段，示例："武汉-塔子湖"
                final_region = f"{search_prefix}-{extracted_suffix}"
                
                # --- URL 清理与补全 ---
                if url.startswith("/"):
                    # 使用 _get_subdomain 获取正确的全拼 (如 xiaogan)
                    subdomain = self._get_subdomain()
                    domain = "esf.fang.com" if subdomain == 'bj' else f"{subdomain}.esf.fang.com"
                    url = f"https://{domain}{url}"

                # 构造房源数据字典
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
            except Exception as e:
                continue
                
        return items

    def crawl(self):
        """
        执行完整爬取流程。
        
        主要步骤：
            1. 根据城市子域名和区域关键字构造每一页的列表 URL；
            2. 抓取 HTML 并调用 _parse_list 解析出房源数据；
            3. 通过数据库 URL 去重，标记 is_new 字段（新/旧房源）；
            4. 依据“目标新数据条数”智能控制翻页与停止条件。
        
        返回值：
            list[dict]: 包含新旧房源混合的列表，每条记录附带:
                - is_new (bool): True 表示数据库中不存在该 URL，为本次新增数据。
        """
        results = []
        # 尝试动态导入 House 模型以进行去重检查
        try:
            from apps.spider.models import House
            db_check_available = True
        except ImportError:
            db_check_available = False

        # 智能翻页逻辑：
        # 目标是尽可能收集到足够数量的“新”数据
        # 假设每页约 60 条数据，目标新数据数量 = pages * 60
        target_new = self.pages * 60
        new_collected = 0
        total_collected = 0
        
        current_page = 1
        consecutive_empty_pages = 0 # 连续空页计数（防死循环）
        
        subdomain = self._get_subdomain()
        base = f"https://{subdomain}.esf.fang.com"

        print(f"[Fang] 开始爬取，目标: {self.pages} 页 (约 {target_new} 条新数据)")

        # 为防止极端情况下无限翻页，这里设置一个最大页数上限
        max_pages = max(self.pages * 5, self.pages)

        while new_collected < target_new and current_page <= max_pages:
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

                # 数据库去重逻辑与状态标记
                # 我们不再直接丢弃旧数据，而是标记它们，以便统计和返回
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
                        print(f"[Fang] 数据库去重检查失败: {db_e}")
                        # 降级：全部标记为未知或新
                        for item in items: item['is_new'] = True
                        new_items_count = len(items)
                else:
                    for item in items: item['is_new'] = True
                    new_items_count = len(items)

                # 智能翻页判断
                if len(items) > 0 and new_items_count == 0:
                    print(f"[Fang] 第 {current_page} 页全是旧数据 ({len(items)}条)，但仍返回数据以便更新...")
                    # 即使全是旧数据，也将其添加到结果中，以便上层逻辑可以更新这些数据的价格等信息
                    # 并且前端需要展示完整列表
                    pass 
                
                print(f"[Fang] 第 {current_page} 页抓取 {len(items)} 条数据 (新增: {new_items_count})。")
                
                # 返回所有数据（含旧数据）
                if items:
                    results.extend(items)
                    # 计数逻辑：如果我们的目标是收集“新”数据，这里应该只加 new_items_count
                    # 但为了防止因全是旧数据而导致的无限翻页（死循环/超时），
                    # 我们采用混合策略：只要抓到了有效数据（无论新旧），都算进度。
                    # 这样可以保证爬虫在达到目标新数据或页数上限后正常结束，不会一直空转。
                    total_collected += len(items)
                    new_collected += new_items_count
                    print(f"[Fang] 当前进度: new={new_collected}/{target_new}, total={total_collected}")

                current_page += 1
                
                # 随机休眠
                time.sleep(random.uniform(1.0, 3.0))

            except Exception as e:
                print(f"[Fang] 获取 {url} 失败: {e}")
                # 网络错误（如连接拒绝/超时）通常意味着整个任务无法继续，而不是这一页有问题
                # 因此我们应该立即停止，而不是无意义地重试下一页
                print("[Fang] 发生网络异常，停止当前任务。")
                break
                
        return results
