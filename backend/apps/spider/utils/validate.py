def filter_valid(items):
    """
    过滤无效的房源数据。
    必须包含: url, title, total_price, area
    """
    valid_items = []
    for item in items:
        if not item.get("url") or not item.get("title"):
            continue
        if not item.get("total_price") or not item.get("area"):
            continue
        valid_items.append(item)
    return valid_items

def dedup_by_url(items):
    """
    根据 URL 去重。
    保留第一个出现的项。
    """
    seen_urls = set()
    unique_items = []
    for item in items:
        url = item.get("url")
        if url and url not in seen_urls:
            seen_urls.add(url)
            unique_items.append(item)
    return unique_items

def is_valid_area(area):
    """
    验证面积是否合理。
    例如: 5平米 < area < 10000平米
    """
    if area is None:
        return False
    try:
        val = float(area)
        return 5.0 <= val <= 10000.0
    except (ValueError, TypeError):
        return False

def is_valid_price(total_price, unit_price):
    """
    验证价格是否合理。
    例如: 总价 > 0, 单价 > 0
    """
    if total_price is None or unit_price is None:
        return False
    try:
        t = float(total_price)
        u = float(unit_price)
        return t > 0 and u > 0
    except (ValueError, TypeError):
        return False
