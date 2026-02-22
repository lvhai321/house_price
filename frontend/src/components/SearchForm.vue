<!--
  搜索表单组件 (SearchForm.vue)
  
  功能描述：
  提供房产估价所需的各项参数输入界面。
  
  主要特性：
  1. 表单验证：使用 Element Plus Form 验证机制确保必填项。
  2. 交互优化：提供快捷特征开关（地铁、学区），支持重置和历史记录调用。
  3. 数据暴露：通过 defineExpose 暴露 setFormValues 方法，供父组件回填历史数据。
-->
<template>
  <el-card class="box-card form-card" shadow="never">
    <template #header>
      <div class="card-header">
        <span class="header-title">
          <el-icon class="header-icon"><House /></el-icon>
          房源参数
        </span>
        <div class="header-actions">
          <!-- 查看历史记录按钮 -->
          <el-button link @click="$emit('show-history')" type="primary" size="small">
            <el-icon><Clock /></el-icon>
          </el-button>
          <!-- 更新数据按钮 -->
          <el-button link @click="showCrawlDialog = true" type="success" size="small">
            <el-icon><Download /></el-icon>
          </el-button>
          <!-- 重置表单按钮 -->
          <el-button link @click="resetForm" type="info" size="small">
            <el-icon><RefreshRight /></el-icon>
          </el-button>
        </div>
      </div>
    </template>
    <el-form 
      ref="formRef"
      :model="queryForm" 
      :rules="rules"
      label-position="top"
      class="custom-form"
    >
      <!-- 区域选择 -->
      <el-form-item label="区域" prop="region">
        <el-input 
          v-model="queryForm.region" 
          placeholder="请输入区域名称 (如: 朝阳, 海淀)" 
          style="width: 100%" 
          size="large"
          clearable
        >
          <template #prefix>
            <el-icon><Location /></el-icon>
          </template>
        </el-input>
      </el-form-item>

      <el-row :gutter="12">
        <el-col :span="12">
          <!-- 面积输入 -->
          <el-form-item label="面积 (㎡)" prop="area">
            <el-input-number v-model="queryForm.area" :min="10" :max="1000" style="width: 100%" size="large" :controls="false" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <!-- 户型选择 -->
          <el-form-item label="户型" prop="layout">
            <el-select v-model="queryForm.layout" placeholder="选择户型" style="width: 100%" size="large">
              <el-option 
                v-for="item in layouts" 
                :key="item.value" 
                :label="item.label" 
                :value="item.value" 
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="12">
        <el-col :span="12">
          <!-- 楼层选择 -->
           <el-form-item label="楼层" prop="floor_type">
            <el-select v-model="queryForm.floor_type" placeholder="选择楼层" style="width: 100%" size="large">
              <el-option 
                v-for="item in floorTypes" 
                :key="item.value" 
                :label="item.label" 
                :value="item.value" 
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <!-- 朝向选择 -->
          <el-form-item label="朝向" prop="orientation">
            <el-select v-model="queryForm.orientation" placeholder="选择朝向" style="width: 100%" size="large">
              <el-option 
                v-for="item in orientations" 
                :key="item.value" 
                :label="item.label" 
                :value="item.value" 
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="12">
        <el-col :span="12">
          <!-- 装修选择 -->
          <el-form-item label="装修" prop="decoration">
            <el-select v-model="queryForm.decoration" placeholder="选择装修" style="width: 100%" size="large">
              <el-option 
                v-for="item in decorations" 
                :key="item.value" 
                :label="item.label" 
                :value="item.value" 
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
           <!-- 房龄输入 -->
           <el-form-item label="房龄 (年)" prop="building_age">
            <el-input-number v-model="queryForm.building_age" :min="0" :max="100" style="width: 100%" size="large" :controls="false" />
          </el-form-item>
        </el-col>
      </el-row>

      <!-- 特征快捷开关：点击切换状态 -->
      <el-form-item label="特征" class="feature-item">
        <div class="feature-toggles">
          <div class="toggle-item" :class="{ active: featureFlags.has_subway }" @click="featureFlags.has_subway = !featureFlags.has_subway">
            <el-icon><Position /></el-icon>
            <span>近地铁</span>
          </div>
          <div class="toggle-item" :class="{ active: featureFlags.is_school_district }" @click="featureFlags.is_school_district = !featureFlags.is_school_district">
            <el-icon><School /></el-icon>
            <span>学区房</span>
          </div>
        </div>
      </el-form-item>

      <div class="form-footer">
        <el-button type="primary" size="large" @click="handleSearch" :loading="loading" class="search-btn">
          立即估价
        </el-button>
      </div>
    </el-form>
  </el-card>

  <!-- 爬虫控制弹窗 -->
  <el-dialog v-model="showCrawlDialog" title="更新房源数据" width="400px">
    <el-form :model="crawlForm" label-position="top">
      <el-form-item label="城市子域名 (如: bj, sh)">
        <el-input v-model="crawlForm.city_subdomain" placeholder="请输入城市缩写" />
      </el-form-item>
      <el-form-item label="区域名称 (如: 朝阳)">
        <el-input v-model="crawlForm.region" placeholder="请输入区域名称" />
      </el-form-item>
      <el-form-item label="爬取页数">
        <el-input-number v-model="crawlForm.pages" :min="1" :max="10" />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showCrawlDialog = false">取消</el-button>
        <el-button type="primary" @click="handleCrawl">开始更新</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { House, Clock, RefreshRight, Position, School, Download, Location } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { REGIONS, LAYOUTS, FLOOR_TYPES, ORIENTATIONS, DECORATIONS } from '@/constants/options'
