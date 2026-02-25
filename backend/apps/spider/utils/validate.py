"""
数据合法性校验工具模块
----------------------
用于在数据入库前进行最后的质量把关。
确保抓取到的房源数据完整且数值逻辑合理。
"""

def filter_valid(items):
    """
    【数据完整性过滤】
    筛选出包含必要字段（URL, 标题, 价格, 面积）的房源项。
    """
    valid_items = []
    for item in items:
        # 必须具备唯一标识和基本描述
        if not item.get("url") or not item.get("title"):
            continue
        # 必须具备核心数值数据
        if not item.get("total_price") or not item.get("area"):
            continue
        valid_items.append(item)
    return valid_items

def dedup_by_url(items):
    """
    【内存去重】
    根据 URL 对列表进行去重，确保返回给前端的数据不包含重复项。
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
    【面积逻辑校验】
    判断面积数值是否在人类居住房屋的合理范围内（5㎡ ~ 10000㎡）。
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
    【价格逻辑校验】
    判断总价和单价是否为正数。
    """
    if total_price is None or unit_price is None:
        return False
    try:
        t = float(total_price)
        u = float(unit_price)
        return t > 0 and u > 0
    except (ValueError, TypeError):
        return False
