from django.db import models


class House(models.Model):
    """
    房源基础数据模型
    用于存储爬虫抓取的二手房房源信息
    """
    title = models.CharField(max_length=255, blank=True, default="")
    region = models.CharField(max_length=100, blank=True, default="")
    area = models.FloatField(null=True, blank=True)  # 面积（平方米）
    layout = models.CharField(max_length=50, blank=True, default="")  # 户型，如“2室1厅”

    # 价格相关
    total_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)  # 总价（万元）
    unit_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)   # 单价（元/平）

    source = models.CharField(max_length=50, blank=True, default="")  # 数据来源，如 Lianjia/Fang/Anjuke
    url = models.URLField(max_length=500, blank=True, default="")     # 房源链接

    crawled_at = models.DateTimeField(auto_now_add=True)  # 抓取时间

    class Meta:
        ordering = ['-id']
        indexes = [
            models.Index(fields=['region']),
            models.Index(fields=['source']),
        ]

    def __str__(self):
        return self.title or f"{self.region} - {self.total_price or 'N/A'}"
