"""
API 路由配置模块
----------------
定义了所有 REST 接口的访问路径。
所有路由均挂载在根路由的 /api/ 路径下。
"""
from django.urls import path
from .views import PriceEstimationView, HouseListView, RegionStatsView, CrawlView

urlpatterns = [
    # 房价估算入口：POST /api/estimate/
    path('estimate/', PriceEstimationView.as_view(), name='estimate'),
    
    # 房源列表查询：GET /api/houses/
    path('houses/', HouseListView.as_view(), name='house-list'),
    
    # 区域房价趋势：GET /api/stats/region/
    path('stats/region/', RegionStatsView.as_view(), name='region-stats'),
    
    # 实时爬虫触发：POST /api/crawl/
    path('crawl/', CrawlView.as_view(), name='crawl'),
]
