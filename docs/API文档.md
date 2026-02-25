# API 接口文档

本项目后端基于 Django REST Framework 开发，提供以下 RESTful API 供前端调用。

---

## 1. 爬虫触发接口
**接口地址**: `/api/crawl/`  
**请求方法**: `POST`  
**功能描述**: 触发房天下爬虫，抓取指定城市和区域的房源数据并入库。

**请求参数 (JSON)**:
| 参数名 | 类型 | 必填 | 示例 | 说明 |
| :--- | :--- | :--- | :--- | :--- |
| `city_subdomain` | String | 否 | `wuhan` | 城市子域名（如 bj, sh, wuhan），留空则自动判断 |
| `region` | String | 是 | `白沙洲` | 目标区域的搜索关键字 |
| `pages` | Integer | 否 | `3` | 爬取的目标页数（每页约 60 条数据） |

**响应示例 (Success)**:
```json
{
  "status": "success",
  "message": "已完成爬取，新增 180 条数据",
  "new_count": 180,
  "total": 332,
  "data": [
    {
      "id": 1,
      "title": "保利上城 3室2厅 100平",
      "region": "武汉-白沙洲",
      "total_price": 150.0,
      "unit_price": 15000,
      "url": "https://wuhan.esf.fang.com/...",
      "is_new": true
    },
    ...
  ]
}
```

---

## 2. 房价估算接口
**接口地址**: `/api/estimate/`  
**请求方法**: `POST`  
**功能描述**: 根据房源参数（面积、户型、特征等）计算预估价格。

**请求参数 (JSON)**:
| 参数名 | 类型 | 必填 | 示例 | 说明 |
| :--- | :--- | :--- | :--- | :--- |
| `region` | String | 是 | `武汉-白沙洲` | 目标区域 |
| `area` | Number | 是 | `95.5` | 房屋面积 (㎡) |
| `layout` | String | 是 | `3室2厅` | 户型描述 |
| `floor` | String | 否 | `中层` | 楼层位置 (高/中/低) |
| `is_subway` | Boolean | 否 | `true` | 是否靠近地铁 |
| `is_school` | Boolean | 否 | `false` | 是否为学区房 |

**响应示例**:
```json
{
  "status": "success",
  "estimated_price": 145.8,
  "unit_price": 15267,
  "confidence": 0.85,
  "similar_houses": [...],
  "factors": [
    {"label": "近地铁", "impact": "+6.5%"},
    {"label": "高楼层", "impact": "+2.0%"}
  ]
}
```

---

## 3. 区域房价统计接口
**接口地址**: `/api/stats/region/`  
**请求方法**: `GET`  
**功能描述**: 获取指定区域最近 6 个月的房价趋势。

**请求参数 (Query)**:
- `region`: (String) 目标区域名称。

**响应示例**:
```json
{
  "region": "白沙洲",
  "history": [
    {"month": "2023-09", "avg_price": 14800},
    {"month": "2023-10", "avg_price": 14950},
    ...
  ]
}
```

---

## 4. 房源筛选接口
**接口地址**: `/api/houses/`  
**请求方法**: `GET`  
**功能描述**: 分页查询数据库中的房源列表。

**请求参数 (Query)**:
- `region`: 区域过滤
- `min_price`: 最低总价
- `max_price`: 最高总价
- `page`: 当前页码
