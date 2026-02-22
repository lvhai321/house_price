"""
估价历史模型模块
用于记录用户的查询历史和系统的估价结果，便于后续分析和模型优化。
"""
from django.db import models

class EstimationHistory(models.Model):
    """
    估价记录模型。
    存储每一次用户提交的估价请求参数及系统计算出的结果。
    """
    # 楼层选项
    FLOOR_CHOICES = (
        ('low', '低楼层'),
        ('mid', '中楼层'),
        ('high', '高楼层'),
    )
    # 装修选项
    DECORATION_CHOICES = (
        ('rough', '毛坯'),
        ('simple', '简装'),
        ('exquisite', '精装'),
    )
    # 朝向选项
    ORIENTATION_CHOICES = (
        ('east', '东'),
        ('west', '西'),
        ('north', '北'),
        ('south', '南'),
    )

    # --- 基础输入信息 ---
    region = models.CharField(max_length=100, verbose_name="区域")
    area = models.FloatField(verbose_name="面积")
    layout = models.CharField(max_length=50, verbose_name="户型")
    
    # --- 高级特征输入 ---
    has_subway = models.BooleanField(default=False, verbose_name="近地铁")
    is_school_district = models.BooleanField(default=False, verbose_name="学区房")
    floor_type = models.CharField(max_length=10, choices=FLOOR_CHOICES, default='mid', verbose_name="楼层")
    building_age = models.IntegerField(default=0, verbose_name="房龄")
    decoration = models.CharField(max_length=10, choices=DECORATION_CHOICES, default='simple', verbose_name="装修")
    orientation = models.CharField(max_length=10, choices=ORIENTATION_CHOICES, default='south', verbose_name="朝向")

    # --- 估价结果输出 ---
    base_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, verbose_name="基础估价")
    estimated_price = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="最终估价")
    price_range_low = models.DecimalField(max_digits=12, decimal_places=2, null=True, verbose_name="估价下限")
    price_range_high = models.DecimalField(max_digits=12, decimal_places=2, null=True, verbose_name="估价上限")
    
    # 记录创建时间
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="查询时间")

    class Meta:
        verbose_name = "估价记录"
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.region} {self.layout} - {self.estimated_price}万"
