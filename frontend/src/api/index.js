/**
 * API 接口封装模块
 * 统一管理前端与后端的 HTTP 请求交互。
 * 使用 Axios 库进行请求发送和响应处理。
 */
import axios from 'axios'

// 创建 Axios 实例，配置基础 URL 和超时时间
const api = axios.create({
    // 开发环境下通过 Vite 代理转发到后端 (http://localhost:8000)
    // 生产环境需根据部署配置进行调整
    baseURL: '/api', 
    timeout: 60000   // 请求超时时间设置为 60 秒
})

/**
 * 房产估价接口
 * 向后端发送房源特征数据，获取估价结果和相似房源信息。
 * 
 * @param {Object} data - 房源特征数据对象
 * @param {string} data.region - 区域 (如 'chaoyang')
 * @param {number} data.area - 面积 (平方米)
 * @param {string} data.layout - 户型 (如 '2室1厅')
 * @param {string} data.floor_type - 楼层类型 ('low', 'mid', 'high')
 * @param {string} data.decoration - 装修情况 ('rough', 'simple', 'exquisite')
 * @param {string} data.orientation - 朝向 ('east', 'west', 'south', 'north')
 * @param {number} data.building_age - 房龄 (年)
 * @param {boolean} data.has_subway - 是否近地铁
 * @param {boolean} data.is_school_district - 是否学区房
 * @returns {Promise} Axios Promise 对象，resolve 后包含后端返回的 JSON 数据
 */
export const estimatePrice = (data) => {
    return api.post('/estimate/', data)
}

/**
 * 获取区域房价统计数据接口
 * 获取各行政区域的平均单价和房源数量，用于前端图表展示。
 * 
 * @param {string} region - 区域名称或拼音 (可选，默认后端处理)
 * @returns {Promise} Axios Promise 对象，resolve 后包含区域统计列表
 */
export const getRegionStats = (region) => {
    return api.get('/stats/region/', {
        params: { region }
    })
}

/**
 * 触发爬虫任务接口
 * 
 * @param {Object} data - 爬虫参数
 * @param {string} data.region - 区域 (如 'chaoyang')
 * @param {string} data.city_subdomain - 城市子域名 (如 'bj')
 * @param {number} data.pages - 爬取页数
 * @returns {Promise} Axios Promise
 */
export const startCrawl = (data) => {
    return api.post('/crawl/', data)
}

// 导出配置好的 Axios 实例，以便在其他地方需要直接使用 Axios 功能时调用
export default api
