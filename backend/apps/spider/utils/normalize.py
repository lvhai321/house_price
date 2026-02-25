"""
数据清洗与标准化工具模块
----------------------
提供一系列辅助函数，用于将爬虫抓取到的非结构化文本（如“150万”、“90平米”）
清洗并转换为后端统一的数值格式。
"""
import re

def to_total_price_wan(text):
    """
    【总价标准化】
    将包含“万”字或空格的价格字符串转换为浮点数。
    
    示例: "120.5万" -> 120.5, " 300 " -> 300.0
    """
    if not text:
        return None
    try:
        clean_text = text.replace("万", "").strip()
        # 使用正则提取数字和小数点
        match = re.search(r"[\d.]+", clean_text)
        if match:
            return float(match.group())
    except ValueError:
        pass
    return None

def to_area_m2(text):
    """
    【面积标准化】
    移除单位后缀（平米, m²等），保留纯数字面积。
    
    示例: "89.5平米" -> 89.5, "120m²" -> 120.0
    """
    if not text:
        return None
    try:
        clean_text = text.replace("平米", "").replace("m²", "").strip()
        match = re.search(r"[\d.]+", clean_text)
        if match:
            return float(match.group())
    except ValueError:
        pass
    return None

def compute_unit_price(total_price_wan, area_m2):
    """
    【单价计算】
    根据总价（万元）和面积（㎡）自动计算出每平米单价（元）。
    
    公式: (总价 * 10000) / 面积
    """
    if not total_price_wan or not area_m2 or area_m2 == 0:
        return None
    try:
        unit_price = (total_price_wan * 10000) / area_m2
        return round(unit_price, 2)
    except Exception:
        return None
