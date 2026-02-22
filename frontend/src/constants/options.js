/**
 * 静态常量配置模块
 * 定义前端表单使用的下拉选项数据，如区域、户型、楼层等。
 * 保持与后端模型定义的一致性。
 */

// 区域选项：北京主要行政区
export const REGIONS = [
  { label: "朝阳", value: "朝阳" },
  { label: "海淀", value: "海淀" },
  { label: "丰台", value: "丰台" },
  { label: "东城", value: "东城" },
  { label: "西城", value: "西城" },
  { label: "昌平", value: "昌平" },
  { label: "通州", value: "通州" },
  { label: "石景山", value: "石景山" },
  { label: "顺义", value: "顺义" },
  { label: "房山", value: "房山" },
  { label: "大兴", value: "大兴" },
];

// 户型选项：常见的房屋格局
export const LAYOUTS = [
  { label: "1室1厅", value: "1室1厅" },
  { label: "2室1厅", value: "2室1厅" },
  { label: "2室2厅", value: "2室2厅" },
  { label: "3室1厅", value: "3室1厅" },
  { label: "3室2厅", value: "3室2厅" },
  { label: "4室2厅", value: "4室2厅" },
];

// 楼层类型选项：对应后端 FLOOR_CHOICES
export const FLOOR_TYPES = [
  { label: "低楼层", value: "low" },
  { label: "中楼层", value: "mid" },
  { label: "高楼层", value: "high" },
];

// 朝向选项：对应后端 ORIENTATION_CHOICES
export const ORIENTATIONS = [
  { label: "南", value: "south" },
  { label: "北", value: "north" },
  { label: "东", value: "east" },
  { label: "西", value: "west" },
];

// 装修状况选项：对应后端 DECORATION_CHOICES
export const DECORATIONS = [
  { label: "精装", value: "exquisite" },
  { label: "简装", value: "simple" },
  { label: "毛坯", value: "rough" },
];
