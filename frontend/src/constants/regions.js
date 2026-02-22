/**
 * 地区映射常量表
 * 用于将后端返回的拼音/英文区域代码转换为中文名称，提升用户体验。
 */
export const REGION_MAP = {
  // 城市
  'beijing': '北京',
  'bj': '北京',
  'shanghai': '上海',
  'sh': '上海',
  'guangzhou': '广州',
  'gz': '广州',
  'shenzhen': '深圳',
  'sz': '深圳',
  'hangzhou': '杭州',
  'hz': '杭州',
  'wuhan': '武汉',
  'wh': '武汉',
  'chengdu': '成都',
  'cd': '成都',

  // 北京行政区
  'chaoyang': '朝阳',
  'haidian': '海淀',
  'dongcheng': '东城',
  'xicheng': '西城',
  'fengtai': '丰台',
  'shijingshan': '石景山',
  'tongzhou': '通州',
  'changping': '昌平',
  'daxing': '大兴',
  'shunyi': '顺义',
  'fangshan': '房山',
  'mentougou': '门头沟',
  'pinggu': '平谷',
  'huairou': '怀柔',
  'miyun': '密云',
  'yanqing': '延庆',

  // 上海行政区 (示例)
  'pudong': '浦东',
  'minhang': '闵行',
  'baoshan': '宝山',
  'jiading': '嘉定',
  'songjiang': '松江',
  'qingpu': '青浦',
  'fengxian': '奉贤',
  'jinshan': '金山',
  'huangpu': '黄浦',
  'xuhui': '徐汇',
  'changning': '长宁',
  'jingan': '静安',
  'putuo': '普陀',
  'hongkou': '虹口',
  'yangpu': '杨浦'
}

/**
 * 获取标准化的中文区域名称
 * @param {string} code - 区域代码或拼音 (如 'chaoyang')
 * @returns {string} 中文名称 (如 '朝阳')，若未找到映射则格式化原字符串
 */
export const getRegionName = (code) => {
  if (!code) return '该地区'
  
  // 尝试直接匹配
  const lowerCode = code.toLowerCase()
  if (REGION_MAP[lowerCode]) {
    return REGION_MAP[lowerCode]
  }
  
  // 如果是拼音组合 (简单处理，暂不支持复杂分词)
  // 这里可以作为一个扩展点，接入更复杂的拼音转汉字库
  
  // 默认回退：首字母大写
  return code.charAt(0).toUpperCase() + code.slice(1)
}
