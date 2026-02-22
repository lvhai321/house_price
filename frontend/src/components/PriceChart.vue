<!--
  房价趋势图表组件 (PriceChart.vue)
  
  功能描述：
  使用 ECharts 可视化库展示各区域的平均房价对比。
  
  主要特性：
  1. 响应式：监听窗口大小变化自动调整图表尺寸。
  2. 数据驱动：监听 chartData prop 变化自动更新图表内容。
-->
<template>
  <div ref="chartRef" class="chart-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import * as echarts from 'echarts'

const props = defineProps({
  // 图表数据，格式: [{ region: '朝阳', avg_unit_price: 80000 }, ...]
  chartData: {
    type: Array,
    default: () => []
  }
})

const chartRef = ref(null) // DOM 引用
let myChart = null         // ECharts 实例
let resizeObserver = null  // 尺寸观察器实例

/**
 * 初始化图表
 * 创建 ECharts 实例并设置初始配置
 */
const initChart = () => {
  // 防止重复初始化
  if (myChart) {
    myChart.dispose()
  }
  
  if (!chartRef.value) return

  myChart = echarts.init(chartRef.value)
  updateChartOption(props.chartData)
}

/**
 * 更新图表配置
 * 根据传入的数据重新渲染图表
 * @param {Object} data - 最新的图表数据 { months, prices, region }
 */
const updateChartOption = (data) => {
  if (!data || !data.months) return

  const option = {
    title: {
      text: `${data.region || '北京'} 房价走势`,
      left: 'center',
      textStyle: {
        color: '#1e293b',
        fontWeight: 'bold'
      }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'line',
        lineStyle: {
          color: '#cbd5e1',
          width: 2,
          type: 'dashed'
        }
      },
      valueFormatter: (value) => `¥${value}`
    },
    grid: {
      left: '3%',
      right: '6%',
      bottom: '10%',
      top: '15%',
      containLabel: true
    },
    xAxis: [
      {
        type: 'category',
        data: data.months,
        boundaryGap: false,
        axisLine: {
          lineStyle: {
            color: '#e2e8f0'
          }
        },
        axisLabel: {
          color: '#64748b',
          fontSize: 11,
          rotate: 0,
          interval: 0,
          formatter: (value) => {
             // 格式化日期，如果是当年则只显示月份
             if (!value) return ''
             const [year, month] = value.split('-')
             return `${month}月`
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
          padding: [0, 0, 0, 20]
        },
        splitLine: {
          lineStyle: {
            type: 'dashed',
            color: '#f1f5f9'
          }
        },
        axisLabel: {
          color: '#64748b'
        }
      }
    ],
    series: [
      {
        name: '平均单价',
        type: 'line',
        smooth: true,
        showSymbol: true,
        symbol: 'circle',
        symbolSize: 8,
        data: data.prices,
        itemStyle: {
          color: '#3b82f6',
          borderWidth: 2,
          borderColor: '#fff'
        },
        lineStyle: {
          width: 3,
          color: '#3b82f6',
          shadowColor: 'rgba(59, 130, 246, 0.3)',
          shadowBlur: 10,
          shadowOffsetY: 5
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(59, 130, 246, 0.2)' },
            { offset: 1, color: 'rgba(59, 130, 246, 0)' }
          ])
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
  } else {
    initChart()
  }
}, { deep: true })

// 处理窗口大小调整，使图表自适应
const handleResize = () => {
  myChart && myChart.resize()
}

// 生命周期钩子
onMounted(() => {
  nextTick(() => {
    initChart()
    // 监听窗口大小变化
    window.addEventListener('resize', handleResize)
    
    // 监听容器大小变化 (解决 Tab 切换导致的宽度问题)
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
.chart-container {
  width: 100%;
  height: 100%;
  min-height: 300px;
}
</style>
