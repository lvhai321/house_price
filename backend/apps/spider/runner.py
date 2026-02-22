from concurrent.futures import ThreadPoolExecutor, as_completed
from apps.spider.lianjia import LianjiaSpider
from apps.spider.fang import FangSpider
from apps.spider.anjuke import AnjukeSpider
from apps.spider.utils.validate import filter_valid, dedup_by_url, is_valid_area, is_valid_price
from django.utils import timezone
from apps.spider.models import House
import logging


def run_all(region, pages=3, max_daily=1000, city_subdomain=None):
    logger = logging.getLogger("spider.runner")
    if not city_subdomain:
        if region in ("wuhan", "武汉"):
            city_subdomain = "wh"
        else:
            city_subdomain = "bj"
    spiders = [
        # LianjiaSpider(region=region, pages=pages, city_subdomain=city_subdomain),
        FangSpider(region=region, pages=pages, city_subdomain=city_subdomain),
        # AnjukeSpider(region=region, pages=pages, city_subdomain=city_subdomain)
    ]
    results = []
    stats = {}
    # 使用 max_workers=5 以提高性能
    with ThreadPoolExecutor(max_workers=5) as ex:
        futures = [ex.submit(sp.crawl) for sp in spiders]
        for fut in as_completed(futures):
            try:
                data = fut.result()
                if data:
                    results.extend(data)
                    for x in data:
                        src = x.get("source", "unknown")
                        s = stats.setdefault(src, {"total": 0, "missing_url": 0, "missing_title": 0, "missing_area": 0, "invalid_area": 0, "missing_price": 0, "invalid_price": 0})
                        s["total"] += 1
                        if not x.get("url"):
                            s["missing_url"] += 1
                        if not x.get("title"):
                            s["missing_title"] += 1
                        if x.get("area") is None:
                            s["missing_area"] += 1
                        else:
                            if not is_valid_area(x.get("area")):
                                s["invalid_area"] += 1
                        if x.get("total_price") is None or x.get("unit_price") is None:
                            s["missing_price"] += 1
                        else:
                            if not is_valid_price(x.get("total_price"), x.get("unit_price")):
                                s["invalid_price"] += 1
            except Exception as e:
                print(f"[Runner] 爬虫执行出错: {e}")
                logger.error(f"爬虫执行出错: {e}")
    before_dedup = len(results)
    results = dedup_by_url(results)
    duplicates_removed = before_dedup - len(results)
    print(f"[Runner] Raw items: {before_dedup}, After dedup: {len(results)}, Duplicates: {duplicates_removed}")
    
    results = filter_valid(results)
    print(f"[Runner] After validation: {len(results)}")
    
    for src, s in stats.items():
        valid_src = sum(1 for x in results if x.get("source") == src)
        hit_rate = (valid_src / s["total"]) if s["total"] else 0.0
        msg = f"[{src}] total={s['total']} valid={valid_src} hit_rate={hit_rate:.3f} missing_url={s['missing_url']} missing_title={s['missing_title']} missing_area={s['missing_area']} invalid_area={s['invalid_area']} missing_price={s['missing_price']} invalid_price={s['invalid_price']}"
        logger.info(msg)
        print(msg)
        
    logger.info(f"[global] before_dedup={before_dedup} after_dedup={len(results)} duplicates_removed={duplicates_removed}")
    
    today = timezone.now().date()
    today_count = House.objects.filter(crawled_at__date=today).count()
    remaining = max(0, max_daily - today_count)
    if remaining <= 0:
        return []
    return results[:remaining]
