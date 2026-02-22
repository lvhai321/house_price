<!--
  估价结果组件 (ValuationResult.vue)
  
  功能描述：
  展示房产估价的最终结果，包括预估总价、单价、置信度以及影响价格的关键因素标签。
  支持空状态显示（当没有结果时显示占位符）。
-->
<template>
  <transition name="fade" mode="out-in">
    <!-- 有结果时显示 -->
    <el-card v-if="result" class="box-card result-card" shadow="never">
      <div class="result-header">
        <!-- 价格信息区域 -->
        <div class="price-section">
          <span class="price-label">估算总价</span>
      <div class="price-value">
        <span class="currency">¥</span>
        <span class="number">
            <count-up 
                :end-val="Number(result.estimated_price) / 10000" 
                :decimal-places="2" 
                :duration="2" 
                :options="{ useEasing: true, useGrouping: true }"
            />
        </span>
        <span class="unit">万</span>
      </div>
          <div class="unit-price">
            单价 {{ Math.round(result.unit_price) }} 元/平米
          </div>
        </div>
        
        <!-- 置信度仪表盘 -->
        <div class="confidence-section">
           <div class="confidence-label">置信度 {{ 85 }}%</div>
           <el-progress 
             type="dashboard" 
             :percentage="85" 
             :width="60" 
             :color="'#2563EB'"
             :stroke-width="6"
             :show-text="false"
           />
        </div>
      </div>

      <!-- 影响因素标签展示 -->
      <div class="factors-row" v-if="factors.length > 0">
         <div 
            v-for="f in factors" 
            :key="f.name" 
            class="factor-item"
            :class="f.type"
          >
            <div class="factor-icon">
                <!-- 根据 value 正负显示上升或下降图标 -->
                <el-icon v-if="f.value.startsWith('+')"><Top /></el-icon>
                <el-icon v-else><Bottom /></el-icon>
            </div>
            <span class="factor-name">{{ f.name }}</span>
            <span class="factor-value">{{ f.value }}</span>
         </div>
      </div>
    </el-card>
    
    <!-- 无结果时显示占位符 -->
    <el-card v-else class="box-card result-card placeholder-card" shadow="never">
      <el-empty description="输入房源信息开始估价" :image-size="120" />
    </el-card>
  </transition>
</template>

<script setup>
import { Top, Bottom } from '@element-plus/icons-vue'
import CountUp from 'vue-countup-v3'

// --- Props 定义 ---
const props = defineProps({
  // 估价结果对象，包含 estimated_price, unit_price 等字段
  result: {
    type: Object,
    default: null
  },
  // 影响因素列表，每项包含 name, value, type
  factors: {
    type: Array,
    default: () => []
  }
})
</script>

<style scoped>
.box-card {
  background: var(--card-bg);
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,0.05);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
  margin-bottom: 24px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.box-card:hover {
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
    transform: translateY(-2px);
}

.result-card {
  background: linear-gradient(135deg, #ffffff 0%, #f8faff 100%);
  min-height: 220px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 32px;
}

.placeholder-card {
  align-items: center;
  color: var(--text-secondary);
  background: #fff;
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 32px;
}

.price-label {
  font-size: 15px;
  color: var(--text-secondary);
  display: block;
  margin-bottom: 12px;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.price-value {
  color: var(--accent-color);
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  display: flex;
  align-items: baseline;
  text-shadow: 0 2px 4px rgba(255, 102, 0, 0.1);
}

.currency {
  font-size: 32px;
  margin-right: 6px;
  font-weight: 500;
}

.number {
  font-size: 64px;
  font-weight: 800;
  line-height: 1;
  background: linear-gradient(45deg, var(--accent-color), #ff8e53);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.unit {
  font-size: 20px;
  margin-left: 8px;
  color: var(--text-secondary);
  font-weight: 500;
}

.unit-price {
  font-size: 16px;
  color: #64748b;
  margin-top: 12px;
  background: rgba(0,0,0,0.03);
  display: inline-block;
  padding: 4px 12px;
  border-radius: 20px;
}

.confidence-section {
  text-align: right;
  width: 120px;
}

.confidence-label {
  font-size: 13px;
  color: #94a3b8;
  margin-bottom: 8px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.factors-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  margin-top: 24px;
  border-top: 1px solid rgba(0,0,0,0.06);
  padding-top: 28px;
}

/* 自定义因子标签样式 */
.factor-item {
    display: inline-flex;
    align-items: center;
    padding: 8px 16px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 600;
    transition: transform 0.2s;
    cursor: default;
    box-shadow: 0 2px 6px rgba(0,0,0,0.04);
}

.factor-item:hover {
    transform: translateY(-1px);
}

.factor-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 8px;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: rgba(255,255,255,0.3);
}

.factor-name {
    margin-right: 6px;
    opacity: 0.9;
}

.factor-value {
    opacity: 1;
}

/* 红色标签 (负面/下跌) */
.factor-item.danger {
    background: linear-gradient(135deg, #fff1f2 0%, #ffe4e6 100%);
    color: #e11d48;
    border: 1px solid #fecdd3;
}

.factor-item.danger .factor-icon {
    background: #fecdd3;
    color: #be123c;
}

/* 绿色标签 (正面/上涨) */
.factor-item.success {
    background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
    color: #15803d;
    border: 1px solid #bbf7d0;
}

.factor-item.success .factor-icon {
    background: #bbf7d0;
    color: #166534;
}

/* 蓝色/中性标签 */
.factor-item.primary, .factor-item.info {
    background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}

.factor-item.primary .factor-icon {
    background: #bfdbfe;
    color: #1e40af;
}

/* Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.4s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
