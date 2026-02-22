"""
API 路由配置
定义 /api/ 下的子路由，如 /api/estimate/
"""
from django.urls import path
from .views import PriceEstimationView, HouseListView, RegionStatsView, CrawlView

urlpatterns = [
    path('estimate/', PriceEstimationView.as_view(), name='estimate'),
    path('houses/', HouseListView.as_view(), name='house-list'),
    path('stats/region/', RegionStatsView.as_view(), name='region-stats'),
    path('crawl/', CrawlView.as_view(), name='crawl'),
]
