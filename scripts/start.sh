#!/bin/bash
set -euo pipefail

# 中文说明：
# 本脚本用于同时启动后端 Django 与前端 Vite 开发服务器。
# 后端默认端口：8000；前端默认端口：5173。
# 使用方式：
#   在 scripts 目录下执行：bash start.sh

# 计算项目根目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "启动后端服务（Django）..."
cd "$PROJECT_ROOT/backend"
python manage.py runserver &
BACKEND_PID=$!
echo "后端已启动，PID=$BACKEND_PID"

echo "启动前端服务（Vite）..."
cd "$PROJECT_ROOT/frontend"
npm run dev

# 说明：前端进程前台运行，Ctrl+C 停止；后端在后台运行，如需结束请手动 kill $BACKEND_PID
