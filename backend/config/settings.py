"""
项目全局配置文件
----------------
包含数据库连接、已安装应用列表、中间件、跨域设置以及日志记录等核心配置。
"""

from pathlib import Path
import os
from dotenv import load_dotenv

# 项目根目录路径 (backend/ 目录)
BASE_DIR = Path(__file__).resolve().parent.parent

# 加载 .env 环境变量文件，保护敏感信息（如数据库密码、密钥等）
load_dotenv(BASE_DIR / '.env')

# Django 安全密钥，生产环境必须在 .env 中设置
SECRET_KEY = os.getenv('SECRET_KEY', 'django-insecure-change-me-in-production')

# 调试模式开关：开发环境建议设为 True，生产环境务必设为 False
DEBUG = os.getenv('DEBUG', 'False') == 'True'

# 允许访问的主机列表
ALLOWED_HOSTS = ['127.0.0.1', 'localhost']


# 已安装的 Django 应用
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # 第三方扩展包
    'rest_framework', # REST API 支持
    'corsheaders',    # 跨域资源共享支持
    
    # 本地业务应用
    'apps.spider',    # 爬虫模块
    'apps.estimator', # 估价模块
    'apps.api',       # API 接口模块
]

# 中间件配置
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware', # 跨域中间件，必须放在 CommonMiddleware 之前
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

# 模板引擎配置
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'


# 数据库配置
# 默认使用 MySQL。可以通过 .env 文件配置连接详情。
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv('DB_NAME', 'lvhai'),
        'USER': os.getenv('DB_USER', 'root'),
        'PASSWORD': os.getenv('DB_PASSWORD', '123456'),
        'HOST': os.getenv('DB_HOST', 'localhost'),
        'PORT': os.getenv('DB_PORT', '3306'),
    }
}


# 国际化配置
LANGUAGE_CODE = 'zh-hans' # 使用简体中文界面
TIME_ZONE = 'Asia/Shanghai' # 使用上海时区
USE_I18N = True
USE_TZ = True


# 静态文件配置 (CSS, JavaScript, Images)
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    BASE_DIR / "static",
]
STATIC_ROOT = BASE_DIR / "staticfiles"

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# 跨域设置：开发环境下默认允许所有来源
CORS_ALLOW_ALL_ORIGINS = os.getenv('CORS_ALLOW_ALL_ORIGINS', 'True') == 'True'

# 日志记录配置：用于记录爬虫运行日志和 API 异常
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple',
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': BASE_DIR / 'spider.log',
            'formatter': 'verbose',
            'encoding': 'utf-8',
        },
    },
    'loggers': {
        'spider': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}
