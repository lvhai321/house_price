/**
 * 通用格式化工具模块
 * ----------------
 * 包含金额千分位转换、日期美化等 UI 展示相关的辅助函数。
 */

/**
 * 【价格千分位格式化】
 * 将数字转换为带有千分位分隔符的字符串，并保留两位小数。
 * 示例: 1234567.89 -> "1,234,567.89"
 */
export const formatPrice = (price) => {
  if (price === null || price === undefined) return '0.00'
  return new Intl.NumberFormat('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }).format(price)
}

/**
 * 【日期美化】
 * 获取当前时间并转换为本地日期字符串。
 * 示例: "2024年2月25日"
 */
export const formatDate = (date = new Date()) => {
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

/**
 * 【百分比格式化】
 * 将小数转换为百分比字符串。
 * 示例: 0.85 -> "85%"
 */
export const formatPercent = (val) => {
  if (val === null || val === undefined) return '0%'
  return `${Math.round(val * 100)}%`
}
