<!--
  首页视图组件 (Home.vue)
  
  功能描述：
  作为应用的主入口页面，负责整合搜索表单、估价结果展示、相似房源列表和区域房价趋势图表。
  
  主要职责：
  1. 布局管理：使用 Element Plus Grid 系统进行响应式布局。
  2. 状态协调：连接 Pinia Store，分发搜索请求，管理加载状态。
  3. 组件通信：处理 SearchForm 的搜索事件，将结果传递给 ValuationResult 和 PriceChart。
  4. 历史记录管理：展示和应用用户的历史查询记录。
-->
<template>
  <div class="page-wrapper">
    <div class="home-container">
      <el-row :gutter="24" class="main-layout">
        <!-- 左侧列: 搜索表单区域 -->
        <el-col :xs="24" :sm="24" :md="8" :lg="8" class="left-column">
          <!-- 品牌标题区 -->
          <div class="brand-header">
            <h1 class="title">房价预测系统</h1>
            <p class="subtitle">精准 · 专业 · 实时</p>
          </div>
          
          <!-- 搜索表单组件 -->
          <SearchForm 
            ref="searchFormRef"
            :loading="loading"
            @search="handleSearch"
            @show-history="showHistory = true"
            @reset="handleReset"
          />
        </el-col>

        <!-- 右侧列: 结果展示与数据分析区域 -->
        <el-col :xs="24" :sm="24" :md="16" :lg="16" class="right-column">
          <!-- 估价结果卡片：展示预测价格和影响因素 -->
          <ValuationResult 
            :result="result"
            :factors="factors"
          />

          <!-- 数据分析选项卡：包含相似房源、趋势图表和历史记录 -->
          <el-card class="box-card tabs-card" shadow="never">
            <el-tabs v-model="activeTab" class="analysis-tabs">
              <!-- 选项卡 1: 搜索结果列表 -->
              <el-tab-pane label="搜索结果" name="search_results">
                <div class="search-result-bar" v-if="result && result.search_results && result.search_results.length > 0">
                    <el-alert
                        type="info"
                        :closable="false"
                        show-icon
                        class="custom-alert"
                    >
                        <template #title>
                            <span class="search-result-title">为您找到 <strong>{{ result.search_results.length }}</strong> 套相关房源</span>
                        </template>
                    </el-alert>
                </div>

                <div class="similar-list" v-loading="loading">
                  <el-scrollbar height="400px">
                    <!-- 展示搜索结果（同一区域的其他房源） -->
                    <div v-if="result && result.search_results && result.search_results.length > 0">
                       <div v-for="(house, index) in result.search_results" :key="'res-'+index" class="house-item">
                          <div class="house-info">
                            <div class="house-title">{{ house.title }}</div>
                            <div class="house-meta">
                              <span>{{ house.region }}</span>
                              <el-divider direction="vertical" />
                              <span>{{ house.layout }}</span>
                              <el-divider direction="vertical" />
                              <span>{{ house.area }}㎡</span>
                            </div>
                          </div>
                          <div class="house-price">
                            <span class="total">{{ house.total_price }}万</span>
                            <span class="unit">{{ house.unit_price }}元/平</span>
                          </div>
                          <el-button circle size="small" @click="openLink(house.url)">
                            <el-icon><ArrowRight /></el-icon>
                          </el-button>
                       </div>
                    </div>

                    <!-- 空状态 -->
                    <div v-else class="empty-state">
                       <el-empty description="暂无相关搜索结果" :image-size="120">
                          <template #description>
                            <p class="empty-desc">当前区域暂无房源，可能是数据未更新。</p>
                          </template>
                          <el-button type="primary" plain @click="triggerCrawl">立即更新数据</el-button>
                       </el-empty>
                    </div>
                  </el-scrollbar>
                </div>
              </el-tab-pane>

              <!-- 选项卡 2: 相似房源列表 -->
              <el-tab-pane label="相似房源" name="similar">
                <div class="similar-list" v-loading="loading">
                  <el-scrollbar height="400px">
                    <!-- 优先展示相似房源 -->
                    <div v-if="result && result.similar_houses.length > 0">
                       <div v-for="(house, index) in result.similar_houses" :key="'sim-'+index" class="house-item">
                          <div class="house-info">
                            <div class="house-title">{{ house.title }}</div>
                            <div class="house-meta">
                              <el-tag size="small" type="success" effect="plain" class="match-tag">相似度高</el-tag>
                              <span>{{ house.region }}</span>
                              <el-divider direction="vertical" />
                              <span>{{ house.layout }}</span>
                              <el-divider direction="vertical" />
                              <span>{{ house.area }}㎡</span>
                            </div>
                          </div>
                          <div class="house-price">
                            <span class="total">{{ house.total_price }}万</span>
                            <span class="unit">{{ house.unit_price }}元/平</span>
                          </div>
                          <el-button circle size="small" @click="openLink(house.url)">
                            <el-icon><ArrowRight /></el-icon>
                          </el-button>
                       </div>
                    </div>
                    
                    <!-- 空状态 -->
                    <div v-else class="empty-state">
                       <el-empty description="暂无相似房源数据" :image-size="120">
                          <template #description>
                            <p class="empty-desc">没有找到高度匹配的相似房源。</p>
                          </template>
                       </el-empty>
                    </div>
                  </el-scrollbar>
                </div>
              </el-tab-pane>
              
              <!-- 选项卡 2: 区域房价趋势图表 -->
              <el-tab-pane label="区域趋势" name="chart">
                <div class="chart-container">
                  <PriceChart 
                    ref="priceChartRef"
                    :chart-data="chartData" 
                    :loading="loading"
                    :region="currentRegion"
                  />
                </div>
              </el-tab-pane>
              
              <!-- 选项卡 3: 历史查询记录 -->
              <el-tab-pane label="历史记录" name="history">
                 <div class="history-list">
                    <el-scrollbar height="400px">
                      <div v-if="searchHistory.length > 0">
                         <div v-for="(item, index) in searchHistory" :key="index" class="house-item history-item" @click="applyHistory(item)">
                            <div class="house-info">
                              <div class="house-title">{{ item.date }}</div>
                              <div class="house-meta">
                                {{ item.region }} | {{ item.layout }} | {{ item.area }}㎡
                              </div>
                            </div>
                            <div class="house-price">
                              <span class="total">{{ item.price }}万</span>
                            </div>
                         </div>
                      </div>
                      <el-empty v-else description="暂无历史记录" />
                    </el-scrollbar>
                 </div>
              </el-tab-pane>
            </el-tabs>
          </el-card>

        </el-col>
      </el-row>
    </div>

    <!-- 侧边抽屉: 移动端或快速访问历史记录 -->
    <el-drawer v-model="showHistory" title="查询历史" size="300px">
       <el-timeline>
        <el-timeline-item v-for="(item, index) in searchHistory" :key="index" :timestamp="item.date" placement="top">
          <el-card class="history-card-mini" shadow="hover" @click="applyHistory(item)">
             <div class="history-header">
               <span class="history-region">{{ item.region }}</span>
               <span class="history-price">{{ item.price }}万</span>
             </div>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, watch, nextTick } from 'vue'
