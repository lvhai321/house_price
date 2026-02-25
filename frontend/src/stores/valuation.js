/**
 * 估价业务核心 Store (Pinia)
 * -------------------------
 * 该仓库负责管理整个应用的数据流和业务逻辑：
 * 1. 状态管理：存储当前的估价结果、相似房源、历史记录及加载状态。
 * 2. 异步通信：封装 API 调用逻辑，处理搜索请求并更新 UI 状态。
 * 3. 逻辑计算：在前端模拟计算价格波动因素（加分/减分项）。
 * 4. 持久化：将用户的历史查询保存到浏览器的 LocalStorage 中。
 */
import { defineStore } from 'pinia'
import { estimatePrice, getRegionStats } from '../api'
import { formatPrice, formatDate } from '../utils/format'

export const useValuationStore = defineStore('valuation', {
  // 1. 核心响应式状态 (State)
  state: () => ({
    loading: false,     // 正在请求中标识
    error: null,        // 记录接口报错信息
    result: null,       // 后端返回的估价详情 (包含价格和相似房源)
    chartData: [],      // 房价趋势图使用的坐标数据
    history: [],        // 历史估价列表
    factors: [],        // 计算得出的影响因子标签 (如：+5% 地铁房)
    currentRegion: ''   // 当前正在查询的区域名
  }),

  // 2. 业务逻辑操作 (Actions)
  actions: {
    /**
     * 【主流程】发起房价估算搜索
     * @param {Object} params - 包含面积、户型、特征等的原始表单数据
     */
    async search(params) {
      this.loading = true
      this.error = null
      try {
        // 数据预处理：将特征数组拆解为后端识别的布尔字段
        const payload = {
          ...params,
          has_subway: params.features.includes('has_subway'),
          is_school_district: params.features.includes('is_school_district')
        }
        
        // A. 调用后端 API 进行智能估价
        const response = await estimatePrice(payload)
        this.result = response.data
        
        // B. 前端辅助计算：生成视觉上的影响因子标签
        this.calculateFactors(params)
        
        // C. 持久化存储：保存本次估价到本地历史
        this.saveHistory(params, this.result.estimated_price)
        
        // D. 联动更新：刷新该区域的价格走势图
        this.currentRegion = params.region
        this.fetchStats(params.region)
        
        return true
      } catch (error) {
        console.error('搜索请求异常:', error)
        this.error = error.message || '估价系统繁忙，请稍后再试'
        throw error
      } finally {
        this.loading = false
      }
    },

    /**
     * 获取指定区域的价格走势统计
     */
    async fetchStats(region) {
      if (region) this.currentRegion = region
      try {
        const response = await getRegionStats(region || this.currentRegion)
        this.chartData = response.data
      } catch (error) {
        console.error("获取趋势数据失败:", error)
      }
    },

    /**
     * 前端模拟计算：价格影响因子
     * 根据用户勾选的特征，生成直观的“加减分”标签。
     * 说明：这里的数值主要用于 UI 展示，真实的计算由后端模型完成。
     */
    calculateFactors(params) {
      const f = []
      // A. 位置与政策因素
      if (params.features.includes('has_subway')) {
        f.push({ name: '近地铁', value: '+5%', type: 'success' })
      }
      if (params.features.includes('is_school_district')) {
        f.push({ name: '学区房', value: '+10%', type: 'success' })
      }
      // B. 楼层与采光
      if (params.floor_type === 'low') f.push({ name: '低楼层', value: '-5%', type: 'danger' })
      if (params.floor_type === 'mid') f.push({ name: '中楼层', value: '+5%', type: 'success' })
      
      // C. 装修质量
      if (params.decoration === 'exquisite') f.push({ name: '精装修', value: '+15%', type: 'success' })
      if (params.decoration === 'rough') f.push({ name: '毛坯房', value: '-10%', type: 'danger' })
      
      // D. 房屋折旧
      if (params.building_age > 20) {
        f.push({ name: '房龄偏老', value: `-${Math.min(params.building_age * 0.5, 20).toFixed(1)}%`, type: 'danger' })
      } else if (params.building_age < 5) {
        f.push({ name: '次新房', value: '+2%', type: 'success' })
      }
      
      this.factors = f
    },

    /**
     * 从浏览器 LocalStorage 加载历史记录
     */
    loadHistory() {
      const hist = localStorage.getItem('house_price_history')
      if (hist) {
        this.history = JSON.parse(hist)
      }
    },

    /**
     * 将本次估价记录保存到本地
     */
    saveHistory(params, price) {
      const entry = {
        ...params,
        price: formatPrice(price),
        date: formatDate() // 记录具体操作时间
      }
      // 将新记录插入列表顶部
      this.history.unshift(entry)
      // 最多保留 20 条，防止存储空间过大
      if (this.history.length > 20) this.history.pop()
      // 同步到 LocalStorage
      localStorage.setItem('house_price_history', JSON.stringify(this.history))
    },

    /**
     * 重置状态（用于开启新一轮搜索）
     */
    reset() {
      this.result = null
      this.factors = []
    }
  }
})
