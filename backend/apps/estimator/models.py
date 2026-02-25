"""
估价历史记录模型模块
------------------
本模块负责定义并存储用户在前端提交的每一次估价请求及其对应的计算结果。
这些数据不仅可以作为用户的历史查询记录，还可以为后续的价格模型优化提供真实的样本支持。
"""
from django.db import models

class EstimationHistory(models.Model):
    """
    【估价历史记录模型】
    ------------------
    该模型记录了房源的所有物理特征（如面积、户型、楼层、特征标签）
    以及估价引擎计算出的基础价格、最终预估价格和波动区间。
    """
    
    # 定义下拉菜单的选项（label 用于后台管理界面展示）
    FLOOR_CHOICES = (
        ('low', '低楼层'),
        ('mid', '中楼层'),
        ('high', '高楼层'),
    )
    DECORATION_CHOICES = (
        ('rough', '毛坯'),
        ('simple', '简装'),
        ('exquisite', '精装'),
    )
    ORIENTATION_CHOICES = (
        ('east', '东'),
        ('west', '西'),
        ('north', '北'),
        ('south', '南'),
    )

    # --- 1. 用户输入的房源物理特征 ---
    region = models.CharField(max_length=100, verbose_name="所在区域")
    area = models.FloatField(verbose_name="建筑面积 (㎡)")
    layout = models.CharField(max_length=50, verbose_name="户型 (如：3室2厅)")
    
    # --- 2. 影响价格的特征标签 ---
    has_subway = models.BooleanField(default=False, verbose_name="是否近地铁")
    is_school_district = models.BooleanField(default=False, verbose_name="是否为学区房")
    floor_type = models.CharField(max_length=10, choices=FLOOR_CHOICES, default='mid', verbose_name="所处楼层")
    building_age = models.IntegerField(default=0, verbose_name="房屋年龄")
    decoration = models.CharField(max_length=10, choices=DECORATION_CHOICES, default='simple', verbose_name="装修程度")
    orientation = models.CharField(max_length=10, choices=ORIENTATION_CHOICES, default='south', verbose_name="房屋朝向")

    # --- 3. 估价引擎输出的计算结果 ---
    # 基础估价：未经过特征系数微调的原始均价
    base_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, verbose_name="基础估价 (万)")
    # 最终估价：经过地铁、学区、折旧等修正后的最终价格
    estimated_price = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="最终预估总价 (万)")
    # 波动区间：给出一个合理的价格参考范围 (±5%)
    price_range_low = models.DecimalField(max_digits=12, decimal_places=2, null=True, verbose_name="参考价格下限 (万)")
    price_range_high = models.DecimalField(max_digits=12, decimal_places=2, null=True, verbose_name="参考价格上限 (万)")
    
    # 自动记录用户的查询时间
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="估价查询时间")

    class Meta:
        verbose_name = "估价记录"
        verbose_name_plural = verbose_name
        ordering = ['-created_at'] # 按时间倒序排列，最新的记录在前

    def __str__(self):
        return f"[{self.created_at.strftime('%Y-%m-%d')}] {self.region} {self.layout} - {self.estimated_price}万"
