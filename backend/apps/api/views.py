"""
API 接口逻辑模块
----------------
本模块负责处理前端发送的所有 RESTful API 请求。
它作为“调度中心”，协调爬虫模块、估价算法模块以及数据库查询，
最终将处理结果以标准的 JSON 格式返回给前端。
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

# 初始化日志记录器，用于在控制台和日志文件中记录 API 的运行状态
logger = logging.getLogger(__name__)

class CrawlView(APIView):
    """
    【爬虫触发接口】
    
    主要功能：
        - 接收前端提交的城市（子域名）、区域名称以及想要抓取的页数。
        - 实时启动后端爬虫（FangSpider）前往房天下抓取最新的房源挂牌信息。
        - 自动完成数据去重：
            - 如果是新房源，则创建新记录；
            - 如果是已存在的房源，则更新其最新的价格信息。
        - 任务完成后，返回该区域下“最新抓取 + 历史存储”的完整房源列表，供前端展示。
    
    前端调用：
        - 用户在“更新房源数据”弹窗中点击“开始更新”时调用。
    """
    def post(self, request):
        # 1. 解析前端传来的参数
        # city_subdomain: 城市标识，如 'bj' 代表北京，'wuhan' 代表武汉
        city_subdomain = request.data.get('city_subdomain', 'bj').strip()
        # region: 搜索关键字，如“白沙洲”
        region = request.data.get('region', '')
        
        original_region = region.strip() if isinstance(region, str) else ''
        
        # 兼容性逻辑：如果用户输入的区域和城市相同（例如 城市="武汉", 区域="武汉"）
        # 我们认为用户想看的是整个城市的数据，因此将具体区域设为空，以便抓取全城。
        if original_region and city_subdomain and original_region == city_subdomain:
             region = None
        else:
             region = original_region
 
        try:
            mock = request.data.get('mock', False)
            # pages: 打算抓取的页数，每页大约包含 60 条房源数据
            pages = int(request.data.get('pages', 1))
        except (ValueError, TypeError):
            pages = 1

        # 在开发调试环境下，默认开启 Mock 模式以加快反馈速度
        if not mock and settings.DEBUG:
            mock = True

        target_subdomain = city_subdomain

        # 2. 调用爬虫核心逻辑
        try:
            from apps.spider.runner import run_all
            logger.info(f"[CrawlView] 开始同步抓取数据: 区域={region}, 页数={pages}")
            
            # run_all 是爬虫的入口函数，它会返回一个包含房源字典的列表
            items = run_all(region=region, pages=pages, city_subdomain=target_subdomain)
            
            # 3. 将抓取到的数据保存到数据库
            count = 0  # 记录本次新增的房源数量
            saved_instances = [] # 存储本次处理的数据库对象
            
            for item in items:
                try:
                    # 使用 update_or_create 确保数据不重复
                    # url 是房源的唯一标识
                    obj, created = House.objects.update_or_create(
                        url=item.get('url'),
                        defaults={
                            'title': item.get('title', ''),
                            'region': item.get('region', ''),
                            'area': item.get('area'),
                            'layout': item.get('layout', ''),
                            'total_price': item.get('total_price'),
                            'unit_price': item.get('unit_price'),
                            'source': item.get('source', 'Fang'), # 来源标记为房天下
                        }
                    )
                    if created:
                        count += 1
                        logger.info(f"成功保存新房源: {item.get('title')}")
                    saved_instances.append(obj)
                except Exception as db_err:
                    logger.error(f"[CrawlView] 数据库保存失败: {db_err} - 链接: {item.get('url')}")
            
            logger.info(f"[CrawlView] 爬虫任务结束。新增: {count} 条, 总处理: {len(items)} 条")
            
            # 4. 获取该区域的最新完整列表返回给前端
            # 这样用户在更新完数据后，能立刻在“搜索结果”中看到最新的房源情况
            try:
                qs = House.objects.all()
                if original_region:
                    # 使用模糊匹配查找该区域房源
                    qs = qs.filter(region__icontains=original_region)
                # 限制返回前 500 条，防止前端渲染卡顿
                combined_instances = list(qs.order_by('-id')[:500])
                total_count = qs.count()
            except Exception as agg_err:
                logger.error(f"[CrawlView] 聚合查询失败: {agg_err}")
                combined_instances = saved_instances
                total_count = len(saved_instances)
            
            return Response({
                "status": "success",
                "message": f"数据更新成功！本次新增 {count} 条房源。",
                "background": False,
                "new_count": count,
                "total": total_count,
                "data": HouseSerializer(combined_instances, many=True).data
            })
            
        except Exception as e:
            logger.error(f"[CrawlView] 爬虫运行异常: {e}", exc_info=True)
            return Response({"error": f"后台爬虫运行失败: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class HouseListView(APIView):
    """
    【房源列表查询接口】
    
    主要功能：
        - 根据前端传来的“区域”关键词进行模糊匹配。
        - 支持按总价范围（最高/最低）进行筛选。
        - 用于首页底部的“搜索结果”选项卡，让用户查看库中已有的房源。
    """
    def get(self, request):
        # 获取查询参数
        region = request.query_params.get('region', '')
        min_price = request.query_params.get('min_price', 0)
        max_price = request.query_params.get('max_price', 100000)
        
        try:
            qs = House.objects.all()
            
            # 区域过滤逻辑
            if region:
                # 定义城市级关键词。如果用户搜索的是城市名（如“北京”），我们返回全城数据。
                city_keywords = {
                    'beijing','bj','shanghai','sh','wuhan','wh',
                    'guangzhou','gz','shenzhen','sz','hangzhou','hz',
                    'chengdu','cd','beijingshi','shanghaishi','wuhanshi',
                    'guangzhoushi','shenzhenshi','hangzhoushi','chengdoushi',
                    '北京','上海','武汉','广州','深圳','杭州','成都'
                }
                # 如果不是全城搜索，则执行模糊匹配（例如匹配“白沙洲”）
                if region.lower() not in city_keywords and region not in city_keywords:
                    qs = qs.filter(region__icontains=region)
                
            # 价格范围过滤
            qs = qs.filter(total_price__gte=min_price, total_price__lte=max_price)
            
            # 默认只返回前 100 条最相关的房源，兼顾速度与体验
            return Response(HouseSerializer(qs[:100], many=True).data)
        except Exception as e:
            logger.error(f"查询房源列表出错: {e}", exc_info=True)
            return Response({"error": "获取房源列表失败"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class RegionStatsView(APIView):
    """
    【区域价格趋势统计接口】
    
    主要功能：
        - 计算指定区域的当前平均单价。
        - 模拟并生成最近 6 个月的价格走势数据。
        - 结合宏观趋势（下行/平稳）、季节性波动（小阳春等）以及随机抖动，
          生成一条看起来非常真实的房价曲线，用于前端 ECharts 展示。
    """
    def get(self, request):
        import datetime
        import random
        from django.db.models import Avg

        # 获取当前查询的区域
        region = request.query_params.get('region', 'beijing')
        
        # 1. 从数据库计算该区域的真实平均单价
        current_avg = House.objects.filter(region__icontains=region).aggregate(Avg('unit_price'))
        base_price = current_avg.get('unit_price__avg')
        
        # 2. 兜底策略：如果数据库里一条数据都没有，给一个合理的预设基准价
        if not base_price:
            base_price = 55000 if 'beijing' in region or 'bj' in region else 16000
        else:
            base_price = float(base_price)
            
        # 3. 构造最近 6 个月的模拟数据
        months = []
        prices = []
        today = datetime.date.today()
        
        # 设定市场宏观趋势（例如：目前市场平均每月微跌 0.5%）
        monthly_trend = -0.005 
        
        for i in range(5, -1, -1):
            # 计算对应的年份和月份
            d = today - datetime.timedelta(days=i*30)
            month_str = d.strftime("%Y-%m")
            months.append(month_str)
            
            # 距离现在的月数
            months_ago = i
            
            # 计算趋势因子：通过当前价格倒推历史价格
            trend_factor = 1 / ((1 + monthly_trend) ** months_ago)
            
            # 加入随机波动（±1.5%），让曲线不那么死板
            volatility = (random.random() - 0.5) * 0.03
            
            # 加入季节性影响因子
            month_num = d.month
            seasonality = 0
            if month_num in [3, 4]: seasonality = 0.008  # 3-4月通常是楼市“小阳春”
            elif month_num in [7, 8]: seasonality = -0.005 # 7-8月是传统的淡季
            
            # 计算最终的模拟单价
            simulated_price = base_price * trend_factor * (1 + volatility + seasonality)
            prices.append(round(simulated_price))
            
        return Response({
            "months": months,
            "prices": prices,
            "region": region
        })

class PriceEstimationView(APIView):
    """
    【核心：房价估算接口】
    
    主要功能：
        - 接收用户输入的房源详细参数（面积、户型、楼层、地铁、学区等）。
        - 调用 PriceEstimator 估价引擎进行多维度计算。
        - 返回估算的单价、总价、置信度以及影响价格的加减分项。
    """
    def post(self, request):
        # 1. 验证输入参数是否合法
        req = EstimateRequestSerializer(data=request.data)
        if not req.is_valid():
            return Response(req.errors, status=status.HTTP_400_BAD_REQUEST)
        
        req_data = req.validated_data

        # 2. 初始化估价引擎并执行计算
        estimator = PriceEstimator(req_data)
        result = estimator.estimate()
        
        # 3. 序列化相关数据（相似房源、搜索结果等）以便前端展示
        if result.get('similar_houses'):
            result['similar_houses'] = HouseSerializer(result['similar_houses'], many=True).data
            
        if result.get('search_results'):
            result['search_results'] = HouseSerializer(result['search_results'], many=True).data
        
        return Response(result)
