"""
数据序列化器
负责将数据库模型对象转换为 JSON 格式，以便前端使用
"""
from rest_framework import serializers
from apps.spider.models import House
from apps.estimator.models import EstimationHistory

class HouseSerializer(serializers.ModelSerializer):
    class Meta:
        model = House
        fields = [
            'id', 'title', 'region', 'area', 'layout',
            'total_price', 'unit_price', 'source', 'url', 'crawled_at'
        ]

class EstimationHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = EstimationHistory
        fields = '__all__'

class EstimateRequestSerializer(serializers.Serializer):
    region = serializers.CharField(max_length=100)
    area = serializers.FloatField(min_value=10, max_value=500)
    layout = serializers.CharField(max_length=50)
    has_subway = serializers.BooleanField(required=False, default=False)
    is_school_district = serializers.BooleanField(required=False, default=False)
    floor_type = serializers.ChoiceField(choices=[('low', '低楼层'), ('mid', '中楼层'), ('high', '高楼层')], default='mid')
    building_age = serializers.IntegerField(min_value=0, max_value=100, default=0)
    decoration = serializers.ChoiceField(choices=[('rough', '毛坯'), ('simple', '简装'), ('exquisite', '精装')], default='simple')
    orientation = serializers.ChoiceField(choices=[('east', '东'), ('west', '西'), ('north', '北'), ('south', '南')], default='south')
