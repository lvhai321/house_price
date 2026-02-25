from django.core.management.base import BaseCommand
from apps.spider.runner import run_all

class Command(BaseCommand):
    """
    【手动启动爬虫命令】
    ------------------
    用法示例：
    python manage.py run_spider --region=白沙洲 --pages=5 --city=wuhan
    """
    help = '手动触发爬虫任务并保存数据到数据库'

    def add_arguments(self, parser):
        # 命令行参数定义
        parser.add_argument('--region', type=str, default='chaoyang', help='目标区域名称 (如: 朝阳)')
        parser.add_argument('--pages', type=int, default=3, help='爬取页数 (每页约 60 条)')
        parser.add_argument('--city', type=str, default='bj', help='城市子域名标识 (如: bj, sh, wuhan)')

    def handle(self, *args, **options):
        region = options['region']
        pages = options['pages']
        city = options['city']
        
        self.stdout.write(self.style.SUCCESS(f'>>> 爬虫指令启动 | 城市: {city}, 区域: {region}, 目标: {pages}页'))
        
        # 调用调度器执行任务
        results = run_all(region=region, pages=pages, city_subdomain=city)
        
        self.stdout.write(self.style.SUCCESS(f'>>> 爬虫任务结束 | 本次成功保存/更新: {len(results)} 条记录'))
