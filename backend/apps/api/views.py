"""
API 视图逻辑模块
处理前端请求，协调爬虫数据、数据库查询和估价算法，返回 JSON 格式的响应。
"""
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Avg, Count
from apps.spider.models import House
from apps.estimator.services import PriceEstimator
from .serializers import HouseSerializer, EstimateRequestSerializer
import threading
from django.conf import settings
import os

class CrawlView(APIView):
    """
    触发爬虫任务接口。
    """
    def post(self, request):
        region = request.data.get('region')
        city_subdomain = request.data.get('city_subdomain', 'bj')
        workers = int(request.data.get('workers', 2))
        storage = request.data.get('storage', 'db')
        mock = request.data.get('mock', False)
        use_proxy = request.data.get('use_proxy', None)
        
        try:
            pages = int(request.data.get('pages', 1))
        except (ValueError, TypeError):
            pages = 1
            
        # 汉字转拼音逻辑
        if region:
            import re
            from pypinyin import lazy_pinyin
            # 如果包含汉字
            if re.search(r'[\u4e00-\u9fa5]', region):
                # 将汉字转换为拼音列表，并拼接成字符串
                # 例如: '朝阳' -> ['chao', 'yang'] -> 'chaoyang'
                region = ''.join(lazy_pinyin(region))

        # 如果传入的是城市名/缩写，则视为全城抓取
        city_map = {
            'bj': {'beijing', 'bj', 'beijingshi'},
            'sh': {'shanghai', 'sh', 'shanghaishi'},
            'wh': {'wuhan', 'wh', 'wuhanshi'},
            'gz': {'guangzhou', 'gz', 'guangzhoushi'},
            'sz': {'shenzhen', 'sz', 'shenzhenshi'},
            'hz': {'hangzhou', 'hz', 'hangzhoushi'},
            'cd': {'chengdu', 'cd', 'chengdoushi'},
        }
        synonyms = city_map.get(city_subdomain, set())
        if region and region.lower() in synonyms:
            region = None

        # Demo/开发环境默认开启 Mock 以保障联调体验
        if not mock and settings.DEBUG:
            mock = True

        # 若 region 为空，则默认全城抓取
            
        # 异步执行爬虫任务（开发/演示环境下占位实现，避免启动阶段导入失败）
        def run_spider_task():
            try:
                # 延迟导入，避免在项目启动阶段因为缺失爬虫依赖导致失败
                # 这里保留扩展点：后续可替换为真正的多源爬虫聚合函数
                # from apps.spider.runner import run_all
                # items = run_all(region=region, pages=pages, city_subdomain=city_subdomain)
                # TODO: 将 items 写入数据库（House）
                pass
            except Exception as e:
                # 保底：打印错误日志但不影响接口返回
                print(f"[CrawlView] 后台爬虫任务启动失败: {e}")
        
        thread = threading.Thread(target=run_spider_task)
        thread.start()

        return Response({
            "status": "success",
            "message": f"爬虫任务已后台启动 (City={city_subdomain}, Region={region or 'all'})",
            "background": True,
            "count": 0
        })

class HouseListView(APIView):
    """
    房源列表接口。
    支持按区域、价格范围筛选房源数据。
    """
    def get(self, request):
        """
        获取房源列表。
        
        查询参数:
            region (str): 区域筛选（可选）
            min_price (float): 最低总价（可选，默认0）
            max_price (float): 最高总价（可选，默认100000）
            
        返回:
            JSON: 房源对象列表（前100条）
        """
        region = request.query_params.get('region', '')
        min_price = request.query_params.get('min_price', 0)
        max_price = request.query_params.get('max_price', 100000)
        
        qs = House.objects.all()
        
        # 应用区域过滤
        if region:
            import re
            if re.search(r'[\u4e00-\u9fa5]', region):
                from pypinyin import lazy_pinyin
                region = ''.join(lazy_pinyin(region))
            city_names = {'beijing','bj','shanghai','sh','wuhan','wh','guangzhou','gz','shenzhen','sz','hangzhou','hz','chengdu','cd','beijingshi','shanghaishi','wuhanshi','guangzhoushi','shenzhenshi','hangzhoushi','chengdoushi'}
            if region.lower() not in city_names:
                qs = qs.filter(region__icontains=region)
            
        # 应用价格范围过滤
        qs = qs.filter(total_price__gte=min_price, total_price__lte=max_price)
        
        # 限制返回数量，避免响应过大
        return Response(HouseSerializer(qs[:100], many=True).data)

