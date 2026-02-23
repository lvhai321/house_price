# 房价预测与爬虫系统

> Django + Vue3 实现的二手房价格估算与数据采集平台，当前已集成房天下二手房爬虫，并支持基于真实挂牌数据的估价与趋势分析。

---

## 一、项目整体介绍

本项目目标是提供一个“**一站式房价分析工具**”：

- 后端负责：  
  - 从 **房天下（Fang.com）** 实时爬取目标城市/板块的二手房数据；  
  - 将房源信息入库 MySQL（或 SQLite）并做基本清洗去重；  
  - 基于数据库中的真实挂牌数据，计算目标房源的预估价格、相似房源和区域均价走势。
- 前端负责：  
  - 提供估价表单、相似房源列表和趋势图展示；  
  - 一键触发爬虫更新指定城市/区域的数据；  
  - 管理用户历史查询记录，便于对比不同时间的估价结果。

整体流程可以概括为：

1. 用户在前端填写区域、面积、户型等参数并提交；
2. 后端根据数据库中已爬取的数据进行估价和相似房源筛选；
3. 前端展示估价结果、相似房源列表和区域价格趋势；
4. 如当前区域数据不足，用户可在前端直接触发“更新房源数据”，后台实时从房天下拉取新数据入库，再进行估价。

---

## 二、技术栈与关键模块

### 1. 后端（backend）

- **框架**：Django 5 + Django REST Framework  
- **数据库**：默认使用 MySQL 8.0+
- **核心模块**：
  - `apps/spider`：爬虫模块
    - `fang.py`：房天下二手房爬虫 `FangSpider`
    - `runner.py`：爬虫调度与结果汇总 `run_all`
    - `models.py`：房源数据模型 `House`
    - `management/commands/run_spider.py`：命令行运行入口（可选）
  - `apps/api`：对前端开放的 REST API
    - `/api/crawl/`：触发爬虫并写入数据库
    - `/api/houses/`：按区域、价格筛选房源列表
    - `/api/stats/region/`：区域房价趋势数据
    - `/api/estimate/`：房价估算接口
  - `apps/estimator`：估价服务
    - `services.py::PriceEstimator`：估价核心逻辑（相似房源 + 城市基准价 + 特征调整）

### 2. 前端（frontend）

- **框架**：Vue 3 + Vite  
- **状态管理**：Pinia  
- **UI 组件库**：Element Plus  
- **图表展示**：ECharts  
- **网络请求**：Axios（统一封装在 `src/api/index.js`）

前端关键视图与组件：

- `views/Home.vue`：首页主视图，组合所有子组件；
- `components/SearchForm.vue`：估价参数输入与爬虫触发入口；
- `components/ValuationResult.vue`：估价结果展示卡片；
- `components/PriceChart.vue`：区域房价趋势折线图。

---

## 三、项目目录结构（简要）

```text
house_price/
├── backend/                  # Django 后端
│   ├── apps/
│   │   ├── api/              # 对前端暴露的 REST API
│   │   ├── estimator/        # 估价服务与估价历史
│   │   └── spider/           # 房天下爬虫与数据校验
│   ├── config/               # Django 配置（settings、urls）
│   ├── tests/                # 单元测试（如 FangSpider 解析测试）
│   ├── manage.py
│   └── requirements.txt
├── frontend/                 # Vue 3 前端
│   ├── src/
│   │   ├── api/              # Axios 封装与 API 调用
│   │   ├── components/       # 估价结果、趋势图、表单等组件
│   │   ├── constants/        # 下拉选项、区域名称映射
│   │   ├── stores/           # Pinia 状态管理（估价、历史记录等）
│   │   └── views/            # Home 主视图
├── database/                 # 数据库初始化 SQL（如 lvhai.sql）
├── docs/                     # 额外文档（API 文档 / 部署说明 / 旧爬虫说明）
├── scripts/                  # shell 启动脚本（Linux/Mac 可用）
└── README.md                 # 当前说明文件
```