import { storeToRefs } from 'pinia'
import { useValuationStore } from '../stores/valuation'
import { ElMessage } from 'element-plus'
import { ArrowRight } from '@element-plus/icons-vue'
import PriceChart from '../components/PriceChart.vue'
import SearchForm from '../components/SearchForm.vue'
import ValuationResult from '../components/ValuationResult.vue'
// api import removed as it's no longer used directly in Home


// --- Store 集成 ---
// 使用 Pinia store 管理全局状态
const store = useValuationStore()
// 使用 storeToRefs 保持响应性解构
const { loading, result, chartData, history: searchHistory, factors, currentRegion } = storeToRefs(store)
const { search, fetchStats, loadHistory, reset } = store

// --- UI 状态 ---
const searchFormRef = ref(null) // 表单组件引用
const priceChartRef = ref(null) // 图表组件引用
const showHistory = ref(false)  // 控制历史记录抽屉显示
const activeTab = ref('search_results') // 当前激活的选项卡

// 监听 activeTab 变化，当切换到 chart 时手动触发 resize
watch(activeTab, (newVal) => {
  if (newVal === 'chart') {
    nextTick(() => {
      if (priceChartRef.value) {
        priceChartRef.value.resize()
      }
    })
  }
})

// --- 事件处理方法 ---

/**
 * 触发爬虫更新 (方案C)
 */
const triggerCrawl = () => {
  // 调用 SearchForm 组件暴露的方法来显示爬虫对话框
  if (searchFormRef.value) {
    searchFormRef.value.showCrawlDialog = true
    // 如果有历史记录，可以尝试预填充区域（可选，SearchForm 内部可能已有逻辑）
    if (searchHistory.value.length > 0) {
      searchFormRef.value.crawlForm.region = searchHistory.value[0].region || 'chaoyang'
    }
  }
}

/**
 * 处理重置事件
 * 清空 store 中的估价结果和相关状态
 */
const handleReset = () => {
  reset()
}

/**
 * 处理搜索事件
 * 调用 store 的 search action 进行估价
 * @param {Object} queryForm - 表单数据
 */
const handleSearch = async (queryForm) => {
  try {
    await search(queryForm)
    ElMessage.success('估价完成')
  } catch (error) {
    ElMessage.error('查询失败，请稍后重试')
  }
}

/**
 * 应用历史记录
 * 将历史记录中的数据回填到搜索表单，并关闭抽屉
 * @param {Object} item - 历史记录项
 */
const applyHistory = (item) => {
  if (searchFormRef.value) {
    searchFormRef.value.setFormValues(item)
    // 自动切换到搜索结果 Tab
    activeTab.value = 'search_results'
    // 触发一次搜索 (可选)
    handleSearch(item)
  }
  showHistory.value = false
}

