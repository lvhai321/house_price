"""
全局路由配置文件
负责将 URL 请求分发到对应的应用（如 API、Admin）
"""
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('apps.api.urls')),
]
