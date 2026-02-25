"""
爬虫抽象基类模块
----------------
本模块定义了所有具体爬虫实现（如房天下、链家等）必须遵循的标准接口。
通过继承 BaseSpider，可以确保不同来源的数据具有一致的结构。
"""
from abc import ABC, abstractmethod

class BaseSpider(ABC):
    """
    爬虫基类 (BaseSpider)。
    所有具体的爬虫类都必须继承此类，并实现核心的 crawl 方法。
    """
    def __init__(self, region=None):
        """
        初始化爬虫基础参数。
        
        参数:
            region (str): 目标抓取区域（如 '白沙洲'）。
        """
        self.region = region

    @abstractmethod
    def crawl(self):
        """
        执行抓取与解析的抽象方法。
        
        子类在实现此方法时，应确保返回的列表项包含以下标准字段：
        - title (str): 房源标题
        - region (str): 所属区域
        - area (float): 建筑面积
        - layout (str): 房屋户型
        - total_price (float): 总价（万元）
        - unit_price (float): 单价（元/㎡）
        - source (str): 数据来源（如 'Fang'）
        - url (str): 详情页唯一链接
        """
        pass
