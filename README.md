# 房价预测与爬虫系统

> Django 5 + Vue 3 实现的一站式二手房价格估算、数据采集与趋势分析平台。

---

## 一、项目简介

本项目旨在为用户提供真实、透明的房价参考。通过实时爬取房天下（Fang.com）的挂牌数据，结合区域均价、房源特征（如地铁、学区等）进行智能估价。

### 核心功能
- **智能估价**：基于真实挂牌数据的多维度价格预测。
- **实时爬虫**：支持按城市/区域一键触发数据更新，确保数据时效性。
- **数据分析**：展示区域价格走势图及高相似度房源对比。
- **历史记录**：自动保存用户的估价查询，支持快速回填。

---

## 二、技术架构

### 后端 (backend)
- **核心框架**：Django 5 + Django REST Framework
- **数据存储**：MySQL 8.0 / SQLite
- **核心模块**：
  - `spider`: 房天下二手房异步爬虫。
  - `estimator`: 房价估算算法与逻辑服务。
  - `api`: 提供 RESTful 接口支持。

### 前端 (frontend)
- **核心框架**：Vue 3 + Vite
- **UI 组件**：Element Plus
- **数据可视化**：ECharts

---

## 三、快速开始

### 1. 部署说明
详细的环境准备、后端配置及前端启动步骤，请参阅：  
👉 **[部署与配置说明](docs/部署说明.md)**

### 2. API 接口
关于系统提供的爬虫触发、估价及统计接口详情，请参阅：  
👉 **[API 接口文档](docs/API文档.md)**

### 3. 爬虫逻辑
了解房天下爬虫的实现细节、翻页策略及去重机制，请参阅：  
👉 **[爬虫说明文档](docs/爬虫说明.md)**

---

## 四、项目目录结构

```text
house_price/
├── backend/                  # Django 后端项目
│   ├── apps/                 # 核心应用 (api, estimator, spider)
│   ├── config/               # 项目配置 (settings, urls)
│   └── manage.py
├── frontend/                 # Vue 3 前端项目
│   ├── src/                  # 源代码 (api, components, views)
│   └── vite.config.js
├── docs/                     # 项目详细文档
├── database/                 # 数据库初始化脚本
└── README.md                 # 项目主说明
```

---

## 五、特别鸣谢
- 感谢个人创作者 noy 在本项目架构与实现思路上的贡献；
- 感谢以下优秀开源项目提供的思路与参考实现（城市编码、爬虫策略、数据清洗等维度）：
  - `https://github.com/lanbing510/LianJiaSpider`
  - `https://github.com/KivenJia/Python--lianjia-beike-spider`感谢所有开源贡献者及本项目参考的优秀开源库。
