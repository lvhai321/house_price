#!/bin/bash
set -euo pipefail

# 中文说明：
# 本脚本用于初始化项目开发环境，包括后端依赖安装与数据库迁移、前端依赖安装。
# 要求：已安装 Python3、pip、Node.js、npm；MySQL 已启动且在 settings.py 中配置正确。
#
# 使用方式：
#   在 scripts 目录下执行：bash setup.sh

# 计算项目根目录，避免相对路径问题
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "开始环境初始化..."

echo "检查 Python 与 Node.js..."
command -v python >/dev/null 2>&1 || { echo "未检测到 python，请先安装"; exit 1; }
command -v pip >/dev/null 2>&1 || { echo "未检测到 pip，请先安装"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "未检测到 node，请先安装"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "未检测到 npm，请先安装"; exit 1; }

echo "安装后端依赖并迁移数据库..."
cd "$PROJECT_ROOT/backend"
pip install -r requirements.txt
python manage.py migrate

echo "安装前端依赖..."
cd "$PROJECT_ROOT/frontend"
npm install

echo "环境初始化完成。"
