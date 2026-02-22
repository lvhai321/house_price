import re

def to_total_price_wan(text):
    """
    将总价字符串（如 "100万" 或 "100"）转换为 float (单位: 万)。
    """
    if not text:
        return None
    try:
        # 移除 "万" 和空格
        clean_text = text.replace("万", "").strip()
        # 匹配数字部分
        match = re.search(r"[\d.]+", clean_text)
        if match:
            return float(match.group())
    except ValueError:
        pass
    return None

def to_area_m2(text):
    """
    将面积字符串（如 "88平米"）转换为 float (单位: 平方米)。
    """
    if not text:
        return None
    try:
        # 移除 "平米", "m²" 等常见单位
        clean_text = text.replace("平米", "").replace("m²", "").strip()
        # 匹配数字部分
        match = re.search(r"[\d.]+", clean_text)
        if match:
            return float(match.group())
    except ValueError:
        pass
    return None

def compute_unit_price(total_price_wan, area_m2):
    """
    计算单价 (单位: 元/平米)。
    """
    if not total_price_wan or not area_m2 or area_m2 == 0:
        return None
    try:
        # 总价单位是万，需要乘以 10000
        unit_price = (total_price_wan * 10000) / area_m2
        return round(unit_price, 2)
    except Exception:
        return None
