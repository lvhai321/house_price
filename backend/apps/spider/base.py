"""
爬虫基类模块
定义了所有具体爬虫实现必须遵循的抽象基类。
"""
from abc import ABC, abstractmethod

class BaseSpider(ABC):
    """
    爬虫抽象基类。
    所有具体的爬虫类（如 FangSpider, LianjiaSpider）都必须继承此类并实现 crawl 方法。
    """
    def __init__(self, region=None):
        """
        初始化爬虫。
        
        参数:
            region (str): 要爬取的区域名称（例如 'chaoyang', 'haidian'）。默认为 None。
        """
        self.region = region

    @abstractmethod
    def crawl(self):
        """
        执行爬取逻辑的抽象方法。
        子类必须实现此方法，完成具体的页面请求和数据解析。
        
        返回:
            list: 包含字典的列表，每个字典代表一个房源信息，应包含以下字段：
                  - title: 房源标题
                  - region: 区域
                  - area: 面积 (平方米)
                  - layout: 户型 (如 '2室1厅')
                  - total_price: 总价 (万元)
                  - unit_price: 单价 (元/平米)
                  - source: 来源 (如 'Fang', 'Lianjia')
                  - url: 房源详情页链接
        """
        pass
