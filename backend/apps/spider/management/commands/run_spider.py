from django.core.management.base import BaseCommand
from apps.spider.runner import run_all

class Command(BaseCommand):
    help = 'Runs the house spider for specified region and pages'

    def add_arguments(self, parser):
        parser.add_argument('--region', type=str, default='chaoyang', help='Region name (pinyin)')
        parser.add_argument('--pages', type=int, default=3, help='Number of pages to crawl')
        parser.add_argument('--city', type=str, default='bj', help='City subdomain (e.g. bj, sh)')

    def handle(self, *args, **options):
        region = options['region']
        pages = options['pages']
        city = options['city']
        
        self.stdout.write(self.style.SUCCESS(f'Starting spider for region: {region}, pages: {pages}, city: {city}'))
        
        results = run_all(region=region, pages=pages, city_subdomain=city)
        
        self.stdout.write(self.style.SUCCESS(f'Spider finished. Total items saved: {len(results)}'))
