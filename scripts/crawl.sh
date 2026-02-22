#!/bin/bash
set -euo pipefail

# 中文说明：
# 本脚本用于触发并发爬虫任务并批量写入数据库。
# 支持传入区域与页数参数，示例：
#   bash crawl.sh haidian 2
# 若未传参则默认区域为 chaoyang，页数为 2。

REGION="${1:-chaoyang}"
PAGES="${2:-2}"

# 计算项目根目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "开始爬取，区域=${REGION}，页数=${PAGES} ..."
cd "$PROJECT_ROOT/backend"
python manage.py run_spider --region="${REGION}" --pages="${PAGES}"
echo "爬取完成。"
