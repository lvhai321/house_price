/**
 * 估价 Store（Pinia）
 * 负责整页的数据与流程：
 * - 管理加载状态、估价结果、趋势数据、历史记录
 * - 发起搜索、保存历史、拉取趋势
 * - 生成前端展示用的“影响因子”标签
 */
import { defineStore } from 'pinia'
import { estimatePrice, getRegionStats } from '../api'
import { formatPrice, formatDate } from '../utils/format'

export const useValuationStore = defineStore('valuation', {
  // 核心状态
  state: () => ({
    loading: false,     // 加载中
    error: null,        // 错误信息
    result: null,       // 估价结果（含相似房源）
    chartData: [],      // 区域趋势数据
    history: [],        // 历史记录
    factors: [],        // 展示用影响因子标签
    currentRegion: ''   // 当前查询的区域
  }),

  // 业务动作
  actions: {
    /**
     * 发起估价并联动更新趋势与历史
     */
    async search(params) {
      this.loading = true
      this.error = null
      try {
        // 特征预处理：数组 → 布尔字段
        const payload = {
          ...params,
          has_subway: params.features.includes('has_subway'),
          is_school_district: params.features.includes('is_school_district')
        }
        
        // 调后端估价
        const response = await estimatePrice(payload)
        this.result = response.data
        
        // 生成影响因子标签（展示用）
        this.calculateFactors(params)
        
        // 保存到本地历史
        this.saveHistory(params, this.result.estimated_price)
        
        // 更新趋势数据
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
     * 获取区域趋势数据
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
     * 生成“影响因子”标签（仅用于前端展示）
     */
    calculateFactors(params) {
      const f = []
      // 位置与政策
      if (params.features.includes('has_subway')) {
        f.push({ name: '近地铁', value: '+5%', type: 'success' })
      }
      if (params.features.includes('is_school_district')) {
        f.push({ name: '学区房', value: '+10%', type: 'success' })
      }
      // 楼层与采光
      if (params.floor_type === 'low') f.push({ name: '低楼层', value: '-5%', type: 'danger' })
      if (params.floor_type === 'mid') f.push({ name: '中楼层', value: '+5%', type: 'success' })
      
      // 装修质量
      if (params.decoration === 'exquisite') f.push({ name: '精装修', value: '+15%', type: 'success' })
      if (params.decoration === 'rough') f.push({ name: '毛坯房', value: '-10%', type: 'danger' })
      
      // 房屋折旧
      if (params.building_age > 20) {
        f.push({ name: '房龄偏老', value: `-${Math.min(params.building_age * 0.5, 20).toFixed(1)}%`, type: 'danger' })
      } else if (params.building_age < 5) {
        f.push({ name: '次新房', value: '+2%', type: 'success' })
      }
      
      this.factors = f
    },

    /**
     * 加载历史记录并兼容旧格式（统一为“万元，保留两位小数”）
     */
    loadHistory() {
      const hist = localStorage.getItem('house_price_history')
      if (hist) {
        const raw = JSON.parse(hist)
        // 旧记录可能为“元”的千分位字符串（如 "529,253.06"），统一转“万元”
        const normalized = raw.map((item) => {
          const p = item?.price
          if (typeof p === 'string') {
            const num = Number(String(p).replace(/,/g, ''))
            if (!Number.isNaN(num)) {
              const inWan = num > 10000 ? num / 10000 : num
              return { ...item, price: formatPrice(inWan) }
            }
          }
          return item
        })
        this.history = normalized
        localStorage.setItem('house_price_history', JSON.stringify(this.history))
      }
    },

    /**
     * 保存当前估价到本地（价格按万元两位小数）
     */
    saveHistory(params, price) {
      // 历史记录统一以“万元”为单位，保留两位小数
      const priceWan = Number(price) / 10000
      const entry = {
        ...params,
        price: formatPrice(priceWan),
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
     * 清空所有历史记录
     */
    clearHistory() {
      this.history = []
      localStorage.removeItem('house_price_history')
    },

    /**
     * 删除指定索引的历史记录
     * @param {number} index - 要删除的记录索引
     */
    removeHistoryItem(index) {
      if (index >= 0 && index < this.history.length) {
        this.history.splice(index, 1)
        localStorage.setItem('house_price_history', JSON.stringify(this.history))
      }
    },

    /**
     * 重置当前结果与因子
     */
    reset() {
      this.result = null
      this.factors = []
    }
  }
})
