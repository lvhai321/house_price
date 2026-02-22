/**
 * 格式化工具函数模块
 * 提供通用的数据格式化方法，如价格、日期等。
 */

/**
 * 格式化价格
 * 将价格（元）转换为（万元），并保留两位小数。
 * 
 * @param {number|string} val - 原始价格（元）
 * @returns {string} 格式化后的价格（万元），如 "500.00"
 */
export const formatPrice = (val) => {
  if (!val) return '0'
  // 转换为浮点数并除以 10000
  return (parseFloat(val) / 10000).toFixed(2)
}

/**
 * 格式化日期
 * 将 Date 对象或时间戳转换为本地化的日期字符串。
 * 
 * @param {Date|number} date - 日期对象或时间戳，默认为当前时间
 * @returns {string} 本地化日期字符串 (例如: "2023/10/27 10:30:00")
 */
export const formatDate = (date = new Date()) => {
  // 如果是时间戳，转换为 Date 对象
  const d = date instanceof Date ? date : new Date(date)
  return d.toLocaleString()
}
