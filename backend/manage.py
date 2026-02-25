#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    """
    Django 项目管理入口。
    -------------------
    通过此入口，你可以运行各种管理命令，如：
    - python manage.py runserver (启动开发服务器)
    - python manage.py migrate (应用数据库迁移)
    - python manage.py run_spider (手动运行爬虫)
    """
    # 指定项目默认的配置文件路径
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "无法导入 Django。请确保已安装 Django 且已激活虚拟环境。"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
