from concurrent.futures import ThreadPoolExecutor, as_completed
from apps.spider.fang import FangSpider
from apps.spider.utils.validate import filter_valid, dedup_by_url, is_valid_area, is_valid_price
from django.utils import timezone
from apps.spider.models import House
import logging


def run_all(region, pages=3, max_daily=1000, city_subdomain=None):
    """
    爬虫调度核心入口。
    ----------------
    该函数负责启动并管理所有的爬虫实例。
    
    主要流程：
    1. 城市自动识别：如果没有提供城市子域名，根据区域关键字自动推断（默认北京）。
    2. 多线程抓取：使用 ThreadPoolExecutor 并发运行多个爬虫任务（目前主抓房天下）。
    3. 数据质量监控：实时统计抓取过程中的空字段、无效面积、异常价格等数据质量指标。
    4. 结果清洗：
        - 基于 URL 进行全局去重。
        - 过滤掉关键字段缺失或不符合逻辑（如单价 0 元）的脏数据。
    5. 配额控制：根据 max_daily 限制每日抓取的总量，防止过度爬取。
    """
    logger = logging.getLogger("spider.runner")
    
    # 1. 城市识别逻辑
    if not city_subdomain:
        if region in ("wuhan", "武汉"):
            city_subdomain = "wuhan"
        else:
            city_subdomain = "bj"
            
    # 2. 初始化爬虫实例列表（未来可在此处添加更多平台的爬虫）
    spiders = [
        FangSpider(region=region, pages=pages, city_subdomain=city_subdomain, use_proxy=False),
    ]
    
    results = []
    stats = {} # 用于存储各平台的质量统计数据
    
    # 3. 启动并发抓取任务
    # 设置 max_workers=5，兼顾抓取效率与服务器负载
    with ThreadPoolExecutor(max_workers=5) as ex:
        futures = [ex.submit(sp.crawl) for sp in spiders]
        for fut in as_completed(futures):
            try:
                data = fut.result()
                if data:
                    results.extend(data)
                    # 质量分析统计
                    for x in data:
                        src = x.get("source", "unknown")
                        s = stats.setdefault(src, {"total": 0, "missing_url": 0, "missing_title": 0, "missing_area": 0, "invalid_area": 0, "missing_price": 0, "invalid_price": 0})
                        s["total"] += 1
                        if not x.get("url"): s["missing_url"] += 1
                        if not x.get("title"): s["missing_title"] += 1
                        if x.get("area") is None: s["missing_area"] += 1
                        else:
                            if not is_valid_area(x.get("area")): s["invalid_area"] += 1
                        if x.get("total_price") is None or x.get("unit_price") is None:
                            s["missing_price"] += 1
                        else:
                            if not is_valid_price(x.get("total_price"), x.get("unit_price")):
                                s["invalid_price"] += 1
            except Exception as e:
                logger.error(f"调度器执行子爬虫任务出错: {e}")
                
    # 4. 数据后处理
    before_dedup = len(results)
    # 基于唯一链接去重
    results = dedup_by_url(results)
    duplicates_removed = before_dedup - len(results)
    
    # 过滤掉不合规的房源
    results = filter_valid(results)
    
    # 5. 打印并记录本次抓取的详细统计摘要
    for src, s in stats.items():
        valid_src = sum(1 for x in results if x.get("source") == src)
        hit_rate = (valid_src / s["total"]) if s["total"] else 0.0
        msg = f"[{src}] 抓取报告: 总计={s['total']}, 有效={valid_src}, 转化率={hit_rate:.1%}"
        logger.info(msg)
        print(msg)
        
    # 6. 每日抓取上限控制
    today = timezone.now().date()
    today_count = House.objects.filter(crawled_at__date=today).count()
    remaining = max(0, max_daily - today_count)
    
    if remaining <= 0:
        logger.warning("今日抓取配额已耗尽，请明天再试。")
        return []
        
    return results[:remaining]
