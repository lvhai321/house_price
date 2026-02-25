/**
 * API 网络请求模块
 * ----------------
 * 统一管理前端与后端的 HTTP 通信。
 * 使用 Axios 库进行请求拦截、响应处理以及 API 的集中定义。
 */
import axios from 'axios'

// 创建 Axios 实例
const api = axios.create({
    // baseURL 设定为 '/api'。
    // 在开发环境下，Vite 的代理配置（vite.config.js）会将此开头的请求转发至后端服务器 (8000 端口)。
    baseURL: '/api', 
    timeout: 60000   // 设置全局超时时间为 60 秒，因为爬虫任务耗时较长
})

/**
 * 【房产估价接口】
 * 向后端提交房屋的各项特征参数，获取预测的价格结果。
 * 
 * @param {Object} data - 房源参数对象
 * @param {string} data.region - 区域（如：'武汉-白沙洲'）
 * @param {number} data.area - 建筑面积 (㎡)
 * @param {string} data.layout - 户型描述（如：'3室2厅'）
 * @param {string} data.floor_type - 楼层位置 ('low', 'mid', 'high')
 * @param {string} data.decoration - 装修情况 ('rough', 'simple', 'exquisite')
 * @param {string} data.orientation - 房屋朝向 ('south', 'north', 'east', 'west')
 * @param {number} data.building_age - 房屋年龄（年）
 * @param {boolean} data.has_subway - 是否靠近地铁
 * @param {boolean} data.is_school_district - 是否为学区房
 * @returns {Promise} 返回估价结果，包含总价、单价、相似房源等。
 */
export const estimatePrice = (data) => {
    return api.post('/estimate/', data)
}

/**
 * 【获取区域房价走势接口】
 * 获取特定区域最近 6 个月的平均价格变动数据，用于图表展示。
 * 
 * @param {string} region - 区域名称（如：'白沙洲'）
 */
export const getRegionStats = (region) => {
    return api.get('/stats/region/', {
        params: { region }
    })
}

/**
 * 【触发实时爬虫任务接口】
 * 指挥后端立即前往房天下抓取指定区域的最新的挂牌房源。
 * 
 * @param {Object} data - 爬虫配置
 * @param {string} data.region - 目标区域关键字
 * @param {string} data.city_subdomain - 城市拼音缩写（如：'wuhan'）
 * @param {number} data.pages - 抓取的页数
 */
export const startCrawl = (data) => {
    return api.post('/crawl/', data)
}

// 默认导出 Axios 实例
export default api
