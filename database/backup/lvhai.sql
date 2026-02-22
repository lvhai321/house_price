/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80025
 Source Host           : localhost:3306
 Source Schema         : lvhai

 Target Server Type    : MySQL
 Target Server Version : 80025
 File Encoding         : 65001

 Date: 01/02/2026 19:44:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for district_stats
-- ----------------------------
DROP TABLE IF EXISTS `district_stats`;
CREATE TABLE `district_stats`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '区/县',
  `subdistrict` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '街道/板块',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `avg_price` decimal(8, 2) NOT NULL COMMENT '平均单价(元/㎡)',
  `median_price` decimal(8, 2) NOT NULL COMMENT '中位数单价',
  `min_price` decimal(8, 2) NOT NULL COMMENT '最低单价',
  `max_price` decimal(8, 2) NOT NULL COMMENT '最高单价',
  `total_listings` int NOT NULL COMMENT '挂牌房源总数',
  `avg_area` decimal(8, 2) NULL DEFAULT NULL COMMENT '平均面积(㎡)',
  `avg_days_on_market` int NULL DEFAULT NULL COMMENT '平均挂牌天数',
  `price_change_weekly` decimal(5, 2) NULL DEFAULT NULL COMMENT '周价格变化(%)',
  `price_change_monthly` decimal(5, 2) NULL DEFAULT NULL COMMENT '月价格变化(%)',
  `popular_communities` json NULL COMMENT '热门小区JSON数据',
  `school_district_info` json NULL COMMENT '学区信息JSON',
  `transportation_score` decimal(3, 2) NULL DEFAULT NULL COMMENT '交通便利度评分0-5',
  `commercial_score` decimal(3, 2) NULL DEFAULT NULL COMMENT '商业配套评分0-5',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_location_stat_date`(`province` ASC, `city` ASC, `district` ASC, `subdistrict` ASC, `stat_date` ASC) USING BTREE,
  INDEX `idx_province`(`province` ASC) USING BTREE,
  INDEX `idx_city`(`city` ASC) USING BTREE,
  INDEX `idx_district`(`district` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE,
  INDEX `idx_avg_price`(`avg_price` ASC) USING BTREE,
  INDEX `idx_total_listings`(`total_listings` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '区域统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for house_data
-- ----------------------------
DROP TABLE IF EXISTS `house_data`;
CREATE TABLE `house_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `source_platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据来源：lianjia/fang/anjuke',
  `external_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '外部平台ID，用于去重',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '房源标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '房源描述',
  `total_price` decimal(12, 2) NOT NULL COMMENT '总价(万元)',
  `price_per_m2` decimal(8, 2) NOT NULL COMMENT '单价(元/㎡)',
  `area` decimal(8, 2) NOT NULL COMMENT '建筑面积(㎡)',
  `rooms` tinyint NOT NULL COMMENT '室',
  `living_rooms` tinyint NULL DEFAULT 1 COMMENT '厅',
  `bathrooms` tinyint NULL DEFAULT 1 COMMENT '卫',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '省份',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '区/县',
  `subdistrict` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '街道/板块',
  `community` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小区名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `floor_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层信息，如\"3/6层\"',
  `floor_position` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层位置',
  `total_floors` smallint NULL DEFAULT NULL COMMENT '总楼层',
  `house_age` smallint NULL DEFAULT NULL COMMENT '建筑年代/房龄',
  `orientation` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '朝向',
  `decoration` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '装修情况',
  `has_elevator` tinyint(1) NULL DEFAULT NULL COMMENT '是否有电梯',
  `near_subway` tinyint(1) NULL DEFAULT NULL COMMENT '是否近地铁',
  `subway_distance` decimal(6, 2) NULL DEFAULT NULL COMMENT '距离地铁距离(米)',
  `has_school` tinyint(1) NULL DEFAULT NULL COMMENT '是否学区房',
  `school_names` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对口学校',
  `property_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '物业类型：普通住宅/别墅等',
  `listing_date` date NULL DEFAULT NULL COMMENT '挂牌日期',
  `crawl_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '爬取时间',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原始URL',
  `data_status` tinyint NULL DEFAULT 1 COMMENT '数据状态：1有效/0无效',
  `tags` json NULL COMMENT '标签数据：JSON格式',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_external_id`(`external_id` ASC) USING BTREE,
  INDEX `idx_source_platform`(`source_platform` ASC) USING BTREE,
  INDEX `idx_city`(`city` ASC) USING BTREE,
  INDEX `idx_district`(`district` ASC) USING BTREE,
  INDEX `idx_total_price`(`total_price` ASC) USING BTREE,
  INDEX `idx_price_per_m2`(`price_per_m2` ASC) USING BTREE,
  INDEX `idx_area`(`area` ASC) USING BTREE,
  INDEX `idx_rooms`(`rooms` ASC) USING BTREE,
  INDEX `idx_listing_date`(`listing_date` ASC) USING BTREE,
  INDEX `idx_crawl_time`(`crawl_time` ASC) USING BTREE,
  INDEX `idx_data_status`(`data_status` ASC) USING BTREE,
  INDEX `idx_community`(`community` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '房源数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for search_records
-- ----------------------------
DROP TABLE IF EXISTS `search_records`;
CREATE TABLE `search_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会话ID，匿名用户跟踪',
  `area` decimal(8, 2) NOT NULL COMMENT '房屋面积(㎡)，如89.50',
  `rooms` tinyint NOT NULL COMMENT '卧室数量，1-5',
  `living_rooms` tinyint NULL DEFAULT 1 COMMENT '客厅数量',
  `bathrooms` tinyint NULL DEFAULT 1 COMMENT '卫生间数量',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '行政区域，如\"浦东新区\"',
  `subdistrict` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '街道/板块，如\"陆家嘴\"',
  `floor_position` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '楼层位置：low/middle/high',
  `total_floors` smallint NULL DEFAULT NULL COMMENT '总楼层数',
  `house_age` smallint NULL DEFAULT NULL COMMENT '房龄(年)',
  `orientation` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '朝向：east/west/south/north',
  `decoration` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '装修：luxury/simple/rough',
  `near_subway` tinyint(1) NULL DEFAULT 0 COMMENT '是否近地铁',
  `has_school` tinyint(1) NULL DEFAULT 0 COMMENT '是否学区房',
  `has_parking` tinyint(1) NULL DEFAULT 1 COMMENT '是否有车位',
  `estimated_price` decimal(12, 2) NOT NULL COMMENT '估算总价(万元)',
  `avg_price_per_m2` decimal(8, 2) NOT NULL COMMENT '估算单价(元/㎡)',
  `similar_count` int NOT NULL COMMENT '参考房源数量',
  `confidence_score` decimal(3, 2) NULL DEFAULT 0.00 COMMENT '估算置信度0-1',
  `search_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '查询时间',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户IP地址（匿名化）',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '浏览器信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_session_id`(`session_id` ASC) USING BTREE,
  INDEX `idx_district`(`district` ASC) USING BTREE,
  INDEX `idx_search_time`(`search_time` ASC) USING BTREE,
  INDEX `idx_estimated_price`(`estimated_price` ASC) USING BTREE,
  INDEX `idx_area`(`area` ASC) USING BTREE,
  INDEX `idx_rooms`(`rooms` ASC) USING BTREE,
  INDEX `idx_avg_price`(`avg_price_per_m2` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户查询记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `config_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置说明',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
