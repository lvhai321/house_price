from django.db import models

class House(models.Model):
    """
    【房源基础数据模型】
    ------------------
    用于持久化存储从各大房产平台（如房天下）抓取到的原始房源信息。
    每一条记录对应一套挂牌出售的二手房。
    """
    # 房源基本信息
    title = models.CharField(max_length=255, blank=True, default="", verbose_name="房源标题")
    region = models.CharField(max_length=100, blank=True, default="", verbose_name="区域板块")
    area = models.FloatField(null=True, blank=True, verbose_name="面积(㎡)")
    layout = models.CharField(max_length=50, blank=True, default="", verbose_name="户型描述")

    # 价格数据
    total_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True, verbose_name="总价(万元)")
    unit_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True, verbose_name="单价(元/㎡)")

    # 来源追踪
    source = models.CharField(max_length=50, blank=True, default="", verbose_name="数据来源")
    url = models.URLField(max_length=500, blank=True, default="", verbose_name="详情页链接")

    # 时间记录
    crawled_at = models.DateTimeField(auto_now_add=True, verbose_name="采集时间")

    class Meta:
        verbose_name = "房源信息"
        verbose_name_plural = verbose_name
        ordering = ['-id']
        # 为区域和来源添加索引，显著提升查询和过滤性能
        indexes = [
            models.Index(fields=['region']),
            models.Index(fields=['source']),
        ]

    def __str__(self):
        return self.title or f"{self.region} - {self.total_price or 'N/A'}万"
