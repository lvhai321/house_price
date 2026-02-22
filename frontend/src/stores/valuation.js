import { defineStore } from 'pinia'
import { estimatePrice, getRegionStats } from '../api'
import { formatPrice, formatDate } from '../utils/format'

/**
 * 估价业务状态仓库 (Pinia Store)
 * 管理房产估价相关的全局状态，包括搜索结果、图表数据、历史记录等。
 */
export const useValuationStore = defineStore('valuation', {
  // 定义状态
  state: () => ({
    loading: false,     // 加载状态，用于控制加载动画
    error: null,        // 错误信息
    result: null,       // 估价结果数据，包含预估价格、相似房源等
    chartData: [],      // 区域房价统计数据，用于图表展示
    history: [],        // 本地估价历史记录
    factors: [],        // 影响价格的关键因素列表（如：近地铁、学区房等）
    currentRegion: ''   // 当前选中的区域 (拼音/代码)
  }),

  // 定义操作 (Actions)
  actions: {
    /**
     * 执行估价搜索
     * 调用后端 API 获取估价结果，并处理相关业务逻辑（计算因素、保存历史）。
     * 
     * @param {Object} params - 用户输入的房源特征参数
     * @returns {Promise<boolean>} 成功返回 true
     */
    async search(params) {
      this.loading = true
      this.error = null
      try {
        // 构造请求载荷，转换部分字段格式以匹配后端接口
        const payload = {
          ...params,
          // 将 features 数组转换为布尔字段
          has_subway: params.features.includes('has_subway'),
          is_school_district: params.features.includes('is_school_district')
        }
        
        // 调用后端估价接口
        const response = await estimatePrice(payload)
        this.result = response.data
        
        // 搜索成功后，计算影响因素并保存到历史记录
        this.calculateFactors(params)
        this.saveHistory(params, this.result.estimated_price)
        
        // 更新图表数据 (传入当前区域)
        this.currentRegion = params.region // 确保更新当前区域
        this.fetchStats(params.region)
        
        return true
      } catch (error) {
        console.error('Search failed:', error)
        this.error = error.message || '估价服务暂时不可用'
        throw error
      } finally {
        this.loading = false
      }
    },

    /**
     * 获取区域统计数据
     * 用于初始化或更新房价趋势图表。
     */
    async fetchStats(region) {
      if (region) this.currentRegion = region
      try {
        const response = await getRegionStats(region || this.currentRegion)
        this.chartData = response.data
      } catch (error) {
        console.error("Failed to fetch stats:", error)
      }
    },

    /**
     * 计算影响价格的关键因素
     * 根据用户输入的特征，生成前端展示用的标签（如：近地铁 +5%）。
     * 注意：这里的逻辑仅用于前端展示，实际估价逻辑在后端。
     * 
     * @param {Object} params - 房源特征参数
     */
    calculateFactors(params) {
      const f = []
      // 正向因素
      if (params.features.includes('has_subway')) {
        f.push({ name: '近地铁', value: '+5%', type: 'success' })
      }
      if (params.features.includes('is_school_district')) {
        f.push({ name: '学区房', value: '+10%', type: 'success' })
      }
      // 楼层因素
      if (params.floor_type === 'low') f.push({ name: '低楼层', value: '-5%', type: 'danger' })
      if (params.floor_type === 'mid') f.push({ name: '中楼层', value: '+5%', type: 'success' })
      
      // 装修因素
      if (params.decoration === 'exquisite') f.push({ name: '精装', value: '+15%', type: 'success' })
      if (params.decoration === 'rough') f.push({ name: '毛坯', value: '-10%', type: 'danger' })
      
      // 房龄因素
      if (params.building_age > 20) {
        f.push({ name: '房龄较老', value: `-${Math.min(params.building_age * 0.5, 20).toFixed(1)}%`, type: 'danger' })
      } else if (params.building_age < 5) {
        f.push({ name: '次新房', value: '+2%', type: 'success' })
      }
      
      this.factors = f
    },

    /**
     * 从 LocalStorage 加载历史估价记录
     */
    loadHistory() {
      const hist = localStorage.getItem('house_price_history')
      if (hist) {
        this.history = JSON.parse(hist)
      }
    },

    /**
     * 保存单条估价记录到 LocalStorage
     * 
     * @param {Object} params - 房源特征
     * @param {number} price - 估算出的总价
     */
    saveHistory(params, price) {
      const entry = {
        ...params,
        price: formatPrice(price), // 格式化价格便于展示
        date: formatDate()         // 记录查询时间
      }
      // 添加到头部，保持最新的在最前
      this.history.unshift(entry)
      // 限制历史记录数量为 20 条
      if (this.history.length > 20) this.history.pop()
      // 持久化存储
      localStorage.setItem('house_price_history', JSON.stringify(this.history))
    },

    /**
     * 重置估价结果状态
     * 用于用户重新开始搜索时清空上一次的结果。
     */
    reset() {
      this.result = null
      this.factors = []
    }
  }
})
