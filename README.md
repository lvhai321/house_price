# 房价预测系统 (House Price Prediction System)

本项目是一个基于 Python 的房价预测系统。其核心逻辑是通过爬取第三方房产网站（如链家等）的相关数据，并结合自定义的算法逻辑对特定区域、户型、面积的房源进行价格估算与趋势分析。

## 项目简介

该系统旨在为用户提供一个直观的房价查询与分析平台。用户只需在前端输入感兴趣的区域、面积和户型，系统后台即会触发以下流程：
1.  **数据采集**：实时或利用缓存爬取目标区域的相似房源数据。
2.  **数据清洗**：对抓取的数据进行去重和格式化。
3.  **智能估算**：运用预设的估价算法计算目标房源的参考价格。
4.  **可视化展示**：在前端展示估算价格、相似房源列表以及市场趋势分析。

## 技术栈

### 后端 (Backend)
- **框架**: Django 4.2.7 + Django REST Framework
- **数据库**: MySQL 8.0+
- **爬虫**: 自定义 Python 爬虫模块 (Requests + BeautifulSoup)
- **数据分析**: Pandas, NumPy, Scikit-learn (用于后续算法扩展)

### 前端 (Frontend)
- **框架**: Vue 3 + Vite
- **UI 组件库**: Element Plus
- **网络请求**: Axios
- **图表**: ECharts (用于趋势图展示)

## 目录结构

```text
house_price_demo/
├── backend/            # Django 后端代码
│   ├── apps/           # 核心业务模块 (spider, estimator, api)
│   ├── config/         # 项目配置
│   └── manage.py
├── frontend/           # Vue 前端代码
│   ├── src/            # 源码 (views, components, api)
│   └── vite.config.js
├── database/           # 数据库脚本
├── scripts/            # 快捷启动脚本
└── docs/               # 详细文档
```

## 快速开始

### 1. 环境准备
- Python 3.8+
- Node.js 16+
- MySQL 8.0+

### 2. 后端启动
```bash
cd backend
# 安装依赖
pip install -r requirements.txt
# 配置数据库 (需修改 backend/config/settings.py 中的数据库密码)
# 迁移数据表
python manage.py migrate
# 启动服务
python manage.py runserver
```

### 3. 前端启动
```bash
cd frontend
# 安装依赖
npm install
# 启动开发服务器
npm run dev
```

### 4. 访问系统
打开浏览器访问: `http://localhost:5173`

## 功能演示
1. **房源查询**: 输入"朝阳"、"90"平米、"2室1厅"。
2. **价格估算**: 查看系统计算的预估总价。
3. **相似推荐**: 浏览该区域近期挂牌的相似房源。
