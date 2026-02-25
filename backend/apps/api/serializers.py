"""
REST API 数据序列化模块
----------------------
本模块定义了 Django 模型与 JSON 格式之间的转换规则。
序列化器负责将复杂的数据库查询结果转换为前端可直接使用的标准 JSON 对象，
同时也负责对前端提交的 POST 请求数据进行合法性校验。
"""
from rest_framework import serializers
from apps.spider.models import House
from apps.estimator.models import EstimationHistory

class HouseSerializer(serializers.ModelSerializer):
    """
    【房源模型序列化器】
    用于将 House 数据库记录转换为房源详情列表（用于前端展示）。
    """
    class Meta:
        model = House
        fields = [
            'id', 'title', 'region', 'area', 'layout',
            'total_price', 'unit_price', 'source', 'url', 'crawled_at'
        ]

class EstimationHistorySerializer(serializers.ModelSerializer):
    """
    【估价历史序列化器】
    用于记录和查询用户的历史估价请求。
    """
    class Meta:
        model = EstimationHistory
        fields = '__all__'

class EstimateRequestSerializer(serializers.Serializer):
    """
    【估价请求校验器】
    专门用于校验前端发送的估价表单参数。
    包含了房源的各项物理特征，如面积、户型、楼层、朝向等。
    """
    region = serializers.CharField(max_length=100, help_text="房源所在区域")
    area = serializers.FloatField(min_value=10, max_value=1000, help_text="房屋面积 (㎡)")
    layout = serializers.CharField(max_length=50, help_text="户型描述 (如：3室2厅)")
    has_subway = serializers.BooleanField(required=False, default=False, help_text="是否近地铁")
    is_school_district = serializers.BooleanField(required=False, default=False, help_text="是否为学区房")
    
    # 使用 ChoiceField 确保传入的楼层、装修、朝向符合后端预设值
    floor_type = serializers.ChoiceField(
        choices=[('low', '低楼层'), ('mid', '中楼层'), ('high', '高楼层')], 
        default='mid'
    )
    building_age = serializers.IntegerField(min_value=0, max_value=100, default=0, help_text="房龄")
    decoration = serializers.ChoiceField(
        choices=[('rough', '毛坯'), ('simple', '简装'), ('exquisite', '精装')], 
        default='simple'
    )
    orientation = serializers.ChoiceField(
        choices=[('east', '东'), ('west', '西'), ('north', '北'), ('south', '南')], 
        default='south'
    )