import { startCrawl } from '@/api'

// --- Props 定义 ---
const props = defineProps({
  loading: Boolean // 搜索加载状态
})

// --- Emits 定义 ---
const emit = defineEmits(['search', 'show-history', 'reset'])

const formRef = ref(null)

// --- 爬虫相关状态 ---
const showCrawlDialog = ref(false)
const crawlForm = reactive({
  // 将城市子域名默认值设为空，让后端自动判断
  city_subdomain: '',
  region: '',
  pages: 1
})

const handleCrawl = async () => {
  if (!crawlForm.region) {
    ElMessage.warning('请输入区域名称')
    return
  }
  
  try {
    const res = await startCrawl(crawlForm)
    if (res.data.status === 'success') {
       ElMessage.success(`更新成功，新增 ${res.data.count} 条数据`)
       emit('search', queryForm) // 刷新主列表
    } else {
       ElMessage.warning(res.data.message || '更新未完成')
    }
  } catch (error) {
    ElMessage.error('更新失败: ' + (error.response?.data?.message || error.message))
  } finally {
    showCrawlDialog.value = false
  }
}

// --- 响应式表单数据 ---
const queryForm = reactive({
  region: '',
  area: 90,
  layout: '',
  floor_type: 'mid',
  building_age: 5,
  decoration: 'simple',
  orientation: 'south',
  features: []
})

// --- 特征标志位 ---
// 独立的状态用于 UI 切换显示，并通过 Watcher 同步到 queryForm.features
const featureFlags = reactive({
  has_subway: false,
  is_school_district: false
})

// 监听特征标志位变化，自动更新 queryForm.features 数组
watch(() => featureFlags.has_subway, (val) => {
  updateFeatures('has_subway', val)
})
watch(() => featureFlags.is_school_district, (val) => {
  updateFeatures('is_school_district', val)
})

/**
 * 更新特征数组
 * @param {string} key - 特征键名
 * @param {boolean} val - 是否选中
 */
const updateFeatures = (key, val) => {
  if (val) {
    if (!queryForm.features.includes(key)) queryForm.features.push(key)
  } else {
    const idx = queryForm.features.indexOf(key)
    if (idx > -1) queryForm.features.splice(idx, 1)
  }
}

// --- 表单验证规则 ---
const rules = {
  region: [{ required: true, message: '请输入区域名称', trigger: 'blur' }],
  area: [{ required: true, message: '请输入面积', trigger: 'blur' }],
  layout: [{ required: true, message: '请选择户型', trigger: 'change' }],
  floor_type: [{ required: true, message: '请选择楼层', trigger: 'change' }],
  decoration: [{ required: true, message: '请选择装修', trigger: 'change' }],
  orientation: [{ required: true, message: '请选择朝向', trigger: 'change' }]
}

// 默认表单数据，用于重置
const defaultForm = {
  region: '',
  area: 90,
  layout: '',
  floor_type: 'mid',
  building_age: 5,
  decoration: 'simple',
  orientation: 'south',
  features: []
}

/**
 * 重置表单
 * 恢复到默认值并通知父组件
 */
const resetForm = () => {
  Object.assign(queryForm, defaultForm)
  featureFlags.has_subway = false
  featureFlags.is_school_district = false
  emit('reset')
  ElMessage.info('表单已重置')
}

