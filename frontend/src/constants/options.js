/**
 * 界面配置常量模块
 * ----------------
 * 统一管理前端下拉菜单、多选框的选项数据。
 * 这里的 label 用于界面展示，value 对应后端接口要求的参数值。
 */

// 户型选项：涵盖了主流的住宅格局
export const layoutOptions = [
  { label: '1室1厅', value: '1室1厅' },
  { label: '2室1厅', value: '2室1厅' },
  { label: '2室2厅', value: '2室2厅' },
  { label: '3室1厅', value: '3室1厅' },
  { label: '3室2厅', value: '3室2厅' },
  { label: '4室2厅', value: '4室2厅' },
  { label: '5室及以上', value: '5室2厅' },
]

// 楼层位置：反映了房屋的采光和视野情况
export const floorOptions = [
  { label: '低楼层', value: 'low' },
  { label: '中楼层', value: 'mid' },
  { label: '高楼层', value: 'high' },
]

// 装修程度：对房屋估值有显著影响
export const decorationOptions = [
  { label: '毛坯', value: 'rough' },
  { label: '简装', value: 'simple' },
  { label: '精装', value: 'exquisite' },
]

// 房屋朝向：中国北方及大部分地区偏好南向
export const orientationOptions = [
  { label: '朝南', value: 'south' },
  { label: '朝北', value: 'north' },
  { label: '朝东', value: 'east' },
  { label: '朝西', value: 'west' },
]

// 附加特征：溢价较高的核心属性
export const featureOptions = [
  { label: '近地铁', value: 'has_subway' },
  { label: '学区房', value: 'is_school_district' },
]