/**
 * 打开外部链接
 * 用于跳转到房源原始详情页
 * @param {string} url - 目标 URL
 */
const openLink = (url) => {
  if (url) window.open(url, '_blank')
}

// --- 生命周期钩子 ---
onMounted(() => {
  // 组件挂载时仅加载历史记录，不再默认加载北京数据
  // fetchStats() 
  loadHistory()
})
</script>

<style scoped>
.page-wrapper {
  min-height: 100vh;
  background-color: #f1f5f9;
  padding-top: 40px;
  padding-bottom: 40px;
}

.home-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 0 20px;
}

/* Typography */
.brand-header {
  margin-bottom: 24px;
  padding-left: 4px;
}
.title {
  font-size: 36px;
  font-weight: 800;
  color: #1e293b;
  margin-bottom: 8px;
  letter-spacing: -0.5px;
  background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.subtitle {
  font-size: 16px;
  color: #64748b;
  margin: 0;
  font-weight: 500;
  letter-spacing: 2px;
}

/* Left Column */
.left-column {
  margin-bottom: 24px;
}

/* Tabs & Lists */
.box-card {
  background: var(--card-bg);
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,0.05);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
  margin-bottom: 24px;
  transition: all 0.3s ease;
  overflow: hidden;
}

.box-card:hover {
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.tabs-card :deep(.el-tabs__header) {
  margin-bottom: 0;
  border-bottom: 1px solid #f1f5f9;
  padding: 0 16px;
}

.tabs-card :deep(.el-tabs__nav-wrap::after) {
  display: none;
}

.tabs-card :deep(.el-tabs__active-bar) {
  background-color: var(--primary-color);
  height: 3px;
  border-radius: 2px;
  bottom: 0;
}

.tabs-card :deep(.el-tabs__item) {
  font-size: 15px;
  color: #64748b;
  font-weight: 600;
  padding: 16px 24px !important;
  height: auto;
  transition: all 0.3s;
}

.tabs-card :deep(.el-tabs__item.is-active) {
  color: var(--primary-color);
  font-weight: 700;
}

.tabs-card :deep(.el-tabs__item:hover) {
  color: var(--primary-color);
}

/* Similar House List */
.similar-list {
  padding: 0;
}

.house-item {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #f1f5f9;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  background: #fff;
}

.house-item:hover {
  background-color: #f8fafc;
  transform: translateX(4px);
}

.house-item:last-child {
  border-bottom: none;
}

.house-title {
  font-weight: 600;
  font-size: 16px;
  margin-bottom: 6px;
  color: #1e293b;
  line-height: 1.4;
}

.house-meta {
  font-size: 13px;
  color: #64748b;
  display: flex;
  align-items: center;
  font-weight: 500;
}

.house-meta .el-divider--vertical {
  margin: 0 12px;
  border-color: #cbd5e1;
}

.house-info {
  flex: 1;
}

.house-price {
  text-align: right;
  margin-right: 20px;
  width: 120px;
}

.house-price .total {
  display: block;
  font-size: 20px;
  font-weight: 700;
  color: #f97316;
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  letter-spacing: -0.5px;
}

.house-price .unit {
  font-size: 12px;
  color: #94a3b8;
  margin-top: 2px;
  display: block;
}

/* History List Styles */
.history-item .house-title {
  color: #475569;
  font-family: monospace;
  font-size: 14px;
}

.chart-container {
  height: 400px;
  padding: 24px;
}

/* History Mini Card */
.history-card-mini {
    cursor: pointer;
    border-radius: 12px;
    border: 1px solid #f1f5f9;
    transition: all 0.2s;
}
.history-card-mini:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.history-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-weight: 500;
}
.history-region {
    color: #475569;
}
.history-price {
    color: #f97316;
    font-weight: 700;
}

/* 搜索结果提示栏 */
.search-result-bar {
  margin: 16px 16px 8px 16px;
  padding: 0;
}

.custom-alert {
  background-color: #eff6ff;
  border: 1px solid #dbeafe;
  border-radius: 8px;
}

.custom-alert :deep(.el-alert__icon) {
  color: #3b82f6;
}

.search-result-title {
  font-weight: 500;
  color: #1e40af;
  font-size: 14px;
}
.search-result-title strong {
  color: #1d4ed8;
  font-weight: 700;
  margin: 0 2px;
}

/* 列表分区标题 */
.list-section-title {
  font-size: 13px;
  color: #94a3b8;
  font-weight: 600;
  padding: 8px 24px;
  background: #f8fafc;
  border-top: 1px solid #f1f5f9;
  border-bottom: 1px solid #f1f5f9;
}

.mt-4 {
  margin-top: 16px;
}

/* 匹配度标签 */
.match-tag {
  margin-right: 8px;
  height: 20px;
  padding: 0 6px;
  font-size: 11px;
}

/* 空状态 */
.empty-state {
  padding: 40px 0;
}

.empty-desc {
  color: #94a3b8;
  margin-bottom: 16px;
}
</style>
