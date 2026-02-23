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

import logging

logger = logging.getLogger(__name__)

class CrawlView(APIView):
    """
    触发爬虫任务接口。
    """
    def post(self, request):
        # 接收参数
        city_subdomain = request.data.get('city_subdomain', 'bj').strip()
        region = request.data.get('region', '')
        
        # 移除过时的 city_map 和 abbr_to_full 逻辑
        # 因为 FangSpider 现在已经集成了 pypinyin，可以智能处理
        
        # 汉字转拼音逻辑 (Region)
        # 如果包含汉字，转为拼音，例如 '朝阳' -> 'chaoyang'
        if region:
             import re
             from pypinyin import lazy_pinyin
             if re.search(r'[\u4e00-\u9fa5]', region):
                 region = ''.join(lazy_pinyin(region))
        
        # 兼容性处理：如果前端传了 region 且 region 和 city 重复（如 region="武汉" city="武汉"）
        if region and city_subdomain and region == city_subdomain:
             region = None
 
        try:
            mock = request.data.get('mock', False)
            pages = int(request.data.get('pages', 3))
        except (ValueError, TypeError):
            pages = 3

        # Demo/开发环境默认开启 Mock 以保障联调体验
        if not mock and settings.DEBUG:
            mock = True

        # 1. 优先检查数据库是否有相关数据
        # CrawlView 强制执行爬虫逻辑，无需检查数据库是否存在
        
        # 统一处理城市输入：直接传给 FangSpider，由其内部的 _get_subdomain 统一处理
        # 无论是 'wh', 'wuhan', '武汉' 还是 'sh', 'shanghai'
        # FangSpider 现在具备智能识别能力
        target_subdomain = city_subdomain

        # 2. 执行同步爬取
        try:
            from apps.spider.runner import run_all
            logger.info(f"[CrawlView] 开始同步爬取: region={region}, pages={pages}")
            
            # 执行爬取 (同步阻塞)
            # 使用 target_subdomain 传递给爬虫，确保爬虫和数据库查询一致
            items = run_all(region=region, pages=pages, city_subdomain=target_subdomain)
            
            # 写入数据库并收集保存的对象
            count = 0
            # 无论是否新创建，都应该收集起来返回给前端，或者只返回新创建的？
            # 这里的 items 已经是爬虫经过数据库去重后的新数据（如果在 FangSpider 中启用了去重）
            # 或者包含所有抓取的数据（如果没启用去重）
            # FangSpider 现在只返回 valid_items (新数据)
            
            saved_instances = []
            
            for item in items:
                try:
                    # 再次确保 update_or_create
                    obj, created = House.objects.update_or_create(
                        url=item.get('url'),
                        defaults={
                            'title': item.get('title', ''),
                            'region': item.get('region', ''),
                            'area': item.get('area'),
                            'layout': item.get('layout', ''),
                            'total_price': item.get('total_price'),
                            'unit_price': item.get('unit_price'),
                            'source': item.get('source', 'Fang'),
                        }
                    )
                    if created:
                        count += 1
                        logger.info(f"保存新房源: {item.get('title')}")
                    saved_instances.append(obj)
                except Exception as db_err:
                    logger.error(f"[CrawlView] 保存数据失败: {db_err} - {item.get('url')}")
            
            logger.info(f"[CrawlView] 爬虫任务完成，新增入库: {count} 条, 总抓取(新): {len(items)} 条")
            
            return Response({
                "status": "success",
                "message": f"已完成爬取，新增 {count} 条数据",
                "background": False,
                "count": count,
                "data": HouseSerializer(saved_instances, many=True).data
            })
            
        except Exception as e:
            logger.error(f"[CrawlView] 爬虫执行失败: {e}", exc_info=True)
            return Response({"error": f"爬虫执行失败: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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
        
        try:
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
        except Exception as e:
            logger.error(f"HouseListView error: {e}", exc_info=True)
            return Response({"error": "Failed to fetch house list"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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
        
        # 处理中文区域名转拼音
        import re
        if re.search(r'[\u4e00-\u9fa5]', region):
            from pypinyin import lazy_pinyin
            region = ''.join(lazy_pinyin(region))
        
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