/**
 * 提交搜索
 * 验证表单通过后触发 search 事件
 */
const handleSearch = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate((valid) => {
    if (valid) {
      emit('search', { ...queryForm })
    } else {
      ElMessage.warning('请检查表单填写')
    }
  })
}

/**
 * 设置表单值
 * 暴露给父组件的方法，通常用于从历史记录恢复表单状态
 * @param {Object} values - 要回填的表单数据
 */
const setFormValues = (values) => {
  Object.assign(queryForm, values)
  featureFlags.has_subway = values.features.includes('has_subway')
  featureFlags.is_school_district = values.features.includes('is_school_district')
}

// 导出常量供模板使用，避免在 setup 中重复定义
const layouts = LAYOUTS
const floorTypes = FLOOR_TYPES
const orientations = ORIENTATIONS
const decorations = DECORATIONS

// 暴露方法供父组件通过 ref 调用
defineExpose({
  setFormValues,
  showCrawlDialog,
  crawlForm
})
</script>

<style scoped>
.box-card {
  background: var(--card-bg);
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,0.05);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
  margin-bottom: 24px;
  transition: all 0.3s ease;
}

.box-card:hover {
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.form-card {
  position: sticky;
  top: 24px;
  max-height: calc(100vh - 48px);
  overflow-y: auto;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(0,0,0,0.05);
  margin-bottom: 8px;
}

.header-title {
  font-size: 18px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 10px;
  color: #1e293b;
  letter-spacing: 0.5px;
}

.header-icon {
  color: var(--primary-color);
  font-size: 20px;
}

/* Feature Toggles */
.feature-toggles {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 8px;
}

.toggle-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  color: #64748b;
  background: #f8fafc;
  padding: 10px 18px;
  border-radius: 12px;
  cursor: pointer;
  user-select: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid transparent;
  font-weight: 500;
}

.toggle-item:hover {
  background: #f1f5f9;
  transform: translateY(-1px);
}

.toggle-item.active {
  background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
  color: #2563eb;
  border-color: #bfdbfe;
  font-weight: 600;
  box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.1), 0 2px 4px -1px rgba(37, 99, 235, 0.06);
}

/* Compact Form Styles */
.custom-form :deep(.el-form-item) {
  margin-bottom: 24px;
}

/* 统一输入框和下拉框的高度与样式 */
.custom-form :deep(.el-input__wrapper),
.custom-form :deep(.el-select__wrapper) {
  border-radius: 12px;
  box-shadow: 0 0 0 1px #e2e8f0 inset !important;
  padding: 0 16px; /* 统一内边距 */
  transition: all 0.3s ease;
  background-color: #f8fafc;
  height: 48px; /* 强制统一高度 */
  line-height: 48px;
  box-sizing: border-box;
}

/* 针对 InputNumber 的特殊处理，使其内部 input 居中 */
.custom-form :deep(.el-input-number .el-input__inner) {
  height: 48px;
  line-height: 48px;
  text-align: left; /* 保持左对齐，与 Select 文字一致 */
}

/* 移除 InputNumber 默认的边框，完全依赖 wrapper 的样式 */
.custom-form :deep(.el-input-number__decrease),
.custom-form :deep(.el-input-number__increase) {
  display: none; /* 隐藏加减按钮，保持简洁 */
}

.custom-form :deep(.el-input__wrapper:hover),
.custom-form :deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px #94a3b8 inset !important;
  background-color: #fff;
}

.custom-form :deep(.el-input__wrapper.is-focus),
.custom-form :deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2) !important;
  background-color: #fff;
  border-color: var(--primary-color);
}

.custom-form :deep(.el-form-item__label) {
  padding-bottom: 8px;
  line-height: 1.5;
  font-size: 14px;
  font-weight: 600;
  color: #475569;
  letter-spacing: 0.3px;
}

.form-footer {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #f1f5f9;
}

.search-btn {
  width: 100%;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  border: none;
  border-radius: 12px;
  font-weight: 600;
  margin-top: 12px;
  height: 56px;
  font-size: 18px;
  letter-spacing: 1px;
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3), 0 4px 6px -2px rgba(37, 99, 235, 0.1);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(37, 99, 235, 0.4), 0 10px 10px -5px rgba(37, 99, 235, 0.2);
  filter: brightness(1.1);
}

.search-btn:active {
  transform: translateY(0);
}
</style>