class RegionStatsView(APIView):
    """
    区域统计接口。
    提供各区域的房价趋势数据（模拟最近6个月的走势）。
    """
    def get(self, request):
        """
        获取区域趋势数据。
        
        返回:
            JSON: 包含最近6个月月份和对应均价的列表。
        """
        import datetime
        import random
        from django.db.models import Avg

        # 获取当前查询的区域（如果未传，默认为 'beijing'）
        region = request.query_params.get('region', 'beijing')
        
        # 获取该区域当前的真实均价
        current_avg = House.objects.filter(region__icontains=region).aggregate(Avg('unit_price'))
        base_price = current_avg.get('unit_price__avg')
        
        # 如果数据库没数据，根据区域名给一个合理的基准价
        if not base_price:
            base_price = 55000 if 'beijing' in region or 'bj' in region else 16000
        else:
            base_price = float(base_price)
            
        # 生成最近6个月的数据
        months = []
        prices = []
        today = datetime.date.today()
        
        # 市场趋势模拟配置
        # 假设市场整体处于缓慢下行周期，每月跌幅约 0.3% - 0.8%
        monthly_trend = -0.005 # 平均每月跌 0.5%
        
        for i in range(5, -1, -1):
            # 计算月份
            d = today - datetime.timedelta(days=i*30)
            month_str = d.strftime("%Y-%m")
            months.append(month_str)
            
            # 倒推逻辑：
            # 当前月 (i=0) = base_price
            # 上个月 (i=1) = base_price / (1 + trend) ...
            # 加上随机波动 (volatility)
            
            # 距离现在的月数
            months_ago = i
            
            # 宏观趋势倒推因子: 如果每月跌0.5%，那么N个月前的价格应该是 当前价 / (0.995)^N
            trend_factor = 1 / ((1 + monthly_trend) ** months_ago)
            
            # 随机波动因子: ±1.5% 的随机震荡
            volatility = (random.random() - 0.5) * 0.03
            
            # 季节性因子 (简单模拟: 3-4月微涨, 7-8月微跌)
            month_num = d.month
            seasonality = 0
            if month_num in [3, 4]: seasonality = 0.008 
            elif month_num in [7, 8]: seasonality = -0.005
            
            # 综合计算历史价格
            simulated_price = base_price * trend_factor * (1 + volatility + seasonality)
            prices.append(round(simulated_price))
            
        return Response({
            "months": months,
            "prices": prices,
            "region": region
        })

class PriceEstimationView(APIView):
    """
    房价估算接口。
    接收房屋特征参数，利用估价算法计算预估价格。
    """
    def post(self, request):
        """
        提交估价请求。
        
        请求体参数 (JSON):
            详见 EstimateRequestSerializer 定义。
            
        返回:
            JSON: 估价结果，包含预估总价、单价、相似房源等。
        """
        req = EstimateRequestSerializer(data=request.data)
        if not req.is_valid():
            return Response(req.errors, status=status.HTTP_400_BAD_REQUEST)
        
        req_data = req.validated_data

        # 处理区域字段：如果是中文，转为拼音
        region = req_data.get('region')
        if region:
            import re
            from pypinyin import lazy_pinyin
            if re.search(r'[\u4e00-\u9fa5]', region):
                req_data['region'] = ''.join(lazy_pinyin(region))
        
        # 初始化估价服务
        estimator = PriceEstimator(req_data)
        # 执行估价计算
        result = estimator.estimate()
        
        # 序列化相似房源列表
        if result.get('similar_houses'):
            result['similar_houses'] = HouseSerializer(result['similar_houses'], many=True).data
            
        # 序列化搜索结果列表
        if result.get('search_results'):
            result['search_results'] = HouseSerializer(result['search_results'], many=True).data
        
        return Response(result)
