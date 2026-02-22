# API 文档

## 房价估算

**Endpoint:** `/api/estimate/`
**Method:** `POST`

**Request Body:**
```json
{
    "region": "chaoyang",
    "area": 90,
    "layout": "2室1厅"
}
```

**Response:**
```json
{
    "estimated_price": 500.00,
    "similar_houses": [
        {
            "title": "...",
            "region": "chaoyang",
            "total_price": 500,
            ...
        }
    ],
    "market_trend": "Stable"
}
```
