<!--
  房价趋势图表组件 (PriceChart.vue)
  
  功能描述：
  使用 ECharts 可视化库展示各区域的平均房价对比。
  
  主要特性：
  1. 响应式：监听窗口大小变化自动调整图表尺寸。
  2. 数据驱动：监听 chartData prop 变化自动更新图表内容。
  3. 区域名称标准化：自动将拼音转换为中文显示。
-->
<template>
  <div class="chart-wrapper" v-loading="loading" element-loading-text="趋势数据加载中...">
    <div v-if="hasData" ref="chartRef" class="chart-container"></div>
    <div v-else class="empty-container">
      <el-empty :description="emptyDescription" :image-size="120">
        <template #description>
          <p class="empty-text">{{ emptyDescription }}</p>
          <p class="empty-sub">{{ emptySubDescription }}</p>
        </template>
      </el-empty>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, nextTick, computed } from 'vue'
import * as echarts from 'echarts'
import { getRegionName } from '../constants/regions'

const props = defineProps({
  // 图表数据对象 { months: [], prices: [], region: '' }
  chartData: {
    type: Object,
    default: () => ({ months: [], prices: [], region: '' })
  },
  // 当前加载状态
  loading: {
    type: Boolean,
    default: false
  },
  // 当前选中的区域（优先使用此 Prop 显示标题）
  region: {
    type: String,
    default: ''
  }
})

const chartRef = ref(null) // DOM 引用
let myChart = null         // ECharts 实例
let resizeObserver = null  // 尺寸观察器实例

// 计算是否有有效数据
const hasData = computed(() => {
  return props.chartData && 
         props.chartData.months && 
         props.chartData.months.length > 0 &&
         props.chartData.prices &&
         props.chartData.prices.length > 0 &&
         props.region // 必须有选中的区域
})

// 计算空状态描述
const emptyDescription = computed(() => {
  if (!props.region) {
    return '请先进行搜索'
  }
  const regionName = getRegionName(props.region || (props.chartData ? props.chartData.region : ''))
  return `暂无 ${regionName} 房价走势`
})

// 计算空状态子描述
const emptySubDescription = computed(() => {
  if (!props.region) {
    return '搜索后将展示该区域的房价趋势图表'
  }
  return '暂无该时间段的价格数据'
})

/**
 * 初始化图表
 */
const initChart = () => {
  if (myChart) {
    myChart.dispose()
  }
  
  if (!chartRef.value) return

  myChart = echarts.init(chartRef.value)
  updateChartOption(props.chartData)
}

/**
 * 更新图表配置
 */
const updateChartOption = (data) => {
  if (!hasData.value) return

  // 确定显示的区域名称：优先用 Prop 传入的（实时性更高），其次用后端返回的
  const regionCode = props.region || data.region || 'beijing'
  const regionName = getRegionName(regionCode)

  const option = {
    title: {
      text: `${regionName} 房价走势`,
      left: 'center',
      top: 0,
      textStyle: {
        color: '#1e293b',
        fontWeight: 'bold',
        fontSize: 18,
        fontFamily: "'Helvetica Neue', Helvetica, Arial, sans-serif"
      }
    },
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#e2e8f0',
      borderWidth: 1,
      textStyle: {
        color: '#334155'
      },
      axisPointer: {
        type: 'line',
        lineStyle: {
          color: '#64748b',
          width: 1,
          type: 'dashed'
        }
      },
      formatter: function (params) {
        const item = params[0]
        return `
          <div style="padding: 4px;">
            <div style="font-size: 12px; color: #64748b; margin-bottom: 4px;">${item.axisValue}</div>
            <div style="font-size: 14px; font-weight: 600; color: #3b82f6;">
              <span style="display:inline-block;margin-right:4px;border-radius:50%;width:8px;height:8px;background-color:#3b82f6;"></span>
              ${item.seriesName}: ¥${item.value.toLocaleString()}
            </div>
          </div>
        `
      }
    },
    grid: {
      left: '2%',
      right: '4%',
      bottom: '5%',
      top: '18%',
      containLabel: true
    },
    xAxis: [
      {
        type: 'category',
        data: data.months,
        boundaryGap: false,
        axisLine: {
          lineStyle: {
            color: '#cbd5e1'
          }
        },
        axisTick: {
          show: false
        },
        axisLabel: {
          color: '#64748b',
          fontSize: 12,
          margin: 14,
          formatter: (value) => {
             if (!value) return ''
             const [year, month] = value.split('-')
             return `${parseInt(month)}月`
          }
        }
      }
    ],
    yAxis: [
      {
        type: 'value',
        name: '单价 (元/平米)',
        nameTextStyle: {
          color: '#94a3b8',
          padding: [0, 0, 0, 10],
          fontSize: 12
        },
        splitLine: {
          lineStyle: {
            type: 'dashed',
            color: '#f1f5f9'
          }
        },
        axisLabel: {
          color: '#94a3b8',
          formatter: (value) => value >= 10000 ? `${value/10000}万` : value
        }
      }
    ],
    series: [
      {
        name: '平均单价',
        type: 'line',
        smooth: 0.4,
        showSymbol: false,
        symbol: 'circle',
        symbolSize: 6,
        data: data.prices,
        itemStyle: {
          color: '#3b82f6',
          borderWidth: 2,
          borderColor: '#fff'
        },
        lineStyle: {
          width: 3,
          color: '#3b82f6',
          shadowColor: 'rgba(59, 130, 246, 0.2)',
          shadowBlur: 10,
          shadowOffsetY: 8
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(59, 130, 246, 0.15)' },
            { offset: 1, color: 'rgba(59, 130, 246, 0.02)' }
          ])
        },
        emphasis: {
          scale: true,
          focus: 'series'
        }
      }
    ]
  }

  myChart.setOption(option)
}

// 监听数据变化更新图表
watch(() => props.chartData, (newVal) => {
  if (myChart) {
    updateChartOption(newVal)
  } else if (hasData.value) {
    initChart()
  }
}, { deep: true })

// 监听 region 变化更新标题 (即使数据未变)
watch(() => props.region, () => {
  if (myChart && hasData.value) {
    updateChartOption(props.chartData)
  }
})

// 处理窗口大小调整，使图表自适应
const handleResize = () => {
  myChart && myChart.resize()
}

// 暴露 resize 方法供父组件调用
defineExpose({
  resize: handleResize
})

// 生命周期钩子
onMounted(() => {
  nextTick(() => {
    if (hasData.value) {
      initChart()
    }
    window.addEventListener('resize', handleResize)
    
    if (chartRef.value) {
      resizeObserver = new ResizeObserver(() => {
        handleResize()
      })
      resizeObserver.observe(chartRef.value)
    }
  })
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  if (resizeObserver) {
    resizeObserver.disconnect()
  }
  if (myChart) {
    myChart.dispose()
  }
})
</script>

<style scoped>
.chart-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
  min-height: 320px;
}

.chart-container {
  width: 100%;
  height: 100%;
}

.empty-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  width: 100%;
}

.empty-text {
  font-size: 14px;
  color: #64748b;
  margin-bottom: 4px;
}

.empty-sub {
  font-size: 12px;
  color: #94a3b8;
}
</style>