---

## 四、后端配置与启动教程

> 以下命令均以项目根目录 `house_price/` 为起点。

### 1. 环境准备

- Python 版本：**3.8+**（推荐 3.10 以上）
- 数据库：  
  - 本地开发可使用 **MySQL 8.0+**（推荐）  
  - 或使用 SQLite（配置简单）
- 其他依赖：
  - 已安装 `pip`、`virtualenv`（建议使用虚拟环境）

### 1. 环境准备

```bash
cd backend

# 可选：创建并激活虚拟环境（示例命令，可按自己习惯调整）
python -m venv venv
venv\Scripts\activate   # Windows
# 或 source venv/bin/activate  # macOS / Linux

# 安装项目依赖
pip install -r requirements.txt
```

### 3. 配置环境变量（.env）

后端使用 `.env` 文件管理数据库与调试配置，模板参考 [`backend/config/settings.py`](file:///c:/Users/dril/OneDrive/Desktop/house_price/backend/config/settings.py#L80-L105)。

在 `backend/` 目录下创建 `.env`（若已有则修改）：

```env
DEBUG=True               # 开发环境建议 True

DB_NAME=lvhai            # 数据库名
DB_USER=root             # 用户名
DB_PASSWORD=你的数据库密码
DB_HOST=localhost
DB_PORT=3306

# Django 密钥（生产环境务必替换）
SECRET_KEY=请自行生成的安全随机字符串
```

### 4. 初始化数据库

```bash
cd backend

# 生成并应用数据表
python manage.py migrate

# 如需导入预置数据，可使用 database/backup 下的 SQL
# 例如在 MySQL 中执行 lvhai.sql 初始化基础数据
```

### 5. 启动后端服务

```bash
cd backend
python manage.py runserver 0.0.0.0:8000
```

默认访问地址：`http://127.0.0.1:8000/`  
前端通过 Vite 代理访问 `/api/*`，无需额外配置。

---

## 五、前端启动与界面说明

### 1. 安装依赖并启动开发服务器

```bash
cd frontend
npm install       # 首次安装依赖
npm run dev       # 启动开发服务器
```

默认访问地址：`http://localhost:5173`

### 2. 首页整体布局（Home.vue）

首页由左右两列组成：

- **左侧列：搜索与操作区**
  - 顶部标题：展示系统名称“房价预测系统”和宣传语；
  - 中部 `SearchForm` 组件：填写估价参数、查看历史记录、触发爬虫更新；
  - 支持响应式布局，在窄屏（移动端）时会堆叠显示。

- **右侧列：结果与分析区**
  - 顶部 `ValuationResult` 卡片：展示当前估算总价、单价、置信度以及影响因素标签；
  - 下方 Tab 卡片：
    - “搜索结果”：当前区域的最新房源列表（主要来源于数据库中的真实数据）；
    - “相似房源”：与目标房源高度相似的挂牌数据；
    - “区域趋势”：选定区域的房价趋势折线图（最近 6 个月模拟走势 + 实际均价基准）；
    - “历史记录”：用户本地历史估价记录列表，可点击快速回填并再次估价。

### 3. 搜索表单区域（SearchForm.vue）

表单主要分为三块：

1. **表单顶部操作区**
   - “历史记录”按钮：打开侧边抽屉，查看历史估价记录；
   - “更新数据”按钮：打开“更新房源数据”的爬虫控制弹窗（后端会实时爬取房天下）；
   - “重置”按钮：清空当前估价表单参数，并重置估价结果。

2. **估价参数输入区**
   - 区域：中文区域名称，如“武汉”“白沙洲”“塔子湖”等；
   - 面积：单位㎡，默认 90，可在 10~1000 范围内调整；
   - 户型：下拉选择，如“2室1厅”“3室2厅”等；
   - 楼层、朝向、装修、房龄：通过下拉框和数字输入选择；
   - 特征快捷开关：
     - “近地铁”：对估价存在正向加成；
     - “学区房”：对估价有更大正向加成。

3. **估价与爬虫弹窗**
   - “立即估价”按钮：触发前端调用 `POST /api/estimate/` 接口，后端进行估价并返回结果；
   - “更新房源数据”弹窗：
     - 城市子域名：可留空（后端自动判断），也可填 `bj、sh、wuhan` 等；
     - 区域名称：例如“武汉”“白沙洲”，将作为爬虫的搜索关键字；
     - 爬取页数：例如 3 页 ≈ 180 条目标“新数据”；
     - 点击“开始更新”后，前端会调用 `POST /api/crawl/`，等待爬虫完成并自动回填区域再触发一次估价。

### 4. 估价结果卡片（ValuationResult.vue）

- 主要展示内容：
  - 估算总价（万元）：使用动态数字动画展示，视觉上更醒目；
  - 估算单价（元/平米）：根据总价和面积计算；
  - 置信度仪表盘：目前固定值，可根据后续模型调整改为动态；
  - 影响因素标签：例如“近地铁 +6.5%”“学区房 +11.5%”“老旧小区 -X%”等。

### 5. 数据分析 Tab 区域

1. **搜索结果 Tab**
   - 显示当前区域下最近抓取的房源列表；
   - 每一条包括：标题、区域、户型、面积、总价、单价，以及跳转到房天下详情页的按钮；
   - 如没有数据，会显示“暂无相关搜索结果”，并提供“立即更新数据”按钮直接唤起爬虫弹窗。

2. **相似房源 Tab**
   - 展示与目标房源最相似的几条挂牌（由 `PriceEstimator` 计算相似度）；
   - 带有“相似度高”标签，信息结构与搜索结果类似；
   - 若暂时找不到高相似度房源，则显示友好的空状态说明。

3. **区域趋势 Tab（PriceChart.vue）**
   - 使用 ECharts 绘制折线图：
     - X 轴：最近 6 个月；
     - Y 轴：平均单价（元/平米）；
   - 曲线数据来自 `GET /api/stats/region/?region=xxx` 接口；
   - 支持窗口大小变化自适应布局。

4. **历史记录 Tab**
   - 按时间倒序展示本地保存的估价历史；
   - 点击某条记录会自动回填表单并重新触发估价；
   - 同样的数据在右侧抽屉和此 Tab 中共享显示。

---

## 六、房天下爬虫逻辑说明

### 1. FangSpider：城市与区域解析

核心代码位置：[`backend/apps/spider/fang.py`](file:///c:/Users/dril/OneDrive/Desktop/house_price/backend/apps/spider/fang.py)

- **城市子域名解析 `_get_subdomain`**：
  - 支持输入：
    - 中文：`"武汉"`, `"孝感"`；
    - 全拼：`"wuhan"`, `"xiaogan"`；
    - 缩写：`"wh"`, `"xg"`；
  - 内部通过映射表 + `pypinyin` 转为最终子域名，如 `wuhan、xiaogan、bj、sh` 等；
  - 列表页基础 URL 统一为：`https://{subdomain}.esf.fang.com`。

- **区域搜索关键字 `region`**：
  - 前端传入时通常使用中文（例如 `"武汉"`, `"白沙洲"`）；
  - 用作 URL 中的 `kw` 参数：`/house/i3{page}-kw{region}/`；
  - 在解析阶段组合为 `final_region = "搜索关键字-页面解析区域"`，例如 `"武汉-塔子湖"`。

### 2. 爬虫翻页与“180 条新数据”策略

在 `crawl()` 中：

- `pages` 表示目标“新数据页数”，默认 3 页，对应目标新数据量 `target_new = pages * 60`；
- 每一页抓取并解析房源后：
  - 通过查询数据库现有 URL，给每条记录打上 `is_new` 标记；
  - `new_collected` 累加本页新增条数，直到接近 `target_new` 时停止；
- 同时设置安全停止条件：
  - 连续 3 页无数据 → 直接中止；
  - 抓取过程中发生网络错误 → 中止当前任务。

返回的列表中同时包含新旧数据，方便后续：

- 新数据入库；
- 旧数据更新价格；
- 前端展示“完整列表”。

### 3. run_all：爬虫调度与去重

位置：[`backend/apps/spider/runner.py`](file:///c:/Users/dril/OneDrive/Desktop/house_price/backend/apps/spider/runner.py)

主要职责：

- 根据传入的 `region` 和 `city_subdomain` 构造爬虫实例（目前仅房天下 `FangSpider`）；
- 使用线程池并发执行爬虫（预留多源扩展能力）；
- 汇总所有爬虫结果，按 URL 去重，并过滤掉无效数据；
- 根据每日抓取上限 `max_daily` 截断结果列表，避免过量抓取。

### 4. CrawlView：API 层写库与返回数据

位置：[`backend/apps/api/views.py::CrawlView`](file:///c:/Users/dril/OneDrive/Desktop/house_price/backend/apps/api/views.py#L20-L123)

核心流程：

1. 接收前端传来的 `city_subdomain`、`region`、`pages`；
2. 调用 `run_all` 获取带 `is_new` 标记的爬虫结果；
3. 使用 `House.objects.update_or_create(url=...)` 将数据写入数据库：  
   - 新 URL → 创建记录（计入 `new_count`）；  
   - 已存在 URL → 更新总价、单价等字段；
4. 再从数据库中按区域关键字查询当前区域所有房源（历史 + 新抓），返回给前端：

```json
{
  "status": "success",
  "message": "已完成爬取，新增 180 条数据",
  "new_count": 180,
  "total": 332,
  "data": [ ... 完整房源列表 ... ]
}
```

前端拿到 `data` 直接用于“搜索结果列表”，无需额外再调 `/api/houses/`。

---

## 七、常见操作与推荐使用流程

1. **首次启动**
   1. 配置 `.env` 并完成数据库迁移；
   2. 启动后端：`python manage.py runserver 0.0.0.0:8000`；
   3. 启动前端：`npm run dev`；
   4. 打开浏览器访问 `http://localhost:5173`。

2. **更新某个城市/区域的房源数据（以武汉为例）**
   1. 打开首页，点击左侧卡片右上角的“下载”图标按钮；
   2. 在弹出的“更新房源数据”弹窗中填写：
      - 城市子域名：留空或填 `wuhan`；
      - 区域名称：例如 `武汉` 或更细的 `白沙洲`；
      - 爬取页数：例如 `3`（目标 ≈ 180 条新数据）；
   3. 点击“开始更新”，等待提示“已完成爬取，新增 X 条数据”；
   4. 弹窗关闭后，系统会自动把区域回填到估价表单并触发一次搜索，你可以在右侧“搜索结果”中看到最新房源列表。

3. **对某套房源进行估价**
   1. 在左侧“房源参数”表单中输入：
      - 区域：如 `武汉-白沙洲` 或简写 `白沙洲`；
      - 面积：如 `100` ㎡；
      - 户型：选择 `3室2厅`；
      - 其他特征（楼层、朝向、装修、房龄、地铁/学区开关）；
   2. 点击“立即估价”，等待右侧卡片展示估价结果；
   3. 在“相似房源” Tab 中查看近期挂牌的可比房源；
   4. 在“区域趋势” Tab 中查看该区域最近 6 个月的价格走势。

4. **查看和复用历史估价记录**
   - 方式一：点击左上角“时钟”图标打开历史记录抽屉，点击任意记录即可回填并重新估价；
   - 方式二：在右侧 Tab 的“历史记录”中选择记录，效果同上。

---

## 八、特别鸣谢

- 感谢个人创作者 noy 在本项目架构与实现思路上的贡献；
- 感谢以下优秀开源项目提供的思路与参考实现（城市编码、爬虫策略、数据清洗等维度）：
  - `https://github.com/lanbing510/LianJiaSpider`
  - `https://github.com/KivenJia/Python--lianjia-beike-spider`
