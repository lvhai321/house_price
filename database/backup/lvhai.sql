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

 Date: 25/02/2026 10:51:54
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add 房源', 7, 'add_house');
INSERT INTO `auth_permission` VALUES (26, 'Can change 房源', 7, 'change_house');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 房源', 7, 'delete_house');
INSERT INTO `auth_permission` VALUES (28, 'Can view 房源', 7, 'view_house');
INSERT INTO `auth_permission` VALUES (29, 'Can add estimation history', 8, 'add_estimationhistory');
INSERT INTO `auth_permission` VALUES (30, 'Can change estimation history', 8, 'change_estimationhistory');
INSERT INTO `auth_permission` VALUES (31, 'Can delete estimation history', 8, 'delete_estimationhistory');
INSERT INTO `auth_permission` VALUES (32, 'Can view estimation history', 8, 'view_estimationhistory');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '区域统计表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of district_stats
-- ----------------------------

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (8, 'estimator', 'estimationhistory');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (7, 'spider', 'house');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2026-02-04 05:42:59.062727');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2026-02-04 05:42:59.946953');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2026-02-04 05:43:00.131001');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2026-02-04 05:43:00.138400');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2026-02-04 05:43:00.145519');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2026-02-04 05:43:00.264699');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2026-02-04 05:43:00.353451');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2026-02-04 05:43:00.390018');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2026-02-04 05:43:00.398051');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2026-02-04 05:43:00.620681');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2026-02-04 05:43:00.631891');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2026-02-04 05:43:00.643733');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2026-02-04 05:43:00.863044');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2026-02-04 05:43:00.941695');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2026-02-04 05:43:00.958185');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2026-02-04 05:43:00.967831');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2026-02-04 05:43:01.044841');
INSERT INTO `django_migrations` VALUES (18, 'estimator', '0001_initial', '2026-02-04 05:43:01.077168');
INSERT INTO `django_migrations` VALUES (19, 'sessions', '0001_initial', '2026-02-04 05:43:01.130683');
INSERT INTO `django_migrations` VALUES (20, 'spider', '0001_initial', '2026-02-04 05:43:01.168879');
INSERT INTO `django_migrations` VALUES (21, 'estimator', '0002_alter_estimationhistory_options_and_more', '2026-02-08 03:07:32.768213');
INSERT INTO `django_migrations` VALUES (22, 'spider', '0002_alter_house_crawled_at_alter_house_region_and_more', '2026-02-18 07:55:00.688206');
INSERT INTO `django_migrations` VALUES (23, 'spider', '0003_house_build_year_house_community_id_and_more', '2026-02-19 04:09:58.952827');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------

-- ----------------------------
-- Table structure for estimator_estimationhistory
-- ----------------------------
DROP TABLE IF EXISTS `estimator_estimationhistory`;
CREATE TABLE `estimator_estimationhistory`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `region` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `area` double NOT NULL,
  `layout` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `estimated_price` decimal(12, 2) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `base_price` decimal(12, 2) NULL DEFAULT NULL,
  `building_age` int NOT NULL,
  `decoration` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `floor_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `has_subway` tinyint(1) NOT NULL,
  `is_school_district` tinyint(1) NOT NULL,
  `orientation` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price_range_high` decimal(12, 2) NULL DEFAULT NULL,
  `price_range_low` decimal(12, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of estimator_estimationhistory
-- ----------------------------
INSERT INTO `estimator_estimationhistory` VALUES (1, 'haidian', 115, '2室1厅', 5947395.97, '2026-02-08 03:08:10.216046', 4653019.58, 5, 'exquisite', 'high', 1, 1, 'south', 6542135.57, 5352656.37);
INSERT INTO `estimator_estimationhistory` VALUES (2, '朝阳', 90, '2室1厅', 5079079.69, '2026-02-14 04:54:44.432380', 4500000.00, 5, 'simple', 'mid', 1, 0, 'south', 5333033.67, 4825125.70);
INSERT INTO `estimator_estimationhistory` VALUES (3, '朝阳', 90, '2室1厅', 5562801.56, '2026-02-14 04:54:52.435891', 4500000.00, 5, 'simple', 'mid', 1, 1, 'south', 5840941.64, 5284661.48);
INSERT INTO `estimator_estimationhistory` VALUES (4, '朝阳', 90, '2室1厅', 5079079.69, '2026-02-14 04:54:54.314855', 4500000.00, 5, 'simple', 'mid', 1, 0, 'south', 5333033.67, 4825125.70);
INSERT INTO `estimator_estimationhistory` VALUES (5, '西城', 90, '2室2厅', 6119081.72, '2026-02-14 05:10:30.734309', 4500000.00, 5, 'exquisite', 'mid', 0, 1, 'south', 6425035.80, 5813127.63);
INSERT INTO `estimator_estimationhistory` VALUES (6, 'wuhan', 90, '2室2厅', 4504500.00, '2026-02-18 08:44:54.972437', 4500000.00, 5, 'simple', 'mid', 0, 0, 'south', 4729725.00, 4279275.00);
INSERT INTO `estimator_estimationhistory` VALUES (7, 'xiaogan', 90, '2室2厅', 4504500.00, '2026-02-18 08:45:06.527131', 4500000.00, 5, 'simple', 'mid', 0, 0, 'south', 4729725.00, 4279275.00);
INSERT INTO `estimator_estimationhistory` VALUES (8, 'xiaogan', 90, '2室1厅', 4504500.00, '2026-02-18 08:45:10.603175', 4500000.00, 5, 'simple', 'mid', 0, 0, 'south', 4729725.00, 4279275.00);
INSERT INTO `estimator_estimationhistory` VALUES (9, 'xiaogan', 90, '2室1厅', 4504500.00, '2026-02-18 08:47:32.389825', 4500000.00, 5, 'simple', 'mid', 0, 0, 'south', 4729725.00, 4279275.00);
INSERT INTO `estimator_estimationhistory` VALUES (10, 'xiaogan', 90, '2室1厅', 4469850.00, '2026-02-18 08:47:39.131215', 4500000.00, 5, 'exquisite', 'low', 0, 0, 'east', 4693342.50, 4246357.50);
INSERT INTO `estimator_estimationhistory` VALUES (11, '武汉', 90, '2室2厅', 4211707.50, '2026-02-18 11:07:51.186495', 4500000.00, 5, 'rough', 'mid', 0, 0, 'south', 4422292.88, 4001122.13);
INSERT INTO `estimator_estimationhistory` VALUES (12, '武汉', 90, '2室2厅', 4211707.50, '2026-02-18 11:11:35.763547', 4500000.00, 5, 'rough', 'mid', 0, 0, 'south', 4422292.88, 4001122.13);
INSERT INTO `estimator_estimationhistory` VALUES (13, '武汉', 90, '2室2厅', 4043239.20, '2026-02-18 11:11:38.290992', 4500000.00, 5, 'rough', 'low', 0, 0, 'south', 4245401.16, 3841077.24);
INSERT INTO `estimator_estimationhistory` VALUES (14, '武汉', 90, '1室1厅', 4043239.20, '2026-02-18 11:20:17.989438', 4500000.00, 5, 'rough', 'low', 0, 0, 'south', 4245401.16, 3841077.24);
INSERT INTO `estimator_estimationhistory` VALUES (15, '武汉', 90, '1室1厅', 4380175.80, '2026-02-18 11:20:21.746885', 4500000.00, 5, 'rough', 'high', 0, 0, 'south', 4599184.59, 4161167.01);
INSERT INTO `estimator_estimationhistory` VALUES (16, '武汉', 90, '1室1厅', 5201349.26, '2026-02-18 11:20:26.428895', 4500000.00, 5, 'rough', 'high', 1, 1, 'south', 5461416.72, 4941281.80);
INSERT INTO `estimator_estimationhistory` VALUES (17, '武汉', 80, '1室1厅', 3455760.00, '2026-02-19 02:19:56.096250', 4000000.00, 5, 'rough', 'low', 0, 0, 'east', 3628548.00, 3282972.00);
INSERT INTO `estimator_estimationhistory` VALUES (18, '武汉', 160, '3室1厅', 8726695.20, '2026-02-19 02:44:16.227703', 8000000.00, 1, 'exquisite', 'low', 1, 0, 'west', 9163029.96, 8290360.44);
INSERT INTO `estimator_estimationhistory` VALUES (19, 'wuhan', 150, '3室1厅', 9562432.63, '2026-02-19 02:49:59.468139', 7500000.00, 2, 'exquisite', 'high', 1, 1, 'north', 10040554.26, 9084311.00);
INSERT INTO `estimator_estimationhistory` VALUES (20, 'wuhan', 51, '3室1厅', 984987.14, '2026-02-19 03:01:26.777188', 816000.00, 2, 'exquisite', 'low', 1, 1, 'east', 1034236.50, 935737.79);
INSERT INTO `estimator_estimationhistory` VALUES (21, 'wuhan', 51, '3室1厅', 984987.14, '2026-02-19 03:09:21.507387', 816000.00, 2, 'exquisite', 'low', 1, 1, 'east', 1034236.50, 935737.79);
INSERT INTO `estimator_estimationhistory` VALUES (22, '上海', 90, '1室1厅', 4966336.49, '2026-02-19 03:11:56.004766', 5736124.38, 10, 'simple', 'low', 0, 0, 'north', 5214653.32, 4718019.67);
INSERT INTO `estimator_estimationhistory` VALUES (23, 'wuhan', 90, '2室2厅', 1821505.64, '2026-02-20 05:16:40.209481', 1440000.00, 1, 'exquisite', 'low', 1, 1, 'south', 1912580.92, 1730430.35);
INSERT INTO `estimator_estimationhistory` VALUES (24, 'wuhan', 90, '2室2厅', 1821505.64, '2026-02-20 05:24:19.790491', 1440000.00, 1, 'exquisite', 'low', 1, 1, 'south', 1912580.92, 1730430.35);
INSERT INTO `estimator_estimationhistory` VALUES (25, 'wuhan', 90, '2室2厅', 1821505.64, '2026-02-20 05:24:32.648989', 1440000.00, 1, 'exquisite', 'low', 1, 1, 'south', 1912580.92, 1730430.35);
INSERT INTO `estimator_estimationhistory` VALUES (26, 'wuhan', 90, '2室2厅', 1821505.64, '2026-02-20 05:24:38.291082', 1440000.00, 1, 'exquisite', 'low', 1, 1, 'south', 1912580.92, 1730430.35);
INSERT INTO `estimator_estimationhistory` VALUES (27, 'wuhan', 90, '2室2厅', 1545390.00, '2026-02-21 11:43:06.914244', 1440000.00, 5, 'simple', 'mid', 0, 1, 'east', 1622659.50, 1468120.50);
INSERT INTO `estimator_estimationhistory` VALUES (28, 'wuhan', 90, '3室1厅', 1600415.16, '2026-02-21 11:49:04.497395', 1440000.00, 5, 'rough', 'mid', 1, 1, 'south', 1680435.91, 1520394.40);
INSERT INTO `estimator_estimationhistory` VALUES (29, 'wuhan', 90, '2室1厅', 1440373.64, '2026-02-21 12:16:38.178285', 1440000.00, 5, 'rough', 'low', 1, 1, 'north', 1512392.32, 1368354.96);
INSERT INTO `estimator_estimationhistory` VALUES (30, 'wuhan', 90, '2室1厅', 1440373.64, '2026-02-21 12:16:39.369276', 1440000.00, 5, 'rough', 'low', 1, 1, 'north', 1512392.32, 1368354.96);
INSERT INTO `estimator_estimationhistory` VALUES (31, 'jingzhou', 90, '2室1厅', 2882880.00, '2026-02-23 02:51:47.917540', 2880000.00, 5, 'simple', 'mid', 0, 0, 'south', 3027024.00, 2738736.00);
INSERT INTO `estimator_estimationhistory` VALUES (32, 'jingzhou', 90, '2室1厅', 2882880.00, '2026-02-23 03:35:10.871471', 2880000.00, 5, 'simple', 'mid', 0, 0, 'south', 3027024.00, 2738736.00);
INSERT INTO `estimator_estimationhistory` VALUES (33, 'jingzhou', 90, '2室1厅', 3070267.20, '2026-02-23 03:35:55.710810', 2880000.00, 5, 'simple', 'mid', 1, 0, 'south', 3223780.56, 2916753.84);
INSERT INTO `estimator_estimationhistory` VALUES (34, 'jingzhou', 90, '2室1厅', 11168008.59, '2026-02-23 03:44:07.536168', 10475917.12, 5, 'simple', 'mid', 1, 0, 'south', 11726409.02, 10609608.16);
INSERT INTO `estimator_estimationhistory` VALUES (35, 'jingzhou', 90, '2室1厅', 12452329.58, '2026-02-23 03:44:17.113006', 10475917.12, 5, 'simple', 'mid', 1, 1, 'south', 13074946.05, 11829713.10);
INSERT INTO `estimator_estimationhistory` VALUES (36, '武汉', 90, '2室1厅', 957817.90, '2026-02-23 12:50:14.253619', 898461.07, 5, 'simple', 'mid', 1, 0, 'south', 1005708.80, 909927.01);
INSERT INTO `estimator_estimationhistory` VALUES (37, '江汉', 90, '2室1厅', 1346443.00, '2026-02-23 12:50:19.963256', 1263002.73, 5, 'simple', 'mid', 1, 0, 'south', 1413765.15, 1279120.85);
INSERT INTO `estimator_estimationhistory` VALUES (38, '咸宁', 90, '2室1厅', 1247296.05, '2026-02-23 12:50:58.383206', 1170000.00, 5, 'simple', 'mid', 1, 0, 'south', 1309660.85, 1184931.25);
INSERT INTO `estimator_estimationhistory` VALUES (39, '咸宁', 90, '2室1厅', 326420.25, '2026-02-23 12:51:31.714372', 306191.70, 5, 'simple', 'mid', 1, 0, 'south', 342741.27, 310099.24);
INSERT INTO `estimator_estimationhistory` VALUES (40, '咸宁', 90, '2室1厅', 326420.25, '2026-02-23 12:52:52.709892', 306191.70, 5, 'simple', 'mid', 1, 0, 'south', 342741.27, 310099.24);
INSERT INTO `estimator_estimationhistory` VALUES (41, '荆州', 90, '2室1厅', 3070267.20, '2026-02-23 12:53:40.630353', 2880000.00, 5, 'simple', 'mid', 1, 0, 'south', 3223780.56, 2916753.84);
INSERT INTO `estimator_estimationhistory` VALUES (42, '荆州', 90, '2室1厅', 419634.42, '2026-02-23 12:54:23.352493', 393629.30, 5, 'simple', 'mid', 1, 0, 'south', 440616.14, 398652.70);
INSERT INTO `estimator_estimationhistory` VALUES (43, '周口', 90, '2室1厅', 959458.50, '2026-02-23 12:58:18.153259', 900000.00, 5, 'simple', 'mid', 1, 0, 'south', 1007431.43, 911485.57);
INSERT INTO `estimator_estimationhistory` VALUES (44, '荆州', 90, '2室1厅', 419634.42, '2026-02-23 12:58:44.540964', 393629.30, 5, 'simple', 'mid', 1, 0, 'south', 440616.14, 398652.70);
INSERT INTO `estimator_estimationhistory` VALUES (45, '河南', 90, '2室1厅', 959458.50, '2026-02-23 12:58:54.604519', 900000.00, 5, 'simple', 'mid', 1, 0, 'south', 1007431.43, 911485.57);
INSERT INTO `estimator_estimationhistory` VALUES (46, '周口', 90, '2室1厅', 959458.50, '2026-02-23 12:58:58.400037', 900000.00, 5, 'simple', 'mid', 1, 0, 'south', 1007431.43, 911485.57);
INSERT INTO `estimator_estimationhistory` VALUES (47, '周口', 90, '2室1厅', 400498.70, '2026-02-23 12:59:39.679563', 375679.44, 5, 'simple', 'mid', 1, 0, 'south', 420523.64, 380473.77);
INSERT INTO `estimator_estimationhistory` VALUES (48, '大同', 90, '1室1厅', 426485.83, '2026-02-25 02:31:41.370330', 416725.13, 5, 'simple', 'low', 1, 0, 'south', 447810.13, 405161.54);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '房源数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of house_data
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户查询记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of search_records
-- ----------------------------

-- ----------------------------
-- Table structure for spider_house
-- ----------------------------
DROP TABLE IF EXISTS `spider_house`;
CREATE TABLE `spider_house`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `region` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `area` double NOT NULL,
  `layout` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_price` decimal(10, 2) NOT NULL,
  `unit_price` decimal(10, 2) NOT NULL,
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `crawled_at` datetime(6) NOT NULL,
  `build_year` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `community_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `community_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `floor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `follow_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `orientation` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `url`(`url` ASC) USING BTREE,
  INDEX `spider_house_crawled_at_9688e753`(`crawled_at` ASC) USING BTREE,
  INDEX `spider_house_region_614baa7f`(`region` ASC) USING BTREE,
  INDEX `spider_house_source_2fbe16a0`(`source` ASC) USING BTREE,
  INDEX `spider_house_community_id_dad2fd1b`(`community_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2280 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of spider_house
-- ----------------------------
INSERT INTO `spider_house` VALUES (1327, '时代豪苑 3室2厅 153.21平', 'wuhan-三阳路', 153.21, '3室2厅', 328.00, 21408.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/8_1007257191.htm', '2026-02-23 11:37:01.144898', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1328, '保利新武昌 2室2厅 77.12平', '武汉-白沙洲', 77.12, '2室2厅', 82.00, 10632.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369372.htm', '2026-02-23 11:37:01.154365', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1329, '保利新武昌 3室2厅 96.47平', '武汉-白沙洲', 96.47, '3室2厅', 103.00, 10676.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369316.htm', '2026-02-23 11:37:01.161518', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1330, '保利上城东区 3室2厅 100.57平', 'wuhan-白沙洲-保利上城东区', 100.57, '3室2厅', 87.00, 8650.69, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374342.htm', '2026-02-23 11:37:01.168728', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1331, '保利上城西区 3室2厅 108.06平', '武汉-白沙洲', 108.06, '3室2厅', 103.00, 9531.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325885.htm', '2026-02-23 11:37:01.174847', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1332, '保利新武昌 3室2厅 107.91平', '武汉-白沙洲', 107.91, '3室2厅', 116.00, 10749.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369371.htm', '2026-02-23 11:37:01.180496', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1333, '东原启城 3室2厅 97.21平', '武汉-白沙洲', 97.21, '3室2厅', 81.00, 8332.48, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364154.htm', '2026-02-23 11:37:01.185975', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1334, '保利上城西区 4室2厅 150.28平', '武汉-白沙洲', 150.28, '4室2厅', 143.00, 9515.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325866.htm', '2026-02-23 11:37:01.191618', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1335, '保利新武昌 3室2厅 100.83平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 100.83, '3室2厅', 108.00, 10711.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369336.htm', '2026-02-23 11:37:01.196485', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1336, '保利上城东区 3室2厅 114.36平', '武汉-白沙洲', 114.36, '3室2厅', 99.00, 8656.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374338.htm', '2026-02-23 11:37:01.204074', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1337, '保利新武昌 3室2厅 97.01平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 97.01, '3室2厅', 104.00, 10720.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341457.htm', '2026-02-23 11:37:01.209113', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1338, '保利新武昌 3室2厅 123.96平', '武汉-白沙洲', 123.96, '3室2厅', 132.00, 10648.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369332.htm', '2026-02-23 11:37:01.215579', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1339, '保利上城东区 3室2厅 86.67平', 'wuhan-白沙洲-保利上城东区', 86.67, '3室2厅', 76.00, 8768.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202337614.htm', '2026-02-23 11:37:01.220626', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1340, '保利新武昌 3室2厅 123.96平', '武汉-白沙洲', 123.96, '3室2厅', 137.00, 11051.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294885.htm', '2026-02-23 11:37:01.226167', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1341, '保利新武昌 3室2厅 94.55平', '武汉-白沙洲', 94.55, '3室2厅', 101.00, 10682.18, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369593.htm', '2026-02-23 11:37:01.231206', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1342, '保利上城东区 3室2厅 91.0平', '武汉-白沙洲', 91, '3室2厅', 79.00, 8681.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374360.htm', '2026-02-23 11:37:01.237364', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1343, '保利新武昌 3室2厅 96.41平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 96.41, '3室2厅', 103.00, 10683.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368538.htm', '2026-02-23 11:37:01.243223', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1344, '保利新武昌 3室2厅 94.88平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 94.88, '3室2厅', 104.90, 11056.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288263.htm', '2026-02-23 11:37:01.249886', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1345, '复地悦城二期东区 4室2厅 136.41平', 'wuhan-白沙洲-烽胜路', 136.41, '4室2厅', 130.00, 9530.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202310649.htm', '2026-02-23 11:37:01.256210', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1346, '中建铂公馆 3室2厅 135.46平', '武汉-白沙洲', 135.46, '3室2厅', 122.50, 9043.26, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363043.htm', '2026-02-23 11:37:01.261911', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1347, '喜瑞都 3室2厅 103.12平', '武汉-白沙洲', 103.12, '3室2厅', 87.00, 8436.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357270.htm', '2026-02-23 11:37:01.267453', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1348, '东原启城 3室2厅 107.27平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 107.27, '3室2厅', 89.00, 8296.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364168.htm', '2026-02-23 11:37:01.272508', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1349, '保利上城东区 3室2厅 113.09平', 'wuhan-白沙洲-保利上城东区', 113.09, '3室2厅', 98.00, 8665.66, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374336.htm', '2026-02-23 11:37:01.278743', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1350, '保利新武昌 3室2厅 100.48平', '武汉-白沙洲', 100.48, '3室2厅', 108.00, 10748.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369292.htm', '2026-02-23 11:37:01.283252', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1351, '保利新武昌 3室2厅 116.05平', '武汉-白沙洲', 116.05, '3室2厅', 124.00, 10685.05, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369324.htm', '2026-02-23 11:37:01.288550', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1352, '喜瑞都 3室1厅 108.0平', '武汉-白沙洲', 108, '3室1厅', 92.00, 8518.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357244.htm', '2026-02-23 11:37:01.293779', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1353, '保利新武昌 3室2厅 123.55平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 123.55, '3室2厅', 132.00, 10683.93, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368966.htm', '2026-02-23 11:37:01.299057', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1354, '清能清江锦城 2室2厅 86.5平', 'wuhan-白沙洲-清能清江锦城', 86.5, '2室2厅', 75.00, 8670.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202362130.htm', '2026-02-23 11:37:01.305156', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1355, '保利上城东区 3室2厅 84.67平', '武汉-白沙洲', 84.67, '3室2厅', 73.00, 8621.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374346.htm', '2026-02-23 11:37:01.308899', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1356, '清能清江锦城 2室2厅 80.08平', 'wuhan-白沙洲-清能清江锦城', 80.08, '2室2厅', 69.50, 8678.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333956.htm', '2026-02-23 11:37:01.314798', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1357, '万科云城 3室2厅 118.21平', 'wuhan-武泰闸烽火-万科云城', 118.21, '3室2厅', 113.00, 9559.26, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355723.htm', '2026-02-23 11:37:01.319369', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1358, '保利新武昌 3室2厅 100.88平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 100.88, '3室2厅', 109.00, 10804.92, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202337673.htm', '2026-02-23 11:37:01.325071', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1359, '保利上城西区 3室2厅 118.98平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 118.98, '3室2厅', 118.00, 9917.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331910.htm', '2026-02-23 11:37:01.330172', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1360, '东原启城 3室2厅 125.17平', '武汉-白沙洲', 125.17, '3室2厅', 104.00, 8308.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364140.htm', '2026-02-23 11:37:01.335281', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1361, '复地悦城二期东区 4室2厅 136.41平', 'wuhan-白沙洲-烽胜路', 136.41, '4室2厅', 136.00, 9969.94, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202174693.htm', '2026-02-23 11:37:01.341397', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1362, '佳兆业金域天下 3室2厅 89.88平', '武汉-白沙洲', 89.88, '3室2厅', 76.00, 8455.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353053.htm', '2026-02-23 11:37:01.345929', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1363, '保利新武昌 2室2厅 77.14平', '武汉-白沙洲', 77.14, '2室2厅', 82.00, 10630.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369317.htm', '2026-02-23 11:37:01.353112', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1364, '保利上城东区 3室2厅 108.37平', 'wuhan-白沙洲-保利上城东区', 108.37, '3室2厅', 94.00, 8673.99, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202371994.htm', '2026-02-23 11:37:01.358904', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1365, '保利上城东区 3室2厅 95.82平', 'wuhan-白沙洲-保利上城东区', 95.82, '3室2厅', 82.00, 8557.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375042.htm', '2026-02-23 11:37:01.364063', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1366, '喜瑞都 3室2厅 108.52平', 'wuhan-白沙洲-白沙洲大道往白沙三路前行300米', 108.52, '3室2厅', 91.00, 8385.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357247.htm', '2026-02-23 11:37:01.368796', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1367, '保利新武昌 3室2厅 96.47平', '武汉-白沙洲', 96.47, '3室2厅', 103.00, 10676.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369328.htm', '2026-02-23 11:37:01.374447', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1368, '东原启城 3室2厅 112.68平', '武汉-白沙洲', 112.68, '3室2厅', 93.00, 8253.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364163.htm', '2026-02-23 11:37:01.379824', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1369, '保利上城东区 3室2厅 97.19平', 'wuhan-白沙洲-保利上城东区', 97.19, '3室2厅', 85.00, 8745.76, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202337581.htm', '2026-02-23 11:37:01.384876', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1370, '保利上城西区 3室2厅 88.29平', '武汉-白沙洲', 88.29, '3室2厅', 84.00, 9514.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325935.htm', '2026-02-23 11:37:01.390422', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1371, '保利新武昌 3室2厅 102.77平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 102.77, '3室2厅', 109.00, 10606.21, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375070.htm', '2026-02-23 11:37:01.395986', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1372, '复地悦城二期东区 4室2厅 136.41平', 'wuhan-白沙洲-烽胜路', 136.41, '4室2厅', 131.00, 9603.40, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288342.htm', '2026-02-23 11:37:01.400026', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1373, '保利上城西区 3室2厅 88.06平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 88.06, '3室2厅', 88.00, 9993.19, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331907.htm', '2026-02-23 11:37:01.406000', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1374, '保利新武昌 3室2厅 123.97平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 123.97, '3室2厅', 132.00, 10647.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202292119.htm', '2026-02-23 11:37:01.412040', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1375, '东原启城 3室2厅 97.5平', '武汉-白沙洲', 97.5, '3室2厅', 82.00, 8410.26, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364146.htm', '2026-02-23 11:37:01.416633', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1376, '保利上城东区 3室1厅 87.6平', 'wuhan-白沙洲-保利上城东区', 87.6, '3室1厅', 77.00, 8789.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202351854.htm', '2026-02-23 11:37:01.422548', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1377, '复地悦城二期东区 3室2厅 101.61平', 'wuhan-白沙洲-烽胜路', 101.61, '3室2厅', 95.00, 9349.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202362110.htm', '2026-02-23 11:37:01.427614', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1378, '保利新武昌 3室2厅 129.78平', '武汉-白沙洲', 129.78, '3室2厅', 138.00, 10633.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369585.htm', '2026-02-23 11:37:01.432214', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1379, '保利上城西区 2室2厅 79.09平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 79.09, '2室2厅', 79.00, 9988.62, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202351870.htm', '2026-02-23 11:37:01.438258', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1380, '复地悦城二期东区 3室2厅 88.22平', 'wuhan-白沙洲-烽胜路', 88.22, '3室2厅', 79.00, 8954.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331682.htm', '2026-02-23 11:37:01.444898', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1381, '保利新武昌 3室2厅 101.54平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 101.54, '3室2厅', 112.90, 11118.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202176805.htm', '2026-02-23 11:37:01.449975', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1382, '东原启城 3室2厅 119.12平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 119.12, '3室2厅', 103.00, 8646.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333505.htm', '2026-02-23 11:37:01.456344', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1383, '保利上城东区 3室2厅 98.19平', 'wuhan-白沙洲-保利上城东区', 98.19, '3室2厅', 85.00, 8656.69, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374385.htm', '2026-02-23 11:37:01.462341', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1384, '复地悦城二期东区 3室2厅 88.22平', 'wuhan-白沙洲-烽胜路', 88.22, '3室2厅', 88.00, 9975.06, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202174685.htm', '2026-02-23 11:37:01.468882', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1385, '保利上城东区 3室2厅 84.02平', 'wuhan-白沙洲-保利上城东区', 84.02, '3室2厅', 75.00, 8926.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331715.htm', '2026-02-23 11:37:01.473264', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1386, '保利上城西区 3室2厅 95.77平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 95.77, '3室2厅', 93.00, 9710.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375021.htm', '2026-02-23 11:37:01.479520', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1387, '保利新武昌 3室2厅 123.44平', '武汉-白沙洲', 123.44, '3室2厅', 133.00, 10774.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369594.htm', '2026-02-23 11:37:01.494898', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1388, '喜瑞都 3室2厅 102.84平', '武汉-白沙洲', 102.84, '3室2厅', 86.00, 8362.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357274.htm', '2026-02-23 11:37:01.507096', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1389, '保利上城东区 3室2厅 125.62平', 'wuhan-白沙洲-保利上城东区', 125.62, '3室2厅', 110.00, 8756.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331759.htm', '2026-02-23 11:37:01.520159', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1390, '东原启城 3室2厅 113.08平', '武汉-白沙洲', 113.08, '3室2厅', 94.00, 8312.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364149.htm', '2026-02-23 11:37:01.531349', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1391, '保利新武昌 2室2厅 77.14平', '武汉-白沙洲', 77.14, '2室2厅', 82.00, 10630.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369376.htm', '2026-02-23 11:37:01.541009', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1392, '佳兆业金域天下 3室1厅 89.88平', '武汉-白沙洲', 89.88, '3室1厅', 76.00, 8455.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353027.htm', '2026-02-23 11:37:01.551256', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1393, '保利新武昌 3室2厅 129.78平', '武汉-白沙洲', 129.78, '3室2厅', 139.00, 10710.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369589.htm', '2026-02-23 11:37:01.562652', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1394, '保利上城西区 3室2厅 95.77平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 95.77, '3室2厅', 92.00, 9606.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325886.htm', '2026-02-23 11:37:01.570269', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1395, '保利上城东区 3室1厅 81.82平', '武汉-白沙洲', 81.82, '3室1厅', 71.00, 8677.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374348.htm', '2026-02-23 11:37:01.574808', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1396, '保利上城东区 3室2厅 113.09平', 'wuhan-白沙洲-保利上城东区', 113.09, '3室2厅', 99.00, 8754.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331738.htm', '2026-02-23 11:37:01.579839', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1397, '保利上城东区 3室2厅 98.43平', 'wuhan-白沙洲-保利上城东区', 98.43, '3室2厅', 85.00, 8635.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202362113.htm', '2026-02-23 11:37:01.584975', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1398, '东原启城 3室2厅 126.4平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 126.4, '3室2厅', 108.50, 8583.86, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333531.htm', '2026-02-23 11:37:01.589507', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1399, '东原启城 3室2厅 111.71平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 111.71, '3室2厅', 93.00, 8325.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364382.htm', '2026-02-23 11:37:01.594555', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1400, '保利上城西区 4室2厅 152.13平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 152.13, '4室2厅', 145.00, 9531.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325944.htm', '2026-02-23 11:37:01.599650', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1401, '保利新武昌 3室2厅 102.77平', '武汉-白沙洲', 102.77, '3室2厅', 111.00, 10800.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202292062.htm', '2026-02-23 11:37:01.605695', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1402, '保利新武昌 3室2厅 129.8平', '武汉-白沙洲', 129.8, '3室2厅', 138.00, 10631.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369322.htm', '2026-02-23 11:37:01.609743', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1403, '喜瑞都 3室2厅 115.79平', '武汉-白沙洲', 115.79, '3室2厅', 99.00, 8549.96, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357216.htm', '2026-02-23 11:37:01.615271', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1404, '保利上城西区 3室2厅 131.4平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 131.4, '3室2厅', 127.00, 9665.14, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325889.htm', '2026-02-23 11:37:01.619911', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1405, '东原启城 3室2厅 97.09平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 97.09, '3室2厅', 81.00, 8342.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364186.htm', '2026-02-23 11:37:01.626182', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1406, '清能清江锦城 3室2厅 131.49平', 'wuhan-白沙洲-清能清江锦城', 131.49, '3室2厅', 109.00, 8289.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202192589.htm', '2026-02-23 11:37:01.630867', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1407, '清能清江锦城 3室1厅 130.27平', 'wuhan-白沙洲-清能清江锦城', 130.27, '3室1厅', 113.00, 8674.29, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333941.htm', '2026-02-23 11:37:01.635976', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1408, '保利上城西区 3室2厅 102.98平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 102.98, '3室2厅', 98.00, 9516.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375020.htm', '2026-02-23 11:37:01.641535', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1409, '保利上城西区 3室1厅 88.06平', '武汉-白沙洲', 88.06, '3室1厅', 84.00, 9538.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325900.htm', '2026-02-23 11:37:01.647086', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1410, '东原启城 3室2厅 111.71平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 111.71, '3室2厅', 93.00, 8325.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364138.htm', '2026-02-23 11:37:01.651650', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1411, '保利新武昌 3室2厅 97.18平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 97.18, '3室2厅', 104.00, 10701.79, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369301.htm', '2026-02-23 11:37:01.657226', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1412, '复地悦城二期东区 3室2厅 101.31平', '武汉-白沙洲', 101.31, '3室2厅', 102.00, 10068.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202174695.htm', '2026-02-23 11:37:01.662389', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1413, '保利新武昌 3室2厅 126.4平', '武汉-白沙洲', 126.4, '3室2厅', 135.00, 10680.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369278.htm', '2026-02-23 11:37:01.667425', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1414, '清能清江锦城 2室2厅 86.34平', '武汉-白沙洲', 86.34, '2室2厅', 72.00, 8339.12, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366408.htm', '2026-02-23 11:37:01.672901', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1415, '复地悦城二期东区 2室1厅 78.45平', 'wuhan-白沙洲-烽胜路', 78.45, '2室1厅', 71.00, 9050.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202351850.htm', '2026-02-23 11:37:01.678032', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1416, '喜瑞都 3室1厅 118.14平', 'wuhan-白沙洲-白沙洲大道往白沙三路前行300米', 118.14, '3室1厅', 99.00, 8379.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357222.htm', '2026-02-23 11:37:01.683059', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1417, '保利新武昌 3室2厅 126.4平', '武汉-白沙洲', 126.4, '3室2厅', 140.00, 11075.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202292030.htm', '2026-02-23 11:37:01.686605', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1418, '东原启城 3室2厅 112.52平', '武汉-白沙洲', 112.52, '3室2厅', 93.00, 8265.20, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364179.htm', '2026-02-23 11:37:01.692195', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1419, '万科云城 4室2厅 142.66平', 'wuhan-武泰闸烽火-万科云城', 142.66, '4室2厅', 132.00, 9252.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355814.htm', '2026-02-23 11:37:01.697737', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1420, '世茂云锦樱海园 3室2厅 104.23平', '武汉-白沙洲', 104.23, '3室2厅', 87.00, 8346.93, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372933.htm', '2026-02-23 11:37:01.703320', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1421, '喜瑞都 3室2厅 118.23平', '武汉-白沙洲', 118.23, '3室2厅', 99.00, 8373.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357240.htm', '2026-02-23 11:37:01.708917', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1422, '佳兆业金域天下 3室2厅 89.57平', 'wuhan-白沙洲-白沙洲新城烽胜路36号(工商学院旁)', 89.57, '3室2厅', 76.00, 8484.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353023.htm', '2026-02-23 11:37:01.713972', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1423, '保利上城西区 4室2厅 150.28平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 150.28, '4室2厅', 150.00, 9981.37, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202338808.htm', '2026-02-23 11:37:01.719516', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1424, '东原启城 3室2厅 98.36平', '武汉-白沙洲', 98.36, '3室2厅', 82.00, 8336.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364166.htm', '2026-02-23 11:37:01.724051', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1425, '保利上城西区 4室2厅 152.13平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 152.13, '4室2厅', 148.00, 9728.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325942.htm', '2026-02-23 11:37:01.729599', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1426, '保利新武昌 3室2厅 100.83平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 100.83, '3室2厅', 109.00, 10810.27, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331788.htm', '2026-02-23 11:37:01.734625', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1427, '保利新武昌 3室2厅 123.44平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 123.44, '3室2厅', 137.00, 11098.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202176778.htm', '2026-02-23 11:37:01.739702', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1428, '保利上城东区 3室2厅 87.6平', 'wuhan-白沙洲-保利上城东区', 87.6, '3室2厅', 76.00, 8675.80, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374344.htm', '2026-02-23 11:37:01.743221', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1429, '保利新武昌 3室2厅 129.78平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 129.78, '3室2厅', 140.00, 10787.49, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341417.htm', '2026-02-23 11:37:01.749809', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1430, '喜瑞都 3室2厅 102.84平', 'wuhan-白沙洲-白沙洲大道往白沙三路前行300米', 102.84, '3室2厅', 86.00, 8362.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357291.htm', '2026-02-23 11:37:01.754401', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1431, '复地悦城二期东区 3室2厅 94.32平', '武汉-白沙洲', 94.32, '3室2厅', 96.00, 10178.12, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202174735.htm', '2026-02-23 11:37:01.759432', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1432, '保利上城东区 3室2厅 111.63平', 'wuhan-白沙洲-保利上城东区', 111.63, '3室2厅', 100.00, 8958.17, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202351894.htm', '2026-02-23 11:37:01.764492', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1433, '保利新武昌 3室2厅 102.77平', '武汉-白沙洲', 102.77, '3室2厅', 110.00, 10703.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202292036.htm', '2026-02-23 11:37:01.770656', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1434, '保利新武昌 3室2厅 100.48平', '武汉-白沙洲', 100.48, '3室2厅', 107.00, 10648.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369285.htm', '2026-02-23 11:37:01.776198', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1435, '保利新武昌 3室2厅 116.71平', '武汉-白沙洲', 116.71, '3室2厅', 124.00, 10624.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369379.htm', '2026-02-23 11:37:01.781840', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1436, '清能清江锦城 3室2厅 92.4平', 'wuhan-白沙洲-清能清江锦城', 92.4, '3室2厅', 79.00, 8549.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202362184.htm', '2026-02-23 11:37:01.787495', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1437, '东原启城 3室2厅 108.72平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 108.72, '3室2厅', 91.00, 8370.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202362128.htm', '2026-02-23 11:37:01.793027', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1438, '清能清江锦城 2室2厅 90.27平', '武汉-白沙洲', 90.27, '2室2厅', 75.00, 8308.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379923.htm', '2026-02-23 11:37:01.798066', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1439, '复地悦城二期东区 2室2厅 76.99平', 'wuhan-白沙洲-烽胜路', 76.99, '2室2厅', 69.00, 8962.20, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331677.htm', '2026-02-23 11:37:01.804116', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1440, '保利上城西区 3室2厅 117.6平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 117.6, '3室2厅', 112.00, 9523.81, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325882.htm', '2026-02-23 11:37:01.809690', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1441, '世茂云锦瑰海园 3室2厅 108.61平', 'wuhan-武泰闸烽火-青菱中路', 108.61, '3室2厅', 89.00, 8194.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294419.htm', '2026-02-23 11:37:01.815757', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1442, '保利上城西区 3室2厅 95.77平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 95.77, '3室2厅', 92.00, 9606.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325893.htm', '2026-02-23 11:37:01.820787', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1443, '保利上城西区 3室2厅 97.23平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 97.23, '3室2厅', 93.00, 9564.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325884.htm', '2026-02-23 11:37:01.826320', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1444, '清能清江锦城 2室2厅 86.5平', 'wuhan-白沙洲-清能清江锦城', 86.5, '2室2厅', 72.00, 8323.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366411.htm', '2026-02-23 11:37:01.832056', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1445, '保利上城东区 3室2厅 87.6平', 'wuhan-白沙洲-保利上城东区', 87.6, '3室2厅', 77.00, 8789.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331767.htm', '2026-02-23 11:37:01.837646', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1446, '保利新武昌 3室2厅 123.96平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 123.96, '3室2厅', 134.00, 10809.94, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341428.htm', '2026-02-23 11:37:01.842681', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1447, '保利上城西区 3室1厅 97.23平', '武汉-白沙洲', 97.23, '3室1厅', 97.00, 9976.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331149.htm', '2026-02-23 11:37:01.848329', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1448, '东原启城 3室2厅 125.62平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 125.62, '3室2厅', 108.00, 8597.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341600.htm', '2026-02-23 11:37:01.853960', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1449, '保利新武昌 3室2厅 102.52平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 102.52, '3室2厅', 110.00, 10729.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368972.htm', '2026-02-23 11:37:01.858541', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1450, '清能清江锦城 3室2厅 112.15平', '武汉-白沙洲', 112.15, '3室2厅', 92.90, 8283.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202192580.htm', '2026-02-23 11:37:01.863720', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1451, '万科云城 3室2厅 118.26平', 'wuhan-武泰闸烽火-万科云城', 118.26, '3室2厅', 112.00, 9470.66, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355732.htm', '2026-02-23 11:37:01.870019', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1452, '保利新武昌 3室2厅 106.66平', '武汉-白沙洲', 106.66, '3室2厅', 114.00, 10688.17, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369596.htm', '2026-02-23 11:37:01.876063', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1453, '保利新武昌 3室2厅 123.45平', '武汉-白沙洲', 123.45, '3室2厅', 132.00, 10692.59, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369591.htm', '2026-02-23 11:37:01.882105', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1454, '清能清江锦城 2室2厅 92.64平', 'wuhan-白沙洲-清能清江锦城', 92.64, '2室2厅', 79.00, 8527.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363599.htm', '2026-02-23 11:37:01.886144', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1455, '复地悦城二期东区 3室2厅 86.73平', 'wuhan-白沙洲-烽胜路', 86.73, '3室2厅', 78.00, 8993.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331691.htm', '2026-02-23 11:37:01.891416', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1456, '清能清江锦城 3室2厅 111.05平', '武汉-白沙洲', 111.05, '3室2厅', 92.00, 8284.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366471.htm', '2026-02-23 11:37:01.897019', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1457, '保利上城东区 3室2厅 86.9平', '武汉-白沙洲', 86.9, '3室2厅', 75.00, 8630.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374340.htm', '2026-02-23 11:37:01.903495', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1458, '保利新武昌 3室2厅 107.59平', 'wuhan-白沙洲-烽胜路与八坦北路交汇处(张家湾社区旁)', 107.59, '3室2厅', 115.00, 10688.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369284.htm', '2026-02-23 11:37:01.909169', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1459, '保利新武昌 3室2厅 106.66平', '武汉-白沙洲', 106.66, '3室2厅', 114.00, 10688.17, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369338.htm', '2026-02-23 11:37:01.914404', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1460, '保利上城西区 3室2厅 109.77平', 'wuhan-白沙洲-白沙洲大道与江国路交汇处东南侧', 109.77, '3室2厅', 105.00, 9565.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325865.htm', '2026-02-23 11:37:01.920369', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1461, '保利上城东区 3室2厅 95.31平', '武汉-白沙洲', 95.31, '3室2厅', 82.00, 8603.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374361.htm', '2026-02-23 11:37:01.926574', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1462, '东原启城 3室2厅 109.77平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 109.77, '3室2厅', 95.00, 8654.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333490.htm', '2026-02-23 11:37:01.931722', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1463, '世茂云锦樱海园 3室2厅 94.95平', 'wuhan-白沙洲-世茂云锦樱海园', 94.95, '3室2厅', 80.00, 8425.49, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372918.htm', '2026-02-23 11:37:01.937367', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1464, '东原启城 3室1厅 98.36平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 98.36, '3室1厅', 85.00, 8641.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333486.htm', '2026-02-23 11:37:01.944026', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1465, '东原启城 3室2厅 130.59平', 'wuhan-白沙洲-白沙五路与烽胜路交汇处', 130.59, '3室2厅', 112.00, 8576.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333162.htm', '2026-02-23 11:37:01.950158', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1466, '清能清江锦城 2室2厅 86.28平', '武汉-白沙洲', 86.28, '2室2厅', 72.00, 8344.92, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366424.htm', '2026-02-23 11:37:01.955403', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1467, '保利新武昌 3室2厅 123.97平', '武汉-白沙洲', 123.97, '3室2厅', 132.00, 10647.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369326.htm', '2026-02-23 11:37:01.961463', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1468, '清能清江锦城 3室1厅 130.27平', '武汉-白沙洲', 130.27, '3室1厅', 108.00, 8290.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366421.htm', '2026-02-23 11:37:01.967075', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1469, '佳兆业金域天下 3室2厅 107.52平', 'wuhan-白沙洲-白沙洲新城烽胜路36号(工商学院旁)', 107.52, '3室2厅', 91.00, 8463.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353019.htm', '2026-02-23 11:37:01.973158', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1470, '顶琇国际公馆 3室2厅 108.59平', '武汉-红旗渠常青路', 108.59, '3室2厅', 115.00, 10590.29, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365720.htm', '2026-02-23 11:53:06.608091', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1471, '福星惠誉福星华府·峯 3室2厅 120.99平', '武汉-塔子湖', 120.99, '3室2厅', 134.00, 11075.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365719.htm', '2026-02-23 11:53:06.614335', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1472, '融创公园壹号三期融创 3室2厅 104.72平', '武汉-塔子湖', 104.72, '3室2厅', 115.00, 10981.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378999.htm', '2026-02-23 11:53:06.619240', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1473, '汉口花园怡菊苑 3室2厅 113.21平', '武汉-塔子湖', 113.21, '3室2厅', 80.00, 7066.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368649.htm', '2026-02-23 11:53:06.623805', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1474, '福星惠誉·铂雅府 4室2厅 145.0平', '武汉-竹叶山花桥', 145, '4室2厅', 200.00, 13793.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202281380.htm', '2026-02-23 11:53:06.629973', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1475, '松涛苑 3室2厅 98.86平', '武汉-南湖花园', 98.86, '3室2厅', 118.00, 11936.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363242.htm', '2026-02-23 11:53:06.635286', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1476, '中央花园 3室2厅 109.85平', '武汉-南湖花园', 109.85, '3室2厅', 149.00, 13563.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202358571.htm', '2026-02-23 11:53:06.640579', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1477, '金地澜菲溪岸 3室2厅 95.02平', '武汉-四新', 95.02, '3室2厅', 82.00, 8629.76, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202344490.htm', '2026-02-23 11:53:06.645724', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1478, '新城璟悦城 3室2厅 109.75平', '武汉-四新', 109.75, '3室2厅', 115.00, 10478.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202344435.htm', '2026-02-23 11:53:06.651093', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1479, '城投四新之光 3室2厅 110.97平', '武汉-四新', 110.97, '3室2厅', 95.00, 8560.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202344405.htm', '2026-02-23 11:53:06.656264', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1480, '东湖ONE 3室2厅 111.0平', '武汉-钢都', 111, '3室2厅', 149.00, 13423.42, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202020545.htm', '2026-02-23 11:53:06.661178', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1481, '江南庭园 4室2厅 151.03平', '武汉-南湖花园', 151.03, '4室2厅', 280.00, 18539.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202330272.htm', '2026-02-23 11:53:06.665822', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1482, '常青花园一村 2室2厅 68.64平', '武汉-常青花园', 68.64, '2室2厅', 37.00, 5390.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375775.htm', '2026-02-23 11:53:06.671837', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1483, '福星华府·琛境 3室2厅 129.0平', '武汉-红旗渠常青路', 129, '3室2厅', 140.00, 10852.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202235146.htm', '2026-02-23 11:53:06.676437', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1484, '中海万松九里 5室2厅 229.79平', '武汉-武广万松园', 229.79, '5室2厅', 620.00, 26981.16, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202285870.htm', '2026-02-23 11:53:06.682238', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1485, '长江广电·光谷家 3室2厅 123.25平', '武汉-光谷东', 123.25, '3室2厅', 144.00, 11683.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202330916.htm', '2026-02-23 11:53:06.687466', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1486, '保利大都会 4室2厅 157.29平', '武汉-街道口', 157.29, '4室2厅', 350.00, 22251.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202361232.htm', '2026-02-23 11:53:06.693169', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1487, '城投瀚城璞岸 4室2厅 146.04平', '武汉-卓刀泉', 146.04, '4室2厅', 260.00, 17803.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202361226.htm', '2026-02-23 11:53:06.698280', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1488, '金地天悦 3室2厅 133.26平', '武汉-光谷', 133.26, '3室2厅', 185.00, 13882.64, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202339893.htm', '2026-02-23 11:53:06.704335', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1489, '钰龙旭辉半岛MINI 3室2厅 101.0平', '武汉-七里庙', 101, '3室2厅', 109.00, 10792.08, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202330496.htm', '2026-02-23 11:53:06.709981', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1490, '长江广电·光谷家 3室2厅 123.25平', '武汉-光谷东', 123.25, '3室2厅', 144.00, 11683.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202370953.htm', '2026-02-23 11:53:06.715514', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1491, '电建地产·泷悦长安 4室2厅 143.26平', '武汉-七里庙', 143.26, '4室2厅', 129.00, 9004.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202001717.htm', '2026-02-23 11:53:06.720070', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1492, '长投领峯 3室2厅 117.15平', '武汉-光谷东', 117.15, '3室2厅', 139.00, 11865.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249470.htm', '2026-02-23 11:53:06.725136', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1493, '保利拉菲堂皇 6室3厅 200.25平', '武汉-卓刀泉', 200.25, '', 550.00, 27465.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202361215.htm', '2026-02-23 11:53:06.729864', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1494, '宝业·璞园 3室2厅 110.0平', '武汉-光谷东', 110, '3室2厅', 155.00, 14090.91, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249595.htm', '2026-02-23 11:53:06.734478', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1495, '城投联投江南岸 3室2厅 103.0平', '武汉-白沙洲', 103, '3室2厅', 115.00, 11165.05, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202303926.htm', '2026-02-23 11:53:06.740230', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1496, '保利庭瑞阅江台 3室2厅 106.11平', '武汉-王家湾', 106.11, '3室2厅', 119.00, 11214.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249586.htm', '2026-02-23 11:53:06.745755', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1497, '保利华都 3室2厅 110.19平', '武汉-卓刀泉', 110.19, '3室2厅', 185.00, 16789.18, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202361192.htm', '2026-02-23 11:53:06.750383', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1498, '保利大都会 4室2厅 157.29平', '武汉-街道口', 157.29, '4室2厅', 360.00, 22887.66, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202361222.htm', '2026-02-23 11:53:06.755994', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1499, '武汉城建·电建·幸福时代大家 3室2厅 109.0平', '武汉-百步亭', 109, '3室2厅', 138.00, 12660.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200594131.htm', '2026-02-23 11:53:06.761123', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1500, '保利大都会尚湖 3室2厅 128.53平', '武汉-街道口', 128.53, '3室2厅', 220.00, 17116.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340116.htm', '2026-02-23 11:53:06.766808', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1501, '城投·武汉印 3室2厅 130.0平', '武汉-武昌中心', 130, '3室2厅', 216.50, 16653.85, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202201422.htm', '2026-02-23 11:53:06.772241', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1502, '金地自在城 3室2厅 117.56平', '武汉-钢都', 117.56, '3室2厅', 149.00, 12674.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202335229.htm', '2026-02-23 11:53:06.777302', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1503, '东湖ONE 3室2厅 122.0平', '武汉-钢都', 122, '3室2厅', 139.00, 11393.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249687.htm', '2026-02-23 11:53:06.783739', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1504, '城投南山长投·领峯 3室2厅 108.57平', '武汉-光谷东', 108.57, '3室2厅', 129.00, 11881.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249469.htm', '2026-02-23 11:53:06.788471', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1505, '融创中心武汉壹号院 4室2厅 216.27平', '武汉-中北路', 216.27, '4室2厅', 542.00, 25061.27, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201617980.htm', '2026-02-23 11:53:06.793745', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1506, '东湖金茂府 3室2厅 93.0平', '武汉-工业四路', 93, '3室2厅', 115.00, 12365.59, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202001708.htm', '2026-02-23 11:53:06.798556', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1507, '东湖风光 3室2厅 115.0平', '武汉-街道口', 115, '3室2厅', 200.90, 17469.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249453.htm', '2026-02-23 11:53:06.803710', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1508, '银海华庭 3室2厅 140.4平', '武汉-水果湖', 140.4, '3室2厅', 205.00, 14601.14, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201787619.htm', '2026-02-23 11:53:06.809114', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1509, '福星华府·琛境 3室2厅 129.0平', '武汉-红旗渠常青路', 129, '3室2厅', 165.00, 12790.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202249592.htm', '2026-02-23 11:53:06.814334', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1510, '水果湖路1号 3室1厅 102.26平', '武汉-水果湖', 102.26, '3室1厅', 168.00, 16428.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201883173.htm', '2026-02-23 11:53:06.819187', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1511, '南苑村 3室2厅 115.76平', '武汉-水果湖', 115.76, '3室2厅', 245.00, 21164.48, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201904816.htm', '2026-02-23 11:53:06.824346', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1512, '汉口城市广场 3室2厅 96.74平', '武汉-百步亭', 96.74, '3室2厅', 99.00, 10233.62, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201931125.htm', '2026-02-23 11:53:06.829218', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1513, '水果湖放鹰台社区 4室2厅 146.76平', '武汉-水果湖', 146.76, '4室2厅', 229.00, 15603.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202005772.htm', '2026-02-23 11:53:06.833982', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1514, '保利·锦上印 4室2厅 124.0平', '武汉-将军路', 124, '4室2厅', 80.00, 6451.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202201540.htm', '2026-02-23 11:53:06.839751', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1515, '保利庭瑞阅江台 3室2厅 114.0平', '武汉-王家湾', 114, '3室2厅', 101.00, 8859.65, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201947289.htm', '2026-02-23 11:53:06.844134', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1516, '泷悦华府 4室2厅 158.41平', '武汉-光谷', 158.41, '4室2厅', 330.00, 20832.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202076180.htm', '2026-02-23 11:53:06.850174', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1517, '泷悦华府 4室2厅 158.95平', '武汉-光谷', 158.95, '4室2厅', 350.00, 22019.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201752233.htm', '2026-02-23 11:53:06.854308', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1518, '泷悦华府 4室2厅 158.87平', '武汉-光谷', 158.87, '4室2厅', 310.00, 19512.81, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701207.htm', '2026-02-23 11:53:06.859966', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1519, '光谷新世界 3室2厅 134.57平', '武汉-关山', 134.57, '3室2厅', 222.00, 16496.99, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201709285.htm', '2026-02-23 11:53:06.865595', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1520, '光谷新世界 3室2厅 106.54平', '武汉-关山', 106.54, '3室2厅', 169.00, 15862.59, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201709297.htm', '2026-02-23 11:53:06.870651', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1521, '光谷新世界 3室2厅 100.97平', '武汉-关山', 100.97, '3室2厅', 155.00, 15351.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201720618.htm', '2026-02-23 11:53:06.875956', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1522, '保利时代南区 4室2厅 147.56平', '武汉-光谷', 147.56, '4室2厅', 280.00, 18975.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201765070.htm', '2026-02-23 11:53:06.881443', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1523, '光谷新世界 3室2厅 128.3平', '武汉-关山', 128.3, '3室2厅', 200.00, 15588.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201709289.htm', '2026-02-23 11:53:06.886111', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1524, '光谷新世界 3室2厅 134.58平', '武汉-关山', 134.58, '3室2厅', 235.00, 17461.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201709274.htm', '2026-02-23 11:53:06.891212', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1525, '光谷新世界 3室2厅 134.58平', '武汉-关山', 134.58, '3室2厅', 232.00, 17238.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201709276.htm', '2026-02-23 11:53:06.896345', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1526, '泷悦华府 4室2厅 124.03平', '武汉-光谷', 124.03, '4室2厅', 220.00, 17737.64, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701212.htm', '2026-02-23 11:53:06.902395', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1527, '长航蓝晶国际B区 3室2厅 105.07平', '武汉-关山', 105.07, '3室2厅', 150.00, 14276.20, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201762639.htm', '2026-02-23 11:53:06.907451', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1528, '金地光谷世家 2室2厅 83.26平', '武汉-光谷', 83.26, '2室2厅', 94.00, 11289.94, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701069.htm', '2026-02-23 11:53:06.911983', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1529, '长航蓝晶国际B区 3室2厅 105.07平', '武汉-关山', 105.07, '3室2厅', 145.00, 13800.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202078269.htm', '2026-02-23 11:53:06.918071', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1530, '金地光谷世家 3室2厅 101.37平', '武汉-光谷', 101.37, '3室2厅', 132.00, 13021.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701155.htm', '2026-02-23 11:53:06.922603', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1531, '金鑫国际 3室2厅 81.46平', '武汉-光谷', 81.46, '3室2厅', 88.00, 10802.85, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201749488.htm', '2026-02-23 11:53:06.927758', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1532, '光谷新世界 2室2厅 93.3平', '武汉-关山', 93.3, '2室2厅', 146.00, 15648.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201720687.htm', '2026-02-23 11:53:06.932959', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1533, '金鑫国际 3室2厅 66.69平', '武汉-光谷', 66.69, '3室2厅', 82.00, 12295.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201716650.htm', '2026-02-23 11:53:06.938010', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1534, '金鑫国际 3室2厅 67.0平', '武汉-光谷', 67, '3室2厅', 88.00, 13134.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074684.htm', '2026-02-23 11:53:06.944641', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1535, '金地光谷世家 3室2厅 131.77平', '武汉-光谷', 131.77, '3室2厅', 142.00, 10776.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202078349.htm', '2026-02-23 11:53:06.949684', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1536, '金鑫国际 3室2厅 66.69平', '武汉-光谷', 66.69, '3室2厅', 85.00, 12745.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201735433.htm', '2026-02-23 11:53:06.954754', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1537, '金鑫国际 3室2厅 81.46平', '武汉-光谷', 81.46, '3室2厅', 90.00, 11048.37, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074690.htm', '2026-02-23 11:53:06.959836', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1538, '世界城尚都 1室1厅 56.63平', '武汉-光谷', 56.63, '1室1厅', 42.00, 7416.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201712424.htm', '2026-02-23 11:53:06.965810', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1539, '金地光谷世家 3室2厅 101.37平', '武汉-光谷', 101.37, '3室2厅', 128.00, 12627.01, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701157.htm', '2026-02-23 11:53:06.970485', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1540, '光谷8号 3室1厅 95.0平', '武汉-光谷', 95, '3室1厅', 116.00, 12210.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202076953.htm', '2026-02-23 11:53:06.976649', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1541, '明珠花园 3室2厅 116.06平', '武汉-光谷', 116.06, '3室2厅', 99.00, 8530.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074816.htm', '2026-02-23 11:53:06.982219', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1542, '金地光谷世家 2室2厅 83.26平', '武汉-光谷', 83.26, '2室2厅', 108.00, 12971.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201706479.htm', '2026-02-23 11:53:06.987375', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1543, '世界城尚都 1室1厅 56.63平', '武汉-光谷', 56.63, '1室1厅', 42.00, 7416.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201712427.htm', '2026-02-23 11:53:06.993497', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1544, '金鑫国际 2室2厅 66.69平', '武汉-光谷', 66.69, '2室2厅', 67.00, 10046.48, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201700992.htm', '2026-02-23 11:53:06.999056', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1545, '金鑫国际 3室2厅 81.46平', '武汉-光谷', 81.46, '3室2厅', 85.00, 10434.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074795.htm', '2026-02-23 11:53:07.004627', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1546, '金地光谷世家 1室1厅 63.45平', '武汉-光谷', 63.45, '1室1厅', 65.00, 10244.29, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201762779.htm', '2026-02-23 11:53:07.010446', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1547, '金地光谷世家 2室2厅 83.43平', '武汉-光谷', 83.43, '2室2厅', 95.00, 11386.79, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201706475.htm', '2026-02-23 11:53:07.016213', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1548, '世界城尚都 1室1厅 55.97平', '武汉-光谷', 55.97, '1室1厅', 43.00, 7682.69, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201712370.htm', '2026-02-23 11:53:07.023064', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1549, '金地光谷世家 2室2厅 83.43平', '武汉-光谷', 83.43, '2室2厅', 100.00, 11986.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701033.htm', '2026-02-23 11:53:07.028629', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1550, '金地光谷世家 2室2厅 83.43平', '武汉-光谷', 83.43, '2室2厅', 105.00, 12585.40, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701046.htm', '2026-02-23 11:53:07.033748', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1551, '金地光谷世家 1室1厅 63.45平', '武汉-光谷', 63.45, '1室1厅', 66.00, 10401.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701037.htm', '2026-02-23 11:53:07.038880', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1552, '金鑫国际 2室2厅 66.69平', '武汉-光谷', 66.69, '2室2厅', 68.00, 10196.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201749506.htm', '2026-02-23 11:53:07.043515', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1553, '金地光谷世家 3室2厅 131.77平', '武汉-光谷', 131.77, '3室2厅', 162.00, 12294.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201706473.htm', '2026-02-23 11:53:07.048919', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1554, '金鑫国际 3室2厅 66.69平', '武汉-光谷', 66.69, '3室2厅', 68.00, 10196.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201735432.htm', '2026-02-23 11:53:07.054075', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1555, '金鑫国际 3室2厅 81.46平', '武汉-光谷', 81.46, '3室2厅', 85.00, 10434.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201700980.htm', '2026-02-23 11:53:07.059342', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1556, '金鑫国际 2室2厅 66.69平', '武汉-光谷', 66.69, '2室2厅', 68.00, 10196.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202078248.htm', '2026-02-23 11:53:07.064331', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1557, '金地光谷世家 3室2厅 131.83平', '武汉-光谷', 131.83, '3室2厅', 146.00, 11074.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202078351.htm', '2026-02-23 11:53:07.069600', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1558, '金鑫国际 3室2厅 108.42平', '武汉-光谷', 108.42, '3室2厅', 102.00, 9407.86, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074650.htm', '2026-02-23 11:53:07.074488', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1559, '金鑫国际 2室2厅 66.69平', '武汉-光谷', 66.69, '2室2厅', 68.00, 10196.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074759.htm', '2026-02-23 11:53:07.079543', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1560, '保利新武昌 3室2厅 107.05平', '武汉-白沙洲', 107.05, '3室2厅', 114.00, 10649.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369378.htm', '2026-02-23 11:53:07.128207', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1561, '保利新武昌 3室2厅 126.4平', '武汉-白沙洲', 126.4, '3室2厅', 135.00, 10680.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369382.htm', '2026-02-23 11:53:07.132857', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1562, '光谷陆景苑 3室2厅 127.01平', '武汉-关山', 127.01, '3室2厅', 80.00, 6298.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202078223.htm', '2026-02-23 11:53:07.138060', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1563, '葛光社区 3室1厅 89.81平', '武汉-关山', 89.81, '3室1厅', 60.00, 6680.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202083947.htm', '2026-02-23 11:53:07.143884', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1564, '金鑫国际 3室2厅 108.42平', '武汉-光谷', 108.42, '3室2厅', 105.00, 9684.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202074670.htm', '2026-02-23 11:53:07.148114', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1565, '光谷8号 3室1厅 95.56平', '武汉-光谷', 95.56, '3室1厅', 110.00, 11511.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202076951.htm', '2026-02-23 11:53:07.154151', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1566, '招商一江璟城 3室2厅 135.72平', '武汉-红钢城', 135.72, '3室2厅', 163.00, 12010.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202377019.htm', '2026-02-23 11:53:07.158774', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1567, '金鑫国际 3室2厅 89.76平', '武汉-光谷', 89.76, '3室2厅', 90.00, 10026.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201701016.htm', '2026-02-23 11:53:07.173488', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1568, '保利新武昌 3室2厅 116.71平', '武汉-白沙洲', 116.71, '3室2厅', 124.00, 10624.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202292031.htm', '2026-02-23 11:53:07.206296', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1569, '华腾园 3室2厅 129.5平', '武汉-徐东', 129.5, '3室2厅', 102.00, 7876.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378928.htm', '2026-02-23 11:53:07.320768', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1570, '金地自在城 2室1厅 74.8平', '武汉-钢都', 74.8, '2室1厅', 76.00, 10160.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341975.htm', '2026-02-23 11:53:07.326442', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1571, '保利城 2室2厅 88.97平', '武汉-徐东', 88.97, '2室2厅', 89.00, 10003.37, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379628.htm', '2026-02-23 11:53:07.332587', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1572, '恒大名都 4室2厅 156.66平', '武汉-盘龙城', 156.66, '4室2厅', 83.00, 5298.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366692.htm', '2026-02-23 11:53:07.337725', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1573, '七星富利天城 3室2厅 134.98平', '武汉-红钢城', 134.98, '3室2厅', 110.00, 8149.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380037.htm', '2026-02-23 11:53:07.342861', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1574, '水岸国际峯岚天下 2室2厅 90.66平', '武汉-积玉桥', 90.66, '2室2厅', 107.00, 11802.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379625.htm', '2026-02-23 11:53:07.348505', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1575, '112物业小区 3室1厅 83.79平', '武汉-工业四路', 83.79, '3室1厅', 40.00, 4773.84, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372465.htm', '2026-02-23 11:53:07.353576', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1576, '丽华苑 2室2厅 79.48平', '武汉-徐东', 79.48, '2室2厅', 58.00, 7297.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202377008.htm', '2026-02-23 11:53:07.360293', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1577, '大华滨江天地 2室1厅 60.52平', '武汉-建二', 60.52, '2室1厅', 75.00, 12392.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202377018.htm', '2026-02-23 11:53:07.364836', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1578, '青宜居 2室1厅 66.56平', '武汉-红钢城', 66.56, '2室1厅', 41.00, 6159.86, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202148761.htm', '2026-02-23 11:53:07.370874', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1579, '东方丽锦西区 2室2厅 89.99平', '武汉-工业四路', 89.99, '2室2厅', 55.00, 6111.79, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352131.htm', '2026-02-23 11:53:07.376542', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1580, '奥山世纪城V公馆 2室2厅 80.0平', '武汉-建二', 80, '2室2厅', 87.70, 10962.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355111.htm', '2026-02-23 11:53:07.382175', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1581, '青山江南新天地 2室2厅 86.67平', '武汉-钢都', 86.67, '2室2厅', 65.00, 7499.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375518.htm', '2026-02-23 11:53:07.387820', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1582, '东沙花园 2室2厅 91.65平', '武汉-徐东', 91.65, '2室2厅', 70.00, 7637.75, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378930.htm', '2026-02-23 11:53:07.394071', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1583, '奥山世纪城澜橼 3室2厅 91.62平', '武汉-建二', 91.62, '3室2厅', 110.00, 12006.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355108.htm', '2026-02-23 11:53:07.398661', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1584, '大华滨江天地 2室1厅 84.41平', '武汉-建二', 84.41, '2室1厅', 89.00, 10543.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202377009.htm', '2026-02-23 11:53:07.404832', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1585, '百胜青城一品 2室1厅 75.39平', '武汉-钢都', 75.39, '2室1厅', 63.00, 8356.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375205.htm', '2026-02-23 11:53:07.410446', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1586, '八大家花园 2室1厅 78.44平', '武汉-钢都', 78.44, '2室1厅', 73.00, 9306.48, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380135.htm', '2026-02-23 11:53:07.416019', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1587, '杨春湖畔 3室2厅 109.12平', '武汉-工业四路', 109.12, '3室2厅', 106.00, 9714.08, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202376958.htm', '2026-02-23 11:53:07.420682', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1588, '锦绣龙潭 2室1厅 87.6平', '武汉-钢都', 87.6, '2室1厅', 90.00, 10273.97, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380137.htm', '2026-02-23 11:53:07.426963', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1589, '新鑫园 3室2厅 114.55平', '武汉-钢都', 114.55, '3室2厅', 70.00, 6110.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202360144.htm', '2026-02-23 11:53:07.432173', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1590, '钢花新村111街 2室1厅 69.85平', '武汉-工业四路', 69.85, '2室1厅', 38.00, 5440.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372422.htm', '2026-02-23 11:53:07.437873', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1591, '绿地香树花城 4室2厅 137.79平', '武汉-红钢城', 137.79, '4室2厅', 102.00, 7402.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352132.htm', '2026-02-23 11:53:07.443521', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1592, '华城广场 2室2厅 117.15平', '武汉-徐东', 117.15, '2室2厅', 79.00, 6743.49, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380118.htm', '2026-02-23 11:53:07.449095', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1593, '青扬十街 3室2厅 114.28平', '武汉-红钢城', 114.28, '3室2厅', 110.00, 9625.48, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380151.htm', '2026-02-23 11:53:07.454718', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1594, '爱家国际华城 3室2厅 142.71平', '武汉-徐东', 142.71, '3室2厅', 143.00, 10020.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379633.htm', '2026-02-23 11:53:07.460265', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1595, '临江港湾 2室1厅 61.62平', '武汉-红钢城', 61.62, '2室1厅', 30.00, 4868.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380024.htm', '2026-02-23 11:53:07.465876', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1596, '融侨城 3室2厅 90.62平', '武汉-徐东', 90.62, '3室2厅', 115.00, 12690.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202342053.htm', '2026-02-23 11:53:07.472415', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1597, '丽华苑 2室1厅 81.35平', '武汉-徐东', 81.35, '2室1厅', 60.00, 7375.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202343330.htm', '2026-02-23 11:53:07.477980', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1598, '沙湖港湾B区 3室2厅 139.69平', '武汉-钢都', 139.69, '3室2厅', 83.00, 5941.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378945.htm', '2026-02-23 11:53:07.483069', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1599, '保利新武昌 3室2厅 116.71平', '武汉-白沙洲', 116.71, '3室2厅', 124.00, 10624.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369279.htm', '2026-02-23 11:53:07.494654', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1600, '保利新武昌 3室2厅 94.83平', '武汉-白沙洲', 94.83, '3室2厅', 101.00, 10650.64, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369341.htm', '2026-02-23 11:53:07.506245', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1601, '复地悦城二期东区 3室2厅 89.15平', '武汉-白沙洲', 89.15, '3室2厅', 89.00, 9983.17, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202174688.htm', '2026-02-23 11:53:07.523391', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1602, '保利上城西区 3室2厅 88.06平', '武汉-白沙洲', 88.06, '3室2厅', 84.00, 9538.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325883.htm', '2026-02-23 11:53:07.528933', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1603, '复地悦城二期东区 3室2厅 94.45平', '武汉-白沙洲', 94.45, '3室2厅', 84.00, 8893.59, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288307.htm', '2026-02-23 11:53:07.535003', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1604, '保利新武昌 3室1厅 108.13平', '武汉-白沙洲', 108.13, '3室1厅', 119.90, 11088.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288247.htm', '2026-02-23 11:53:07.545679', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1605, '保利上城东区 3室2厅 95.82平', '武汉-白沙洲', 95.82, '3室2厅', 83.00, 8662.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374359.htm', '2026-02-23 11:53:07.550725', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1606, '保利新武昌 3室2厅 123.73平', '武汉-白沙洲', 123.73, '3室2厅', 136.90, 11064.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288074.htm', '2026-02-23 11:53:07.555783', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1607, '保利新武昌 3室2厅 94.88平', '武汉-白沙洲', 94.88, '3室2厅', 104.90, 11056.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288101.htm', '2026-02-23 11:53:07.561318', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1608, '复地悦城二期东区 2室2厅 78.45平', '武汉-白沙洲', 78.45, '2室2厅', 72.00, 9177.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334213.htm', '2026-02-23 11:53:07.588857', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1609, '世茂云锦樱海园 3室2厅 102.49平', '武汉-白沙洲', 102.49, '3室2厅', 90.00, 8781.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372923.htm', '2026-02-23 11:53:07.595036', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1610, '保利上城西区 2室2厅 79.09平', '武汉-白沙洲', 79.09, '2室2厅', 76.00, 9609.31, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325936.htm', '2026-02-23 11:53:07.611742', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1611, '清能清江锦城 4室1厅 114.47平', '武汉-白沙洲', 114.47, '4室1厅', 95.00, 8299.12, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366492.htm', '2026-02-23 11:53:07.617783', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1612, '保利新武昌 3室2厅 102.14平', '武汉-白沙洲', 102.14, '3室2厅', 112.90, 11053.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294869.htm', '2026-02-23 11:53:07.623423', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1613, '东原启城 4室2厅 136.27平', '武汉-白沙洲', 136.27, '4室2厅', 113.00, 8292.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364174.htm', '2026-02-23 11:53:07.628963', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1614, '菁英城 3室2厅 99.11平', '武汉-白沙洲', 99.11, '3室2厅', 90.00, 9080.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363361.htm', '2026-02-23 11:53:07.634998', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1615, '城投联投誉江南 3室2厅 99.21平', '武汉-白沙洲', 99.21, '3室2厅', 106.00, 10684.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202362205.htm', '2026-02-23 11:53:07.640054', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1616, '清能清江锦城 3室1厅 130.27平', '武汉-白沙洲', 130.27, '3室1厅', 108.00, 8290.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379916.htm', '2026-02-23 11:53:07.656342', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1617, '清能清江锦城 3室2厅 115.21平', '武汉-白沙洲', 115.21, '3室2厅', 100.00, 8679.80, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379908.htm', '2026-02-23 11:53:07.667918', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1618, '保利新武昌 3室2厅 100.92平', '武汉-白沙洲', 100.92, '3室2厅', 112.00, 11097.90, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294789.htm', '2026-02-23 11:53:07.673061', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1619, '清能清江锦城 2室2厅 88.65平', '武汉-白沙洲', 88.65, '2室2厅', 74.00, 8347.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379914.htm', '2026-02-23 11:53:07.678152', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1620, '清能清江锦城 3室2厅 104.98平', '武汉-白沙洲', 104.98, '3室2厅', 88.00, 8382.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379915.htm', '2026-02-23 11:53:07.684458', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1621, '保利新武昌 3室2厅 100.48平', '武汉-白沙洲', 100.48, '3室2厅', 111.00, 11046.97, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288064.htm', '2026-02-23 11:53:07.695231', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1622, '世茂云锦樱海园 3室2厅 120.28平', '武汉-白沙洲', 120.28, '3室2厅', 103.00, 8563.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372893.htm', '2026-02-23 11:53:07.700961', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1623, '保利新武昌 3室2厅 116.05平', '武汉-白沙洲', 116.05, '3室2厅', 128.90, 11107.28, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316951.htm', '2026-02-23 11:53:07.706542', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1624, '保利新武昌 3室2厅 116.65平', '武汉-白沙洲', 116.65, '3室2厅', 127.00, 10887.27, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202179912.htm', '2026-02-23 11:53:07.712079', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1625, '复地悦城二期东区 2室1厅 78.45平', '武汉-白沙洲', 78.45, '2室1厅', 73.00, 9305.29, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334215.htm', '2026-02-23 11:53:07.717124', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1626, '清能清江锦城 2室2厅 90.67平', '武汉-白沙洲', 90.67, '2室2厅', 75.00, 8271.75, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366433.htm', '2026-02-23 11:53:07.728902', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1627, '保利新武昌 3室2厅 116.65平', '武汉-白沙洲', 116.65, '3室2厅', 125.00, 10715.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316889.htm', '2026-02-23 11:53:07.734453', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1628, '保利新武昌 3室2厅 97.18平', '武汉-白沙洲', 97.18, '3室2厅', 107.90, 11103.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288246.htm', '2026-02-23 11:53:07.746096', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1629, '复地悦城二期东区 3室2厅 87.15平', '武汉-白沙洲', 87.15, '3室2厅', 78.00, 8950.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334216.htm', '2026-02-23 11:53:07.752155', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1630, '保利新武昌 3室2厅 130.23平', '武汉-白沙洲', 130.23, '3室2厅', 139.90, 10742.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202317179.htm', '2026-02-23 11:53:07.756896', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1631, '保利上城东区 3室2厅 95.82平', '武汉-白沙洲', 95.82, '3室2厅', 83.00, 8662.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374364.htm', '2026-02-23 11:53:07.763114', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1632, '保利新武昌 3室2厅 107.05平', '武汉-白沙洲', 107.05, '3室2厅', 119.00, 11116.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202287935.htm', '2026-02-23 11:53:07.767670', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1633, '菁英城 3室1厅 98.19平', '武汉-白沙洲', 98.19, '3室1厅', 79.00, 8045.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363289.htm', '2026-02-23 11:53:07.773712', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1634, '龙湖·天璞 3室2厅 114.81平', '武汉-白沙洲', 114.81, '3室2厅', 158.00, 13761.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202348951.htm', '2026-02-23 11:53:07.779247', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1635, '保利上城西区 2室2厅 78.88平', '武汉-白沙洲', 78.88, '2室2厅', 76.00, 9634.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325932.htm', '2026-02-23 11:53:07.784277', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1636, '保利新武昌 3室2厅 116.71平', '武汉-白沙洲', 116.71, '3室2厅', 125.90, 10787.42, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316886.htm', '2026-02-23 11:53:07.800963', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1637, '清能清江锦城 3室2厅 131.02平', '武汉-白沙洲', 131.02, '3室2厅', 109.00, 8319.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366476.htm', '2026-02-23 11:53:07.806609', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1638, '复地悦城二期东区 4室2厅 136.41平', '武汉-白沙洲', 136.41, '4室2厅', 126.00, 9236.86, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334440.htm', '2026-02-23 11:53:07.818755', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1639, '保利新武昌 3室2厅 123.49平', '武汉-白沙洲', 123.49, '3室2厅', 136.90, 11085.92, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294879.htm', '2026-02-23 11:53:07.824351', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1640, '保利新武昌 3室2厅 97.18平', '武汉-白沙洲', 97.18, '3室2厅', 105.00, 10804.69, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316892.htm', '2026-02-23 11:53:07.829399', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1641, '复地悦城一期西区 3室1厅 86.67平', '武汉-白沙洲', 86.67, '3室1厅', 74.00, 8538.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375627.htm', '2026-02-23 11:53:07.835025', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1642, '保利上城西区 3室2厅 123.84平', '武汉-白沙洲', 123.84, '3室2厅', 127.00, 10255.17, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331147.htm', '2026-02-23 11:53:07.840565', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1643, '佳兆业金域天下 3室2厅 109.82平', '武汉-白沙洲', 109.82, '3室2厅', 92.00, 8377.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353046.htm', '2026-02-23 11:53:07.851720', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1644, '清能清江锦城 2室2厅 90.27平', '武汉-白沙洲', 90.27, '2室2厅', 75.00, 8308.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366417.htm', '2026-02-23 11:53:07.857264', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1645, '清能清江锦城 2室2厅 90.27平', '武汉-白沙洲', 90.27, '2室2厅', 75.00, 8308.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379913.htm', '2026-02-23 11:53:07.862303', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1646, '清能清江锦城 3室1厅 130.27平', '武汉-白沙洲', 130.27, '3室1厅', 113.00, 8674.29, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379911.htm', '2026-02-23 11:53:07.868352', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1647, '清能清江锦城 2室2厅 93.97平', '武汉-白沙洲', 93.97, '2室2厅', 85.00, 9045.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202332302.htm', '2026-02-23 11:53:07.879934', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1648, '世茂云锦樱海园 3室1厅 94.95平', '武汉-白沙洲', 94.95, '3室1厅', 82.00, 8636.12, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372904.htm', '2026-02-23 11:53:07.885624', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1649, '清能清江锦城 2室2厅 86.5平', '武汉-白沙洲', 86.5, '2室2厅', 75.00, 8670.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379910.htm', '2026-02-23 11:53:07.890621', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1650, '洺悦芳华 3室2厅 105.87平', '武汉-三角湖', 105.87, '3室2厅', 105.00, 9917.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365245.htm', '2026-02-23 11:53:07.896268', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1651, '喜瑞都 3室2厅 100.97平', '武汉-白沙洲', 100.97, '3室2厅', 85.00, 8418.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357286.htm', '2026-02-23 11:53:07.903049', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1652, '保利新武昌 3室2厅 102.14平', '武汉-白沙洲', 102.14, '3室2厅', 109.00, 10671.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369330.htm', '2026-02-23 11:53:07.909601', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1653, '喜瑞都 3室2厅 114.75平', '武汉-白沙洲', 114.75, '3室2厅', 103.00, 8976.03, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357289.htm', '2026-02-23 11:53:07.914723', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1654, '保利上城西区 4室2厅 152.13平', '武汉-白沙洲', 152.13, '4室2厅', 151.00, 9925.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331109.htm', '2026-02-23 11:53:07.920760', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1655, '复地悦城二期东区 2室2厅 82.35平', '武汉-白沙洲', 82.35, '2室2厅', 75.00, 9107.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334176.htm', '2026-02-23 11:53:07.931494', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1656, '万科城市之光 3室2厅 111.32平', '武汉-白沙洲', 111.32, '3室2厅', 121.00, 10869.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352620.htm', '2026-02-23 11:53:07.936610', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1657, '万科城市之光 3室2厅 119.51平', '武汉-白沙洲', 119.51, '3室2厅', 133.90, 11204.08, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352642.htm', '2026-02-23 11:53:07.942267', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1658, '清能清江锦城 3室2厅 131.02平', '武汉-白沙洲', 131.02, '3室2厅', 108.90, 8311.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202192576.htm', '2026-02-23 11:53:07.948906', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1659, '星河天街 3室2厅 120.04平', '孝感-南大经济开发区', 120.04, '3室2厅', 58.00, 4831.72, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995377.htm', '2026-02-23 12:23:57.404380', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1660, '御景水岸 2室2厅 99.0平', '孝感-东城区', 99, '2室2厅', 53.00, 5353.54, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995354.htm', '2026-02-23 12:23:57.414118', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1661, '景程·湾流汇 4室2厅 148.43平', '孝感-东城区', 148.43, '4室2厅', 62.00, 4177.05, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155971440.htm', '2026-02-23 12:23:57.419325', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1662, '星河天街 3室2厅 102.66平', '孝感-南大经济开发区', 102.66, '3室2厅', 45.00, 4383.40, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995348.htm', '2026-02-23 12:23:57.424090', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1663, '鼎观世界 4室2厅 98.0平', '孝感-东城区', 98, '4室2厅', 44.00, 4489.80, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001920.htm', '2026-02-23 12:23:57.428702', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1664, '景程·湾流汇 3室2厅 110.0平', '孝感-东城区', 110, '3室2厅', 60.00, 5454.55, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001975.htm', '2026-02-23 12:23:57.434359', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1665, '后湖御景 3室2厅 99.0平', '孝感-中心城区', 99, '3室2厅', 33.00, 3333.33, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001942.htm', '2026-02-23 12:23:57.439473', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1666, '全洲桃源 4室2厅 120.0平', '孝感-孝昌', 120, '4室2厅', 43.00, 3583.33, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155975856.htm', '2026-02-23 12:23:57.445119', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1667, '全洲·天悦 3室2厅 121.0平', '孝感-南城区', 121, '3室2厅', 38.79, 3205.79, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001918.htm', '2026-02-23 12:23:57.450531', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1668, '天下公馆 3室2厅 117.0平', '孝感-南大经济开发区', 117, '3室2厅', 55.00, 4700.85, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995646.htm', '2026-02-23 12:23:57.455171', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1669, '星海嘉苑 3室2厅 106.44平', '孝感-北城区', 106.44, '3室2厅', 20.00, 1878.99, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001936.htm', '2026-02-23 12:23:57.460708', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1670, '景程·湾流汇 2室2厅 60.0平', '孝感-东城区', 60, '2室2厅', 27.00, 4500.00, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001956.htm', '2026-02-23 12:23:57.465285', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1671, '巴黎印象西区 3室2厅 124.0平', '孝感-中心城区', 124, '3室2厅', 35.00, 2822.58, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155970348.htm', '2026-02-23 12:23:57.469894', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1672, '三军帅府 3室2厅 137.0平', '孝感-南大经济开发区', 137, '3室2厅', 38.00, 2773.72, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001972.htm', '2026-02-23 12:23:57.475266', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1673, '南桥小区 3室2厅 100.0平', '孝感-南城区', 100, '3室2厅', 19.00, 1900.00, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155993405.htm', '2026-02-23 12:23:57.480828', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1674, '景程·湾流汇 3室2厅 86.0平', '孝感-东城区', 86, '3室2厅', 38.00, 4418.60, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995386.htm', '2026-02-23 12:23:57.485387', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1675, '三军帅府 3室2厅 102.0平', '孝感-南大经济开发区', 102, '3室2厅', 28.00, 2745.10, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155975842.htm', '2026-02-23 12:23:57.490692', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1676, '柳岸春城 3室2厅 118.26平', '孝感-西城区', 118.26, '3室2厅', 43.00, 3636.06, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001919.htm', '2026-02-23 12:23:57.496317', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1677, '香港城·中央广场一期 4室2厅 139.0平', '孝感-南大经济开发区', 139, '4室2厅', 59.00, 4244.60, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155965639.htm', '2026-02-23 12:23:57.502491', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1678, '宇济·滨湖天地 3室2厅 119.64平', '孝感-东城区', 119.64, '3室2厅', 75.00, 6268.81, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155972953.htm', '2026-02-23 12:23:57.507288', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1679, '碧桂园城市之光 3室2厅 108.0平', '孝感-东城区', 108, '3室2厅', 65.00, 6018.52, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001970.htm', '2026-02-23 12:23:57.511521', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1680, '万锦城 2室2厅 92.79平', '孝感-南大经济开发区', 92.79, '2室2厅', 36.50, 3933.61, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155976075.htm', '2026-02-23 12:23:57.517076', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1681, '2008城市花园二期 3室2厅 110.0平', '孝感-北城区', 110, '3室2厅', 20.00, 1818.18, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001939.htm', '2026-02-23 12:23:57.522203', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1682, '三军帅府 3室2厅 102.0平', '孝感-南大经济开发区', 102, '3室2厅', 28.00, 2745.10, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001929.htm', '2026-02-23 12:23:57.527673', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1683, '金苑花园 3室2厅 130.0平', '孝感-中心城区', 130, '3室2厅', 46.00, 3538.46, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155976070.htm', '2026-02-23 12:23:57.531901', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1684, '佳磐瑞府 3室2厅 128.0平', '孝感-东城区', 128, '3室2厅', 72.00, 5625.00, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995355.htm', '2026-02-23 12:23:57.539099', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1685, '澴河盛都 3室2厅 126.0平', '孝感-南城区', 126, '3室2厅', 62.00, 4920.63, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001937.htm', '2026-02-23 12:23:57.543728', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1686, '天下公馆 3室2厅 117.0平', '孝感-南大经济开发区', 117, '3室2厅', 55.00, 4700.85, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001933.htm', '2026-02-23 12:23:57.549603', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1687, '大禹传奇 3室3厅 125.0平', '孝感-南大经济开发区', 125, '3室3厅', 54.00, 4320.00, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001916.htm', '2026-02-23 12:23:57.554823', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1688, '茂繁金叶城 3室2厅 126.0平', '孝感-西城区', 126, '3室2厅', 19.00, 1507.94, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001944.htm', '2026-02-23 12:23:57.560036', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1689, '中建国际花园 3室2厅 114.0平', '孝感-东城区', 114, '3室2厅', 67.00, 5877.19, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155973271.htm', '2026-02-23 12:23:57.564792', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1690, '乾坤阳光 2室2厅 97.0平', '孝感-东城区', 97, '2室2厅', 46.00, 4742.27, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155972812.htm', '2026-02-23 12:23:57.570631', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1691, '御景水岸 2室2厅 99.0平', '孝感-东城区', 99, '2室2厅', 53.00, 5353.54, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001968.htm', '2026-02-23 12:23:57.575103', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1692, '2008城市花园二期 3室2厅 133.0平', '孝感-北城区', 133, '3室2厅', 22.00, 1654.14, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001943.htm', '2026-02-23 12:23:57.580806', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1693, '赛达康城 3室2厅 120.0平', '孝感-东城区', 120, '3室2厅', 53.00, 4416.67, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001958.htm', '2026-02-23 12:23:57.585510', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1694, '华厦龙城 3室2厅 108.0平', '孝感-北城区', 108, '3室2厅', 38.00, 3518.52, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155970698.htm', '2026-02-23 12:23:57.590729', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1695, '状元楼 3室2厅 138.0平', '孝感-中心城区', 138, '3室2厅', 30.00, 2173.91, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001912.htm', '2026-02-23 12:23:57.596264', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1696, '北辰花园 3室2厅 130.0平', '孝感-北城区', 130, '3室2厅', 36.00, 2769.23, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001910.htm', '2026-02-23 12:23:57.601141', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1697, '佳磐瑞府 3室2厅 93.0平', '孝感-中心城区', 93, '3室2厅', 52.00, 5591.40, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155993406.htm', '2026-02-23 12:23:57.605817', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1698, '新宏基站前壹号公馆 2室2厅 95.0平', '孝感-北城区', 95, '2室2厅', 13.50, 1421.05, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001960.htm', '2026-02-23 12:23:57.613276', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1699, '全洲·天悦 3室2厅 121.0平', '孝感-南城区', 121, '3室2厅', 38.80, 3206.61, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155970545.htm', '2026-02-23 12:23:57.618941', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1700, '远大商住楼 2室2厅 99.7平', '孝感-孝南', 99.7, '2室2厅', 18.00, 1805.42, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155951298.htm', '2026-02-23 12:23:57.623843', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1701, '远大商住楼 2室2厅 99.69平', '孝感-孝南', 99.69, '2室2厅', 18.00, 1805.60, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001930.htm', '2026-02-23 12:23:57.628624', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1702, '景程·湾流汇 2室2厅 59.5平', '孝感-东城区', 59.5, '2室2厅', 28.00, 4705.88, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995344.htm', '2026-02-23 12:23:57.633803', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1703, '碧桂园桃源 4室2厅 141.0平', '孝感-南大经济开发区', 141, '4室2厅', 69.00, 4893.62, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155964719.htm', '2026-02-23 12:23:57.639210', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1704, '碧桂园桃源 4室2厅 141.0平', '孝感-南大经济开发区', 141, '4室2厅', 69.00, 4893.62, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001908.htm', '2026-02-23 12:23:57.644617', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1705, '巴黎印象西区 4室2厅 130.0平', '孝感-中心城区', 130, '4室2厅', 20.00, 1538.46, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001935.htm', '2026-02-23 12:23:57.650318', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1706, '南大幸福家园 3室2厅 124.0平', '孝感-南大经济开发区', 124, '3室2厅', 35.00, 2822.58, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155993886.htm', '2026-02-23 12:23:57.655814', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1707, '巴黎印象西区 2室2厅 86.0平', '孝感-中心城区', 86, '2室2厅', 25.00, 2906.98, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155976080.htm', '2026-02-23 12:23:57.660954', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1708, '阳光鑫城 3室2厅 126.0平', '孝感-西城区', 126, '3室2厅', 11.00, 873.02, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001950.htm', '2026-02-23 12:23:57.666265', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1709, '金苑花园 3室2厅 130.0平', '孝感-中心城区', 130, '3室2厅', 46.00, 3538.46, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001925.htm', '2026-02-23 12:23:57.671511', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1710, '协丰温哥华 3室2厅 96.0平', '孝感-东城区', 96, '3室2厅', 66.00, 6875.00, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155995352.htm', '2026-02-23 12:23:57.676604', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1711, '汉光小区 2室1厅 64.0平', '孝感-中心城区', 64, '2室1厅', 23.00, 3593.75, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155993403.htm', '2026-02-23 12:23:57.681580', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1712, '远大商住楼 2室2厅 99.7平', '孝感-孝南', 99.7, '2室2厅', 19.00, 1905.72, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155951133.htm', '2026-02-23 12:23:57.686841', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1713, '福星城 3室2厅 126.0平', '孝感-西湖大道', 126, '3室2厅', 52.00, 4126.98, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001969.htm', '2026-02-23 12:23:57.691508', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1714, '体育西路北小区 3室2厅 126.0平', '孝感-中心城区', 126, '3室2厅', 21.00, 1666.67, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001964.htm', '2026-02-23 12:23:57.696628', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1715, '宝成佳园 3室2厅 125.0平', '孝感-西城区', 125, '3室2厅', 26.80, 2144.00, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155994997.htm', '2026-02-23 12:23:57.701623', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1716, '金利来 2室2厅 104.0平', '孝感-中心城区', 104, '2室2厅', 20.00, 1923.08, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155993889.htm', '2026-02-23 12:23:57.706625', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1717, '南大幸福家园 3室2厅 124.0平', '孝感-南大经济开发区', 124, '3室2厅', 35.00, 2822.58, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_156001914.htm', '2026-02-23 12:23:57.712204', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1718, '保丽佳园 3室2厅 123.0平', '孝感-东城区', 123, '3室2厅', 58.00, 4715.45, 'Fang', 'https://xiaogan.esf.fang.com/chushou/3_155971177.htm', '2026-02-23 12:23:57.717214', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1719, '万科汉口传奇悦庭 3室2厅 120.95平', '江汉-红旗渠常青路', 120.95, '3室2厅', 148.00, 12236.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202123038.htm', '2026-02-23 12:33:10.439858', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1720, '泛海国际芸海园 2室2厅 89.55平', '江汉-王家墩CBD', 89.55, '2室2厅', 150.00, 16750.42, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202336853.htm', '2026-02-23 12:33:10.444981', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1721, '万科城 3室2厅 115.01平', '江汉-红旗渠常青路', 115.01, '3室2厅', 145.00, 12607.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333074.htm', '2026-02-23 12:33:10.450566', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1722, '盛世江城 3室2厅 115.15平', '江汉-红旗渠常青路', 115.15, '3室2厅', 179.00, 15544.94, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333128.htm', '2026-02-23 12:33:10.456722', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1723, '万科汉口传奇悦庭 3室2厅 115.51平', '江汉-红旗渠常青路', 115.51, '3室2厅', 170.00, 14717.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331377.htm', '2026-02-23 12:33:10.462364', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1724, '融创玖玺臺 4室2厅 142.31平', '江汉-范湖西北湖', 142.31, '4室2厅', 295.00, 20729.39, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341157.htm', '2026-02-23 12:33:10.467517', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1725, '泛海国际居住区兰海园 4室3厅 305.91平', '江汉-王家墩CBD', 305.91, '4室3厅', 680.00, 22228.76, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202295932.htm', '2026-02-23 12:33:10.473799', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1726, '世纪江尚 4室2厅 185.68平', '江汉-江汉路', 185.68, '4室2厅', 420.00, 22619.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202320791.htm', '2026-02-23 12:33:10.478325', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1727, '世纪江尚 4室2厅 185.68平', '江汉-江汉路', 185.68, '4室2厅', 330.00, 17772.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352478.htm', '2026-02-23 12:33:10.484360', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1728, '金融街·恒江雅筑 3室2厅 116.0平', '江汉-塔子湖', 116, '3室2厅', 148.00, 12758.62, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202313719.htm', '2026-02-23 12:33:10.488909', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1729, '万科公园5号 3室2厅 115.0平', '江汉-塔子湖', 115, '3室2厅', 179.00, 15565.22, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331304.htm', '2026-02-23 12:33:10.494018', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1730, '泛海国际芸海园 3室2厅 115.42平', '江汉-王家墩CBD', 115.42, '3室2厅', 230.00, 19927.22, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331402.htm', '2026-02-23 12:33:10.499649', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1731, '万科公园5号 3室2厅 115.0平', '江汉-塔子湖', 115, '3室2厅', 155.00, 13478.26, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201229717.htm', '2026-02-23 12:33:10.504617', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1732, '绿城·湖畔雲庐 4室2厅 172.0平', '江汉-王家墩CBD', 172, '4室2厅', 400.00, 23255.81, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202103837.htm', '2026-02-23 12:33:10.509914', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1733, '盛世江城 3室2厅 96.68平', '江汉-红旗渠常青路', 96.68, '3室2厅', 142.00, 14687.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202281389.htm', '2026-02-23 12:33:10.514629', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1734, '武汉江城府 3室2厅 122.0平', '江汉-友谊路', 122, '3室2厅', 290.00, 23770.49, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202138761.htm', '2026-02-23 12:33:10.519753', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1735, '武汉江城府 3室2厅 122.0平', '江汉-友谊路', 122, '3室2厅', 305.60, 25049.18, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202189263.htm', '2026-02-23 12:33:10.525897', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1736, '顶琇国际城 3室2厅 118.04平', '江汉-红旗渠常青路', 118.04, '3室2厅', 150.00, 12707.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331307.htm', '2026-02-23 12:33:10.532108', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1737, '绿城·湖畔雲庐 4室2厅 172.0平', '江汉-王家墩CBD', 172, '4室2厅', 375.00, 21802.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379666.htm', '2026-02-23 12:33:10.536297', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1738, '世纪江尚 3室2厅 160.28平', '江汉-江汉路', 160.28, '3室2厅', 280.00, 17469.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363153.htm', '2026-02-23 12:33:10.542068', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1739, '金融街·恒江雅筑 3室2厅 123.11平', '江汉-塔子湖', 123.11, '3室2厅', 159.00, 12915.28, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202313731.htm', '2026-02-23 12:33:10.547703', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1740, '金融街·恒江雅筑 3室2厅 123.2平', '江汉-塔子湖', 123.2, '3室2厅', 160.00, 12987.01, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202313726.htm', '2026-02-23 12:33:10.552235', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1741, '葛洲坝国际广场 2室2厅 107.42平', '江汉-范湖西北湖', 107.42, '2室2厅', 190.00, 17687.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331351.htm', '2026-02-23 12:33:10.557340', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1742, '盛世江城 3室2厅 109.61平', '江汉-红旗渠常青路', 109.61, '3室2厅', 170.00, 15509.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333127.htm', '2026-02-23 12:33:10.561871', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1743, '越秀国际金融汇 3室2厅 108.47平', '江汉-武广万松园', 108.47, '3室2厅', 235.00, 21664.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202277150.htm', '2026-02-23 12:33:10.567914', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1744, '武汉江城府 4室2厅 160.0平', '江汉-友谊路', 160, '4室2厅', 240.00, 15000.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201508851.htm', '2026-02-23 12:33:10.572451', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1745, '武汉城建·中央雲璟 3室2厅 144.0平', '江汉-唐家墩', 144, '3室2厅', 295.00, 20486.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202103941.htm', '2026-02-23 12:33:10.578153', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1746, '世纪江尚 4室2厅 185.59平', '江汉-江汉路', 185.59, '4室2厅', 358.00, 19289.83, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363151.htm', '2026-02-23 12:33:10.583514', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1747, '武汉江城府 3室2厅 142.0平', '江汉-友谊路', 142, '3室2厅', 310.00, 21830.99, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202196472.htm', '2026-02-23 12:33:10.589529', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1748, '中城悦城 3室2厅 117.22平', '江汉-复兴村常码头', 117.22, '3室2厅', 182.00, 15526.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353848.htm', '2026-02-23 12:33:10.594775', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1749, '武汉江城府 4室2厅 160.0平', '江汉-友谊路', 160, '4室2厅', 356.20, 22262.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182985.htm', '2026-02-23 12:33:10.600929', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1750, '武汉江城府 4室2厅 180.0平', '江汉-友谊路', 180, '4室2厅', 396.50, 22027.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182969.htm', '2026-02-23 12:33:10.605975', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1751, '顶琇国际城 3室2厅 93.0平', '江汉-红旗渠常青路', 93, '3室2厅', 158.00, 16989.25, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202304302.htm', '2026-02-23 12:33:10.611524', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1752, '武汉江城府 4室2厅 180.0平', '江汉-友谊路', 180, '4室2厅', 260.00, 14444.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201508852.htm', '2026-02-23 12:33:10.617077', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1753, '武汉江城府 3室2厅 125.0平', '江汉-友谊路', 125, '3室2厅', 280.20, 22416.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202189200.htm', '2026-02-23 12:33:10.621610', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1754, '金融街·恒江雅筑 3室2厅 123.0平', '江汉-塔子湖', 123, '3室2厅', 158.00, 12845.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202313733.htm', '2026-02-23 12:33:10.627653', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1755, '泛海桂府 3室2厅 132.47平', '江汉-王家墩CBD', 132.47, '3室2厅', 249.00, 18796.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325271.htm', '2026-02-23 12:33:10.633193', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1756, '福星华府·琛境 3室2厅 129.0平', '江汉-红旗渠常青路', 129, '3室2厅', 150.00, 11627.91, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366054.htm', '2026-02-23 12:33:10.637674', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1757, '金融街·恒江雅筑 3室2厅 123.0平', '江汉-塔子湖', 123, '3室2厅', 190.00, 15447.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202338893.htm', '2026-02-23 12:33:10.642670', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1758, '武汉江城府 4室2厅 180.0平', '江汉-友谊路', 180, '4室2厅', 280.00, 15555.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202138764.htm', '2026-02-23 12:33:10.648382', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1759, '武汉江城府 3室2厅 142.0平', '江汉-友谊路', 142, '3室2厅', 312.00, 21971.83, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202196468.htm', '2026-02-23 12:33:10.654595', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1760, '武汉江城府 4室2厅 160.0平', '江汉-友谊路', 160, '4室2厅', 270.00, 16875.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202138765.htm', '2026-02-23 12:33:10.660433', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1761, '顶琇国际城 3室2厅 117.0平', '江汉-红旗渠常青路', 117, '3室2厅', 148.00, 12649.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331305.htm', '2026-02-23 12:33:10.665481', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1762, '华发外滩荟 4室2厅 206.0平', '江汉-江汉路', 206, '4室2厅', 880.00, 42718.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202271083.htm', '2026-02-23 12:33:10.671555', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1763, '锦绣人家 3室2厅 114.97平', '江汉-红旗渠常青路', 114.97, '3室2厅', 115.00, 10002.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202305310.htm', '2026-02-23 12:33:10.677110', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1764, '武汉江城府 4室2厅 180.0平', '江汉-友谊路', 180, '4室2厅', 396.50, 22027.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202138769.htm', '2026-02-23 12:33:10.682788', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1765, '武汉江城府 4室2厅 160.2平', '江汉-友谊路', 160.2, '4室2厅', 352.90, 22028.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182990.htm', '2026-02-23 12:33:10.690105', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1766, '武汉江城府 3室2厅 127.0平', '江汉-友谊路', 127, '3室2厅', 279.80, 22031.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202196475.htm', '2026-02-23 12:33:10.696437', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1767, '盛世江城 2室2厅 96.03平', '江汉-红旗渠常青路', 96.03, '2室2厅', 128.00, 13329.17, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333122.htm', '2026-02-23 12:33:10.701495', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1768, '西北湖壹号御玺湾 5室2厅 318.01平', '江汉-范湖西北湖', 318.01, '5室2厅', 1700.00, 53457.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202320535.htm', '2026-02-23 12:33:10.707970', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1769, '泛海国际芸海园 3室2厅 148.85平', '江汉-王家墩CBD', 148.85, '3室2厅', 238.00, 15989.25, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363182.htm', '2026-02-23 12:33:10.713307', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1770, '君荟天地 3室1厅 101.42平', '江汉-塔子湖', 101.42, '3室1厅', 150.00, 14789.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202327561.htm', '2026-02-23 12:33:10.719404', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1771, '武汉城建·中央雲璟 3室2厅 144.0平', '江汉-唐家墩', 144, '3室2厅', 420.00, 29166.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202271089.htm', '2026-02-23 12:33:10.725446', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1772, '万科公园5号 3室2厅 123.0平', '江汉-塔子湖', 123, '3室2厅', 165.00, 13414.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200454448.htm', '2026-02-23 12:33:10.730481', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1773, '金融街·恒江雅筑 3室2厅 123.0平', '江汉-塔子湖', 123, '3室2厅', 189.00, 15365.85, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202285878.htm', '2026-02-23 12:33:10.736007', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1774, '泛海桂府 3室2厅 132.47平', '江汉-王家墩CBD', 132.47, '3室2厅', 238.00, 17966.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325329.htm', '2026-02-23 12:33:10.740567', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1775, '金融街·恒江雅筑 3室2厅 123.0平', '江汉-塔子湖', 123, '3室2厅', 158.00, 12845.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202305296.htm', '2026-02-23 12:33:10.745603', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1776, '新华家园 3室2厅 143.55平', '江汉-红旗渠常青路', 143.55, '3室2厅', 135.00, 9404.39, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373297.htm', '2026-02-23 12:33:10.750239', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1777, '远洋心里 2室1厅 78.32平', '江汉-红旗渠常青路', 78.32, '2室1厅', 82.00, 10469.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373301.htm', '2026-02-23 12:33:10.755402', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1778, '阳光花园 3室2厅 91.01平', '江汉-红旗渠常青路', 91.01, '3室2厅', 98.00, 10768.05, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373213.htm', '2026-02-23 12:33:10.761106', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1779, '万科汉口传奇唐樾 3室2厅 118.01平', '江汉-红旗渠常青路', 118.01, '3室2厅', 170.00, 14405.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373302.htm', '2026-02-23 12:33:10.765804', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1780, '远洋万和四季 4室2厅 141.08平', '江汉-复兴村常码头', 141.08, '4室2厅', 196.00, 13892.83, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374620.htm', '2026-02-23 12:33:10.770887', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1781, '金色雅园金源苑 3室2厅 151.0平', '江汉-红旗渠常青路', 151, '3室2厅', 170.00, 11258.28, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379715.htm', '2026-02-23 12:33:10.775447', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1782, '金色雅园金涛苑 3室2厅 132.75平', '江汉-红旗渠常青路', 132.75, '3室2厅', 180.00, 13559.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380199.htm', '2026-02-23 12:33:10.781135', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1783, '远洋万和四季 3室2厅 118.25平', '江汉-复兴村常码头', 118.25, '3室2厅', 158.00, 13361.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374630.htm', '2026-02-23 12:33:10.786690', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1784, '福星惠誉福星华府 3室2厅 89.03平', '江汉-红旗渠常青路', 89.03, '3室2厅', 98.00, 11007.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368775.htm', '2026-02-23 12:33:10.791742', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1785, '万科城 2室2厅 83.59平', '江汉-红旗渠常青路', 83.59, '2室2厅', 100.00, 11963.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373218.htm', '2026-02-23 12:33:10.795851', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1786, '华发中城荟中央首府 3室2厅 109.36平', '江汉-王家墩CBD', 109.36, '3室2厅', 245.00, 22403.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202371283.htm', '2026-02-23 12:33:10.801448', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1787, '新华家园悦景居 3室2厅 97.38平', '江汉-红旗渠常青路', 97.38, '3室2厅', 147.00, 15095.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374559.htm', '2026-02-23 12:33:10.806645', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1788, '阳光新苑 2室2厅 94.49平', '江汉-红旗渠常青路', 94.49, '2室2厅', 96.00, 10159.81, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373203.htm', '2026-02-23 12:33:10.811211', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1789, '福星惠誉福星华府·峯 2室1厅 83.24平', '江汉-塔子湖', 83.24, '2室1厅', 95.00, 11412.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373235.htm', '2026-02-23 12:33:10.815778', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1790, '万科汉口传奇 3室2厅 95.86平', '江汉-红旗渠常青路', 95.86, '3室2厅', 108.00, 11266.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202370686.htm', '2026-02-23 12:33:10.821360', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1791, '盛世江城 3室2厅 119.07平', '江汉-红旗渠常青路', 119.07, '3室2厅', 175.00, 14697.24, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372684.htm', '2026-02-23 12:33:10.825914', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1792, '博海名居 3室2厅 139.57平', '江汉-红旗渠常青路', 139.57, '3室2厅', 120.00, 8597.84, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379716.htm', '2026-02-23 12:33:10.831115', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1793, '万科城 4室2厅 173.37平', '江汉-红旗渠常青路', 173.37, '4室2厅', 200.00, 11536.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372721.htm', '2026-02-23 12:33:10.836156', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1794, '盛世江城 3室2厅 126.4平', '江汉-红旗渠常青路', 126.4, '3室2厅', 169.00, 13370.25, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374554.htm', '2026-02-23 12:33:10.840907', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1795, '华发中城荟中央首府 3室2厅 107.65平', '江汉-王家墩CBD', 107.65, '3室2厅', 289.00, 26846.26, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202371273.htm', '2026-02-23 12:33:10.845962', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1796, '顶琇国际公馆 3室2厅 108.59平', '江汉-红旗渠常青路', 108.59, '3室2厅', 107.00, 9853.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369608.htm', '2026-02-23 12:33:10.850494', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1797, '金色雅园金沙苑 3室2厅 116.55平', '江汉-红旗渠常青路', 116.55, '3室2厅', 185.00, 15873.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374709.htm', '2026-02-23 12:33:10.855598', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1798, '新世界常青南园 2室2厅 95.01平', '江汉-红旗渠常青路', 95.01, '2室2厅', 156.00, 16419.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202380213.htm', '2026-02-23 12:33:10.860832', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1799, '世纪江尚 2室2厅 89.62平', '江汉-江汉路', 89.62, '2室2厅', 190.00, 21200.62, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368783.htm', '2026-02-23 12:33:10.865090', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1800, '泛海国际芸海园 4室2厅 285.98平', '江汉-王家墩CBD', 285.98, '4室2厅', 640.00, 22379.19, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201734098.htm', '2026-02-23 12:33:10.870373', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1801, '融创融公馆二期 3室2厅 115.19平', '江汉-塔子湖', 115.19, '3室2厅', 158.00, 13716.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372653.htm', '2026-02-23 12:33:10.875080', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1802, '金色雅园金涛苑 3室2厅 159.54平', '江汉-红旗渠常青路', 159.54, '3室2厅', 235.00, 14729.85, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368789.htm', '2026-02-23 12:33:10.879751', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1803, '融创融公馆二期 3室2厅 123.64平', '江汉-塔子湖', 123.64, '3室2厅', 166.00, 13426.08, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372730.htm', '2026-02-23 12:33:10.885557', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1804, '城开汉口秀园 3室2厅 117.48平', '江汉-塔子湖', 117.48, '3室2厅', 122.00, 10384.75, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368717.htm', '2026-02-23 12:33:10.890091', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1805, '盛世江城 3室1厅 95.67平', '江汉-红旗渠常青路', 95.67, '3室1厅', 160.00, 16724.16, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373275.htm', '2026-02-23 12:33:10.895204', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1806, '阳光花园益康苑 3室2厅 124.5平', '江汉-红旗渠常青路', 124.5, '3室2厅', 129.00, 10361.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202371272.htm', '2026-02-23 12:33:10.900781', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1807, '万科汉口传奇锦棠 3室2厅 143.33平', '江汉-红旗渠常青路', 143.33, '3室2厅', 268.00, 18698.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373293.htm', '2026-02-23 12:33:10.905841', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1808, '新华家园悦景居 2室2厅 95.18平', '江汉-红旗渠常青路', 95.18, '2室2厅', 128.00, 13448.20, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373209.htm', '2026-02-23 12:33:10.910878', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1809, '华发中城荟 4室2厅 239.3平', '江汉-王家墩CBD', 239.3, '4室2厅', 780.00, 32595.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340587.htm', '2026-02-23 12:33:10.915489', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1810, '中城悦城 3室1厅 95.72平', '江汉-复兴村常码头', 95.72, '3室1厅', 188.00, 19640.62, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372676.htm', '2026-02-23 12:33:10.920631', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1811, '福星惠誉福星华府 2室2厅 88.15平', '江汉-红旗渠常青路', 88.15, '2室2厅', 106.00, 12024.96, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368821.htm', '2026-02-23 12:33:10.925669', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1812, '远洋心里 2室1厅 79.35平', '江汉-红旗渠常青路', 79.35, '2室1厅', 89.00, 11216.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374556.htm', '2026-02-23 12:33:10.930198', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1813, '万科汉口传奇悦庭 2室2厅 70.16平', '江汉-红旗渠常青路', 70.16, '2室2厅', 109.00, 15535.92, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372723.htm', '2026-02-23 12:33:10.935741', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1814, '万科汉口传奇唐樾 4室2厅 141.72平', '江汉-红旗渠常青路', 141.72, '4室2厅', 255.00, 17993.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373295.htm', '2026-02-23 12:33:10.940555', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1815, '泛海国际桂海园 3室2厅 144.67平', '江汉-王家墩CBD', 144.67, '3室2厅', 270.00, 18663.16, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341256.htm', '2026-02-23 12:33:10.945592', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1816, '新华家园 2室2厅 120.7平', '江汉-红旗渠常青路', 120.7, '2室2厅', 99.00, 8202.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372724.htm', '2026-02-23 12:33:10.950751', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1817, '华发中城荟 3室2厅 143.7平', '江汉-王家墩CBD', 143.7, '3室2厅', 400.00, 27835.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368797.htm', '2026-02-23 12:33:10.956140', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1818, '泛海国际芸海园 4室2厅 208.23平', '江汉-王家墩CBD', 208.23, '4室2厅', 420.00, 20170.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372734.htm', '2026-02-23 12:33:10.961360', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1819, '泛海国际芸海园 4室2厅 167.63平', '江汉-王家墩CBD', 167.63, '4室2厅', 370.00, 22072.42, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201714960.htm', '2026-02-23 12:33:10.967407', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1820, '华发中城荟 4室2厅 289.89平', '江汉-王家墩CBD', 289.89, '4室2厅', 1200.00, 41395.01, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340567.htm', '2026-02-23 12:33:10.972249', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1821, '华发中城荟中央首府 3室2厅 109.36平', '江汉-王家墩CBD', 109.36, '3室2厅', 230.00, 21031.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340535.htm', '2026-02-23 12:33:10.976327', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1822, '锦绣人家 3室2厅 136.14平', '江汉-红旗渠常青路', 136.14, '3室2厅', 129.00, 9475.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374537.htm', '2026-02-23 12:33:10.981458', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1823, '新华家园悦景居 2室2厅 96.48平', '江汉-红旗渠常青路', 96.48, '2室2厅', 148.00, 15339.97, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373234.htm', '2026-02-23 12:33:10.986279', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1824, '中海万松九里 5室2厅 229.79平', '江汉-武广万松园', 229.79, '5室2厅', 580.00, 25240.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202195670.htm', '2026-02-23 12:33:10.990837', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1825, '泛海国际居住区兰海园 4室2厅 285.98平', '江汉-王家墩CBD', 285.98, '4室2厅', 715.00, 25001.75, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341658.htm', '2026-02-23 12:33:10.996380', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1826, '福星惠誉福星城 3室2厅 132.57平', '江汉-红旗渠常青路', 132.57, '3室2厅', 168.00, 12672.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372670.htm', '2026-02-23 12:33:11.002473', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1827, '万科汉口传奇锦棠 3室1厅 122.95平', '江汉-红旗渠常青路', 122.95, '3室1厅', 210.00, 17080.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372722.htm', '2026-02-23 12:33:11.007711', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1828, '泛海国际香海园 5室2厅 306.27平', '江汉-复兴村常码头', 306.27, '5室2厅', 790.00, 25794.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201712797.htm', '2026-02-23 12:33:11.012750', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1829, '民航小区 3室2厅 129.17平', '江汉-红旗渠常青路', 129.17, '3室2厅', 98.00, 7586.90, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201309302.htm', '2026-02-23 12:33:11.017822', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1830, '泛海国际松海园 2室2厅 95.64平', '江汉-王家墩CBD', 95.64, '2室2厅', 190.00, 19866.16, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341374.htm', '2026-02-23 12:33:11.023045', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1831, '锦绣人家 3室2厅 138.67平', '江汉-红旗渠常青路', 138.67, '3室2厅', 138.00, 9951.68, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373277.htm', '2026-02-23 12:33:11.028085', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1832, '泛海国际芸海园 3室2厅 148.85平', '江汉-王家墩CBD', 148.85, '3室2厅', 259.00, 17400.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341349.htm', '2026-02-23 12:33:11.033410', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1833, '江汉市政小区 2室2厅 143.7平', '江汉-红旗渠常青路', 143.7, '2室2厅', 115.00, 8002.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373305.htm', '2026-02-23 12:33:11.038484', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1834, '远洋心语 3室2厅 103.34平', '江汉-复兴村常码头', 103.34, '3室2厅', 105.00, 10160.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373199.htm', '2026-02-23 12:33:11.043577', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1835, '万科汉口传奇悦庭 3室2厅 123.6平', '江汉-红旗渠常青路', 123.6, '3室2厅', 162.00, 13106.80, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373292.htm', '2026-02-23 12:33:11.048705', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1836, '泛海国际居住区樱海园 3室2厅 171.99平', '江汉-王家墩CBD', 171.99, '3室2厅', 380.00, 22094.31, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341582.htm', '2026-02-23 12:33:11.054167', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1837, '东方名都 3室2厅 103.17平', '江汉-红旗渠常青路', 103.17, '3室2厅', 88.00, 8529.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372700.htm', '2026-02-23 12:33:11.059760', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1838, '泛海国际香海园 4室2厅 306.27平', '江汉-复兴村常码头', 306.27, '4室2厅', 800.00, 26120.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201712792.htm', '2026-02-23 12:33:11.065020', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1839, '泛海国际碧海园 4室2厅 260.15平', '江汉-王家墩CBD', 260.15, '4室2厅', 660.00, 25369.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340600.htm', '2026-02-23 12:33:11.069200', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1840, '万科汉口传奇唐樾 3室2厅 120.79平', '江汉-红旗渠常青路', 120.79, '3室2厅', 228.00, 18875.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374666.htm', '2026-02-23 12:33:11.074748', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1841, '泛海国际居住区樱海园 3室2厅 128.62平', '江汉-王家墩CBD', 128.62, '3室2厅', 285.00, 22158.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369524.htm', '2026-02-23 12:33:11.079830', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1842, '华发中城荟中央首府 4室2厅 137.95平', '江汉-王家墩CBD', 137.95, '4室2厅', 330.00, 23921.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372776.htm', '2026-02-23 12:33:11.084918', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1843, '融创融公馆二期 3室2厅 113.71平', '江汉-塔子湖', 113.71, '3室2厅', 136.00, 11960.25, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373212.htm', '2026-02-23 12:33:11.089449', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1844, '新华家园悦景居 3室2厅 153.54平', '江汉-红旗渠常青路', 153.54, '3室2厅', 210.00, 13677.22, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368702.htm', '2026-02-23 12:33:11.094722', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1845, '泛海国际桂海园 5室2厅 220.41平', '江汉-王家墩CBD', 220.41, '5室2厅', 650.00, 29490.49, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341248.htm', '2026-02-23 12:33:11.099257', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1846, '华发中城荟中央首府 4室2厅 169.24平', '江汉-王家墩CBD', 169.24, '4室2厅', 480.00, 28362.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374708.htm', '2026-02-23 12:33:11.104793', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1847, 'CBD楚世家 4室2厅 215.29平', '江汉-王家墩CBD', 215.29, '4室2厅', 440.00, 20437.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201734131.htm', '2026-02-23 12:33:11.110340', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1848, '泛海国际桂海园 3室2厅 144.19平', '江汉-王家墩CBD', 144.19, '3室2厅', 310.00, 21499.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341307.htm', '2026-02-23 12:33:11.114890', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1849, '泛海国际松海园 3室2厅 138.33平', '江汉-王家墩CBD', 138.33, '3室2厅', 340.00, 24578.91, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341380.htm', '2026-02-23 12:33:11.120437', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1850, '盛世江城 3室2厅 119.54平', '江汉-红旗渠常青路', 119.54, '3室2厅', 178.00, 14890.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368799.htm', '2026-02-23 12:33:11.124645', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1851, '万科城 3室2厅 119.29平', '江汉-红旗渠常青路', 119.29, '3室2厅', 143.00, 11987.59, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379769.htm', '2026-02-23 12:33:11.129820', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1852, '金色雅园金源苑 4室2厅 159.31平', '江汉-红旗渠常青路', 159.31, '4室2厅', 288.00, 18077.96, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374602.htm', '2026-02-23 12:33:11.135479', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1853, '世纪江尚 4室2厅 185.68平', '江汉-江汉路', 185.68, '4室2厅', 420.00, 22619.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372737.htm', '2026-02-23 12:33:11.146095', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1854, '中城悦城 3室1厅 95.69平', '江汉-复兴村常码头', 95.69, '3室1厅', 186.00, 19437.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374683.htm', '2026-02-23 12:33:11.165870', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1855, '万科汉口传奇悦庭 3室2厅 120.59平', '江汉-红旗渠常青路', 120.59, '3室2厅', 210.00, 17414.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372657.htm', '2026-02-23 12:33:11.176247', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1856, '中海万松九里 5室2厅 230.74平', '江汉-武广万松园', 230.74, '5室2厅', 750.00, 32504.12, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202192237.htm', '2026-02-23 12:33:11.187335', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1857, '华发中城荟 4室2厅 185.2平', '江汉-王家墩CBD', 185.2, '4室2厅', 610.00, 32937.37, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368753.htm', '2026-02-23 12:33:11.197649', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1858, '华发中城荟中央首府 4室2厅 137.76平', '江汉-王家墩CBD', 137.76, '4室2厅', 410.00, 29761.90, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368813.htm', '2026-02-23 12:33:11.211479', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1859, '泛海国际居住区兰海园 4室3厅 260.36平', '江汉-王家墩CBD', 260.36, '4室3厅', 680.00, 26117.68, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341142.htm', '2026-02-23 12:33:11.221591', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1860, '福星惠誉福星华府·峯 4室2厅 141.29平', '江汉-塔子湖', 141.29, '4室2厅', 145.00, 10262.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368842.htm', '2026-02-23 12:33:11.232278', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1861, '金色雅园金池苑 3室2厅 142.18平', '江汉-红旗渠常青路', 142.18, '3室2厅', 235.00, 16528.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374043.htm', '2026-02-23 12:33:11.245000', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1862, '万科城 2室1厅 71.43平', '江汉-红旗渠常青路', 71.43, '2室1厅', 83.00, 11619.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202116221.htm', '2026-02-23 12:33:11.255676', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1863, '泛海国际居住区樱海园 3室2厅 123.45平', '江汉-王家墩CBD', 123.45, '3室2厅', 240.00, 19441.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341637.htm', '2026-02-23 12:33:11.266377', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1864, '锦绣人家 1室1厅 63.3平', '江汉-红旗渠常青路', 63.3, '1室1厅', 90.00, 14218.01, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374072.htm', '2026-02-23 12:33:11.276998', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1865, '锦绣人家 3室2厅 149.81平', '江汉-红旗渠常青路', 149.81, '3室2厅', 138.00, 9211.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202252875.htm', '2026-02-23 12:33:11.291771', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1866, '锦绣人家 3室2厅 123.55平', '江汉-红旗渠常青路', 123.55, '3室2厅', 120.00, 9712.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202094566.htm', '2026-02-23 12:33:11.304956', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1867, '盛世江城 2室2厅 96.03平', '江汉-红旗渠常青路', 96.03, '2室2厅', 139.00, 14474.64, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368747.htm', '2026-02-23 12:33:11.317263', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1868, '迎宾花园 3室2厅 177.91平', '江汉-红旗渠常青路', 177.91, '3室2厅', 140.00, 7869.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202132294.htm', '2026-02-23 12:33:11.324381', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1869, '新华家园 3室1厅 120.7平', '江汉-红旗渠常青路', 120.7, '3室1厅', 99.00, 8202.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368774.htm', '2026-02-23 12:33:11.334857', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1870, '新世界常青南园 2室2厅 94.72平', '江汉-红旗渠常青路', 94.72, '2室2厅', 160.00, 16891.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202094564.htm', '2026-02-23 12:33:11.344477', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1871, '福星惠誉福星华府 3室2厅 121.64平', '江汉-红旗渠常青路', 121.64, '3室2厅', 150.00, 12331.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372621.htm', '2026-02-23 12:33:11.353319', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1872, '盛世江城 3室2厅 108.59平', '江汉-红旗渠常青路', 108.59, '3室2厅', 160.00, 14734.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202277004.htm', '2026-02-23 12:33:11.358365', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1873, '泛海国际居住区樱海园 3室2厅 128.62平', '江汉-王家墩CBD', 128.62, '3室2厅', 285.00, 22158.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366351.htm', '2026-02-23 12:33:11.364426', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1874, '福星华府东区 3室2厅 83.66平', '江汉-红旗渠常青路', 83.66, '3室2厅', 87.00, 10399.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202229135.htm', '2026-02-23 12:33:11.369551', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1875, '融创融公馆二期 3室2厅 122.39平', '江汉-塔子湖', 122.39, '3室2厅', 178.00, 14543.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378049.htm', '2026-02-23 12:33:11.378357', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1876, '金色雅园金涛苑 3室2厅 158.27平', '江汉-红旗渠常青路', 158.27, '3室2厅', 230.00, 14532.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374036.htm', '2026-02-23 12:33:11.383937', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1877, '万科汉口传奇唐樾 3室2厅 91.85平', '江汉-红旗渠常青路', 91.85, '3室2厅', 207.00, 22536.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201143820.htm', '2026-02-23 12:33:11.388346', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1878, '文锦苑 2室2厅 101.59平', '江汉-红旗渠常青路', 101.59, '2室2厅', 89.00, 8760.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202236636.htm', '2026-02-23 12:33:11.393455', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1879, '民航小区 3室1厅 71.38平', '江汉-红旗渠常青路', 71.38, '3室1厅', 70.00, 9806.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202133259.htm', '2026-02-23 12:33:11.399545', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1880, '常青二垸 2室1厅 71.49平', '江汉-红旗渠常青路', 71.49, '2室1厅', 55.00, 7693.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369478.htm', '2026-02-23 12:33:11.403640', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1881, '福星惠誉福星城 2室2厅 79.6平', '江汉-红旗渠常青路', 79.6, '2室2厅', 74.00, 9296.48, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202375122.htm', '2026-02-23 12:33:11.408697', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1882, '常青二垸 2室1厅 57.78平', '江汉-红旗渠常青路', 57.78, '2室1厅', 38.50, 6663.21, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373085.htm', '2026-02-23 12:33:11.413295', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1883, '阳光新苑 3室2厅 97.3平', '江汉-红旗渠常青路', 97.3, '3室2厅', 85.00, 8735.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202350477.htm', '2026-02-23 12:33:11.417897', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1884, '万科汉口传奇唐樾 4室2厅 142.23平', '江汉-红旗渠常青路', 142.23, '4室2厅', 290.00, 20389.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368644.htm', '2026-02-23 12:33:11.422963', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1885, '盛世江城 3室1厅 127.68平', '江汉-红旗渠常青路', 127.68, '3室1厅', 190.00, 14880.95, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202219469.htm', '2026-02-23 12:33:11.427886', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1886, '绿色家园三期 3室2厅 91.99平', '江汉-红旗渠常青路', 91.99, '3室2厅', 89.00, 9674.96, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202227139.htm', '2026-02-23 12:33:11.433943', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1887, '福星华府誉境 3室2厅 97.6平', '江汉-红旗渠常青路', 97.6, '3室2厅', 125.00, 12807.38, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374612.htm', '2026-02-23 12:33:11.438993', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1888, '顶琇国际公馆 2室2厅 72.34平', '江汉-红旗渠常青路', 72.34, '2室2厅', 82.00, 11335.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378311.htm', '2026-02-23 12:33:11.444075', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1889, '万科城 2室2厅 88.23平', '江汉-红旗渠常青路', 88.23, '2室2厅', 98.00, 11107.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202193398.htm', '2026-02-23 12:33:11.448727', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1890, '福星华府誉境 3室2厅 122.22平', '江汉-红旗渠常青路', 122.22, '3室2厅', 125.00, 10227.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202221906.htm', '2026-02-23 12:33:11.453506', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1891, '阳光新苑 2室2厅 93.69平', '江汉-红旗渠常青路', 93.69, '2室2厅', 83.00, 8859.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201818861.htm', '2026-02-23 12:33:11.458655', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1892, '远洋心里 3室2厅 94.32平', '江汉-红旗渠常青路', 94.32, '3室2厅', 127.00, 13464.80, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366870.htm', '2026-02-23 12:33:11.464222', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1893, '江汉人家 2室2厅 71.87平', '江汉-塔子湖', 71.87, '2室2厅', 75.00, 10435.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200290564.htm', '2026-02-23 12:33:11.468784', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1894, '金色雅园金涛苑 3室2厅 142.4平', '江汉-红旗渠常青路', 142.4, '3室2厅', 225.00, 15800.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373294.htm', '2026-02-23 12:33:11.474899', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1895, '福星华府东区 2室2厅 88.76平', '江汉-红旗渠常青路', 88.76, '2室2厅', 100.00, 11266.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202033411.htm', '2026-02-23 12:33:11.478447', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1896, '泛海国际芸海园 2室2厅 101.07平', '江汉-王家墩CBD', 101.07, '2室2厅', 175.00, 17314.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374575.htm', '2026-02-23 12:33:11.483567', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1897, '阳光花园益康苑 3室2厅 110.52平', '江汉-红旗渠常青路', 110.52, '3室2厅', 168.00, 15200.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202026173.htm', '2026-02-23 12:33:11.490234', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1898, '盛世江城 3室2厅 109.7平', '江汉-红旗渠常青路', 109.7, '3室2厅', 159.00, 14494.07, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202247150.htm', '2026-02-23 12:33:11.496397', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1899, '香缇美景小区 2室2厅 81.23平', '江汉-红旗渠常青路', 81.23, '2室2厅', 59.00, 7263.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378323.htm', '2026-02-23 12:33:11.500485', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1900, '万科城 2室2厅 92.18平', '江汉-红旗渠常青路', 92.18, '2室2厅', 115.00, 12475.59, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200955880.htm', '2026-02-23 12:33:11.506185', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1901, '万科城 2室1厅 71.43平', '江汉-红旗渠常青路', 71.43, '2室1厅', 120.00, 16799.66, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202149656.htm', '2026-02-23 12:33:11.510757', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1902, '顶琇国际公馆 2室2厅 72.34平', '江汉-红旗渠常青路', 72.34, '2室2厅', 82.00, 11335.36, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202222343.htm', '2026-02-23 12:33:11.517244', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1903, '新世界常青南园 3室2厅 131.31平', '江汉-红旗渠常青路', 131.31, '3室2厅', 249.00, 18962.76, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202164271.htm', '2026-02-23 12:33:11.522938', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1904, '万景橘苑 3室2厅 103.75平', '江汉-红旗渠常青路', 103.75, '3室2厅', 135.00, 13012.05, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366338.htm', '2026-02-23 12:33:11.529063', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1905, '盛世江城 3室2厅 119.54平', '江汉-红旗渠常青路', 119.54, '3室2厅', 178.00, 14890.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202272254.htm', '2026-02-23 12:33:11.534193', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1906, '新世界常青南园 2室2厅 94.94平', '江汉-红旗渠常青路', 94.94, '2室2厅', 150.00, 15799.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202273257.htm', '2026-02-23 12:33:11.539249', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1907, '万科城 2室2厅 90.72平', '江汉-红旗渠常青路', 90.72, '2室2厅', 103.00, 11353.62, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202225676.htm', '2026-02-23 12:33:11.545033', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1908, '融创融公馆二期 2室2厅 84.06平', '江汉-塔子湖', 84.06, '2室2厅', 120.00, 14275.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378039.htm', '2026-02-23 12:33:11.549700', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1909, '泛海国际芸海园 3室2厅 134.35平', '江汉-王家墩CBD', 134.35, '3室2厅', 288.00, 21436.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202273848.htm', '2026-02-23 12:33:11.555270', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1910, '阳光新苑 3室2厅 107.18平', '江汉-红旗渠常青路', 107.18, '3室2厅', 100.00, 9330.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202191636.htm', '2026-02-23 12:33:11.560047', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1911, '中城悦城 3室2厅 119.58平', '江汉-复兴村常码头', 119.58, '3室2厅', 235.00, 19652.12, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201200915.htm', '2026-02-23 12:33:11.567191', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1912, '金色雅园金源苑 3室2厅 131.9平', '江汉-红旗渠常青路', 131.9, '3室2厅', 220.00, 16679.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373103.htm', '2026-02-23 12:33:11.573245', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1913, '南航花苑 3室2厅 169.63平', '江汉-红旗渠常青路', 169.63, '3室2厅', 240.00, 14148.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202145086.htm', '2026-02-23 12:33:11.580414', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1914, '万科汉口传奇唐樾 4室2厅 193.83平', '江汉-红旗渠常青路', 193.83, '4室2厅', 485.00, 25021.93, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201143884.htm', '2026-02-23 12:33:11.585876', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1915, '盛世江城 2室2厅 93.94平', '江汉-红旗渠常青路', 93.94, '2室2厅', 112.00, 11922.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202247154.htm', '2026-02-23 12:33:11.591011', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1916, '西北湖壹号御玺湾 5室2厅 317.13平', '江汉-范湖西北湖', 317.13, '5室2厅', 1030.00, 32478.79, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200027663.htm', '2026-02-23 12:33:11.600057', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1917, '金色雅园金涛苑 3室2厅 158.68平', '江汉-红旗渠常青路', 158.68, '3室2厅', 210.00, 13234.18, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374040.htm', '2026-02-23 12:33:11.605237', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1918, '万科汉口传奇悦庭 3室2厅 123.18平', '江汉-红旗渠常青路', 123.18, '3室2厅', 185.00, 15018.67, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374644.htm', '2026-02-23 12:33:11.610829', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1919, '新华家园悦景居 2室2厅 83.97平', '江汉-红旗渠常青路', 83.97, '2室2厅', 123.00, 14648.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366462.htm', '2026-02-23 12:33:11.614194', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1920, '泛海国际居住区樱海园 4室3厅 264.36平', '江汉-王家墩CBD', 264.36, '4室3厅', 880.00, 33287.94, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341569.htm', '2026-02-23 12:33:11.623853', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1921, '金色雅园金涛苑 3室2厅 124.22平', '江汉-红旗渠常青路', 124.22, '3室2厅', 182.00, 14651.42, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202243773.htm', '2026-02-23 12:33:11.631378', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1922, '远洋心语 3室2厅 99.77平', '江汉-复兴村常码头', 99.77, '3室2厅', 93.00, 9321.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202377695.htm', '2026-02-23 12:33:11.639064', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1923, '绿色家园 2室1厅 107.3平', '江汉-红旗渠常青路', 107.3, '2室1厅', 90.00, 8387.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366374.htm', '2026-02-23 12:33:11.646216', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1924, '盛世江城 2室2厅 88.29平', '江汉-红旗渠常青路', 88.29, '2室2厅', 135.00, 15290.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202220484.htm', '2026-02-23 12:33:11.653960', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1925, '万科汉口传奇锦棠 3室2厅 127.0平', '江汉-红旗渠常青路', 127, '3室2厅', 212.00, 16692.91, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200954108.htm', '2026-02-23 12:33:11.662206', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1926, '阳光花园 3室2厅 136.76平', '江汉-红旗渠常青路', 136.76, '3室2厅', 185.00, 13527.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364563.htm', '2026-02-23 12:33:11.670414', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1927, '新世界常青南园 2室2厅 95.81平', '江汉-红旗渠常青路', 95.81, '2室2厅', 182.00, 18995.93, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202033412.htm', '2026-02-23 12:33:11.678310', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1928, '顶琇晶城 2室2厅 93.39平', '江汉-塔子湖', 93.39, '2室2厅', 99.00, 10600.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364559.htm', '2026-02-23 12:33:11.683358', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1929, '福星华府东区 2室2厅 88.45平', '江汉-红旗渠常青路', 88.45, '2室2厅', 95.00, 10740.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201944203.htm', '2026-02-23 12:33:11.688453', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1930, '盛世江城 3室2厅 109.7平', '江汉-红旗渠常青路', 109.7, '3室2厅', 155.00, 14129.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202304390.htm', '2026-02-23 12:46:02.791095', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1931, '中城悦城 3室1厅 95.72平', '江汉-复兴村常码头', 95.72, '3室1厅', 150.00, 15670.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353820.htm', '2026-02-23 12:46:02.802495', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1932, '盛世江城 3室2厅 126.4平', '江汉-红旗渠常青路', 126.4, '3室2厅', 179.00, 14161.39, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202333124.htm', '2026-02-23 12:46:02.810312', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1933, '万科汉口传奇 3室2厅 92.72平', '江汉-红旗渠常青路', 92.72, '3室2厅', 138.00, 14883.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331336.htm', '2026-02-23 12:46:02.816603', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1934, '福星华府·琛境 3室2厅 109.0平', '江汉-红旗渠常青路', 109, '3室2厅', 130.00, 11926.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365476.htm', '2026-02-23 12:46:02.830118', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1935, '武汉江城府 4室2厅 180.0平', '江汉-友谊路', 180, '4室2厅', 396.50, 22027.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182984.htm', '2026-02-23 12:46:02.845798', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1936, '武汉江城府 3室2厅 125.0平', '江汉-友谊路', 125, '3室2厅', 312.20, 24976.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182976.htm', '2026-02-23 12:46:02.862643', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1937, '泛海国际芸海园 2室2厅 101.07平', '江汉-王家墩CBD', 101.07, '2室2厅', 175.00, 17314.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202331409.htm', '2026-02-23 12:46:02.874441', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1938, '盛世江城 3室2厅 126.4平', '江汉-红旗渠常青路', 126.4, '3室2厅', 179.00, 14161.39, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373137.htm', '2026-02-23 12:46:02.886441', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1939, '锦绣人家 3室2厅 149.81平', '江汉-红旗渠常青路', 149.81, '3室2厅', 145.00, 9678.93, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372673.htm', '2026-02-23 12:46:02.893171', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1940, '华发中城荟中央首府 3室2厅 107.65平', '江汉-王家墩CBD', 107.65, '3室2厅', 275.00, 25545.75, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372679.htm', '2026-02-23 12:46:02.898162', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1941, '阳光花园 3室2厅 137.0平', '江汉-红旗渠常青路', 137, '3室2厅', 140.00, 10218.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373206.htm', '2026-02-23 12:46:02.904190', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1942, '华发中城荟中央首府 3室2厅 109.24平', '江汉-王家墩CBD', 109.24, '3室2厅', 278.00, 25448.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372694.htm', '2026-02-23 12:46:02.910873', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1943, '金色雅园金涛苑 2室2厅 98.43平', '江汉-红旗渠常青路', 98.43, '2室2厅', 139.00, 14121.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372662.htm', '2026-02-23 12:46:02.916084', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1944, '远洋心语 3室2厅 103.11平', '江汉-复兴村常码头', 103.11, '3室2厅', 84.80, 8224.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368808.htm', '2026-02-23 12:46:02.921220', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1945, '新华家园 2室2厅 96.73平', '江汉-红旗渠常青路', 96.73, '2室2厅', 115.00, 11888.76, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368784.htm', '2026-02-23 12:46:02.925816', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1946, '阳光花园 3室2厅 91.4平', '江汉-红旗渠常青路', 91.4, '3室2厅', 109.00, 11925.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373205.htm', '2026-02-23 12:46:02.931100', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1947, '世纪江尚 3室2厅 160.22平', '江汉-江汉路', 160.22, '3室2厅', 299.00, 18661.84, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368763.htm', '2026-02-23 12:46:02.938939', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1948, '盛世江城 3室2厅 121.3平', '江汉-红旗渠常青路', 121.3, '3室2厅', 169.00, 13932.40, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372735.htm', '2026-02-23 12:46:02.944143', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1949, '福星惠誉福星华府 3室2厅 121.64平', '江汉-红旗渠常青路', 121.64, '3室2厅', 145.00, 11920.42, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374649.htm', '2026-02-23 12:46:02.948304', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1950, '远洋心苑 3室2厅 96.84平', '江汉-红旗渠常青路', 96.84, '3室2厅', 83.00, 8570.84, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372661.htm', '2026-02-23 12:46:02.955191', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1951, '融创融公馆二期 2室2厅 84.29平', '江汉-塔子湖', 84.29, '2室2厅', 108.00, 12812.91, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372655.htm', '2026-02-23 12:46:02.960266', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1952, '远洋心里 3室2厅 94.32平', '江汉-红旗渠常青路', 94.32, '3室2厅', 105.00, 11132.32, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374555.htm', '2026-02-23 12:46:02.966060', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1953, '万丰花园 3室2厅 111.53平', '江汉-红旗渠常青路', 111.53, '3室2厅', 90.00, 8069.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200198182.htm', '2026-02-23 12:46:02.971161', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1954, '华发中城荟中央首府 3室2厅 168.96平', '江汉-王家墩CBD', 168.96, '3室2厅', 410.00, 24266.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201715755.htm', '2026-02-23 12:46:02.977001', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1955, '盛世江城 3室2厅 115.15平', '江汉-红旗渠常青路', 115.15, '3室2厅', 178.00, 15458.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373272.htm', '2026-02-23 12:46:02.982105', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1956, '华发外滩荟 4室2厅 191.43平', '江汉-江汉路', 191.43, '4室2厅', 880.00, 45969.81, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201715197.htm', '2026-02-23 12:46:02.987499', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1957, '万科汉口传奇锦棠 3室2厅 143.75平', '江汉-红旗渠常青路', 143.75, '3室2厅', 258.00, 17947.83, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373168.htm', '2026-02-23 12:46:02.993121', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1958, '福星华府誉境 3室2厅 131.8平', '江汉-红旗渠常青路', 131.8, '3室2厅', 196.00, 14871.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374560.htm', '2026-02-23 12:46:02.997808', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1959, '文锦苑 2室2厅 101.59平', '江汉-红旗渠常青路', 101.59, '2室2厅', 110.00, 10827.84, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374676.htm', '2026-02-23 12:46:03.002992', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1960, '绿城·湖畔雲庐 4室2厅 141.18平', '江汉-王家墩CBD', 141.18, '4室2厅', 380.00, 26915.99, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202197415.htm', '2026-02-23 12:46:03.008278', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1961, '阳光丽舍 3室2厅 123.42平', '江汉-红旗渠常青路', 123.42, '3室2厅', 180.00, 14584.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182197.htm', '2026-02-23 12:46:03.013423', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1962, '万科公园5号 3室2厅 107.06平', '江汉-塔子湖', 107.06, '3室2厅', 198.00, 18494.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_200686598.htm', '2026-02-23 12:46:03.018588', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1963, '福星城市花园 3室2厅 133.04平', '江汉-武广万松园', 133.04, '3室2厅', 180.00, 13529.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202182501.htm', '2026-02-23 12:46:03.023298', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1964, '华发中城荟中央首府 3室2厅 109.36平', '江汉-王家墩CBD', 109.36, '3室2厅', 283.00, 25877.83, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374653.htm', '2026-02-23 12:46:03.027966', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1965, '万科汉口传奇悦庭 3室2厅 120.59平', '江汉-红旗渠常青路', 120.59, '3室2厅', 180.00, 14926.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372692.htm', '2026-02-23 12:46:03.033759', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1966, '远洋心里 3室2厅 118.9平', '江汉-红旗渠常青路', 118.9, '3室2厅', 168.00, 14129.52, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368804.htm', '2026-02-23 12:46:03.037922', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1967, '福星华府誉境 3室2厅 97.06平', '江汉-红旗渠常青路', 97.06, '3室2厅', 118.00, 12157.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374619.htm', '2026-02-23 12:46:03.043599', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1968, '泛海国际桂海园 4室2厅 169.84平', '江汉-王家墩CBD', 169.84, '4室2厅', 398.00, 23433.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341323.htm', '2026-02-23 12:46:03.049408', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1969, '中城悦城 3室2厅 119.58平', '江汉-复兴村常码头', 119.58, '3室2厅', 200.00, 16725.20, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202371281.htm', '2026-02-23 12:46:03.054574', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1970, '福星华府誉境 3室2厅 122.46平', '江汉-红旗渠常青路', 122.46, '3室2厅', 127.00, 10370.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374707.htm', '2026-02-23 12:46:03.059374', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1971, '华发中城荟中央首府 3室2厅 107.65平', '江汉-王家墩CBD', 107.65, '3室2厅', 315.00, 29261.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340536.htm', '2026-02-23 12:46:03.064444', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1972, '锦绣人家 3室2厅 144.42平', '江汉-红旗渠常青路', 144.42, '3室2厅', 159.00, 11009.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373246.htm', '2026-02-23 12:46:03.070753', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1973, '万科汉口传奇唐樾 3室2厅 113.04平', '江汉-红旗渠常青路', 113.04, '3室2厅', 186.20, 16472.05, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374597.htm', '2026-02-23 12:46:03.075439', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1974, '万科汉口传奇悦庭 4室2厅 187.75平', '江汉-红旗渠常青路', 187.75, '4室2厅', 398.00, 21198.40, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368730.htm', '2026-02-23 12:46:03.080145', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1975, '泛海国际居住区樱海园 3室2厅 128.62平', '江汉-王家墩CBD', 128.62, '3室2厅', 320.00, 24879.49, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341624.htm', '2026-02-23 12:46:03.084765', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1976, '泛海国际碧海园 4室2厅 258.51平', '江汉-王家墩CBD', 258.51, '4室2厅', 550.00, 21275.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340611.htm', '2026-02-23 12:46:03.092688', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1977, '福星华府誉境 2室1厅 82.82平', '江汉-红旗渠常青路', 82.82, '2室1厅', 88.00, 10625.45, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368727.htm', '2026-02-23 12:46:03.099931', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1978, '同馨花园雍豪府 2室2厅 89.94平', '江汉-宝丰崇仁路', 89.94, '2室2厅', 160.00, 17789.64, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202291965.htm', '2026-02-23 12:46:03.107219', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1979, '华发中城荟中央首府 3室2厅 132.38平', '江汉-王家墩CBD', 132.38, '3室2厅', 365.00, 27572.14, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202186429.htm', '2026-02-23 12:46:03.112415', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1980, '融创玖玺臺 4室2厅 142.31平', '江汉-范湖西北湖', 142.31, '4室2厅', 328.00, 23048.27, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202197394.htm', '2026-02-23 12:46:03.118075', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1981, '泛海国际桂海园 2室2厅 91.51平', '江汉-王家墩CBD', 91.51, '2室2厅', 180.00, 19669.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341245.htm', '2026-02-23 12:46:03.122768', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1982, '华发中城荟 3室2厅 143.7平', '江汉-王家墩CBD', 143.7, '3室2厅', 400.00, 27835.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202340594.htm', '2026-02-23 12:46:03.129078', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1983, '泛海国际居住区悦海园 2室2厅 85.38平', '江汉-王家墩CBD', 85.38, '2室2厅', 178.00, 20847.97, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202185819.htm', '2026-02-23 12:46:03.133760', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1984, '福星华府誉境 3室2厅 97.17平', '江汉-红旗渠常青路', 97.17, '3室2厅', 125.00, 12864.05, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374623.htm', '2026-02-23 12:46:03.138449', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1985, '阳光花园 3室2厅 124.37平', '江汉-红旗渠常青路', 124.37, '3室2厅', 108.00, 8683.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374538.htm', '2026-02-23 12:46:03.143103', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1986, '中环星干线 3室2厅 85.13平', '江汉-红旗渠常青路', 85.13, '3室2厅', 89.00, 10454.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373164.htm', '2026-02-23 12:46:03.149329', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1987, '南航馨园 3室2厅 93.39平', '江汉-红旗渠常青路', 93.39, '3室2厅', 135.00, 14455.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374682.htm', '2026-02-23 12:46:03.154093', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1988, '泛海国际居住区竹海园 3室2厅 100.19平', '江汉-复兴村常码头', 100.19, '3室2厅', 255.00, 25451.64, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341387.htm', '2026-02-23 12:46:03.159753', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1989, '泰合花园 2室1厅 97.87平', '江汉-王家墩CBD', 97.87, '2室1厅', 89.00, 9093.70, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202341172.htm', '2026-02-23 12:46:03.164938', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1990, '顶琇西北湖 2室2厅 156.28平', '江汉-范湖西北湖', 156.28, '2室2厅', 470.00, 30074.23, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202219121.htm', '2026-02-23 12:46:03.170353', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1991, '福星华府誉境 3室2厅 131.92平', '江汉-红旗渠常青路', 131.92, '3室2厅', 205.00, 15539.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374641.htm', '2026-02-23 12:46:03.176317', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1992, '金色雅园金池苑 3室2厅 142.18平', '江汉-红旗渠常青路', 142.18, '3室2厅', 188.00, 13222.68, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372772.htm', '2026-02-23 12:46:03.182790', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1993, '泛海国际桂海园 2室2厅 91.48平', '江汉-王家墩CBD', 91.48, '2室2厅', 163.00, 17818.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368801.htm', '2026-02-23 12:46:03.188709', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1994, '新世界常青南园 2室1厅 95.01平', '江汉-红旗渠常青路', 95.01, '2室1厅', 139.00, 14630.04, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202371277.htm', '2026-02-23 12:46:03.193100', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1995, '顶琇国际公馆 2室2厅 78.72平', '江汉-红旗渠常青路', 78.72, '2室2厅', 75.00, 9527.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202373138.htm', '2026-02-23 12:46:03.199456', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1996, '华发中城荟中央首府 3室2厅 109.36平', '江汉-王家墩CBD', 109.36, '3室2厅', 280.00, 25603.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368819.htm', '2026-02-23 12:46:03.204649', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1997, '新华家园 3室2厅 135.03平', '江汉-红旗渠常青路', 135.03, '3室2厅', 170.00, 12589.79, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372686.htm', '2026-02-23 12:46:03.209874', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1998, '福星惠誉福星华府·峯 2室2厅 91.09平', '江汉-塔子湖', 91.09, '2室2厅', 130.00, 14271.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202232235.htm', '2026-02-23 12:46:03.216098', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (1999, '金盾花园 3室2厅 132.34平', '江汉-红旗渠常青路', 132.34, '3室2厅', 115.00, 8689.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202205491.htm', '2026-02-23 12:46:03.221777', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2000, '金色雅园金涛苑 3室2厅 132.19平', '江汉-红旗渠常青路', 132.19, '3室2厅', 205.00, 15507.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202033402.htm', '2026-02-23 12:46:03.228592', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2001, '新华家园 3室2厅 133.62平', '江汉-红旗渠常青路', 133.62, '3室2厅', 118.00, 8831.01, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202225088.htm', '2026-02-23 12:46:03.233797', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2002, '南航小区 3室2厅 96.01平', '江汉-红旗渠常青路', 96.01, '3室2厅', 102.00, 10623.89, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202312429.htm', '2026-02-23 12:46:03.238835', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2003, '顶琇国际城 3室2厅 98.0平', '江汉-红旗渠常青路', 98, '3室2厅', 115.00, 11734.69, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374532.htm', '2026-02-23 12:46:03.243633', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2004, '阳光花园 3室2厅 137.99平', '江汉-红旗渠常青路', 137.99, '3室2厅', 160.00, 11595.04, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202248891.htm', '2026-02-23 12:46:03.249435', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2005, '福星惠誉福星城 3室2厅 96.85平', '江汉-红旗渠常青路', 96.85, '3室2厅', 99.00, 10221.99, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202343514.htm', '2026-02-23 12:46:03.254093', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2006, '新世界常青南园 3室2厅 133.69平', '江汉-红旗渠常青路', 133.69, '3室2厅', 256.00, 19148.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202081243.htm', '2026-02-23 12:46:03.262451', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2007, '阳光丽舍 3室2厅 125.43平', '江汉-红旗渠常青路', 125.43, '3室2厅', 165.00, 13154.75, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202351046.htm', '2026-02-23 12:46:03.267590', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2008, '阳光花园 2室2厅 171.32平', '江汉-红旗渠常青路', 171.32, '2室2厅', 158.00, 9222.51, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374533.htm', '2026-02-23 12:46:03.272754', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2009, '盛世江城 3室2厅 119.54平', '江汉-红旗渠常青路', 119.54, '3室2厅', 180.00, 15057.72, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202137988.htm', '2026-02-23 12:46:03.277676', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2010, '万科汉口传奇悦庭 3室2厅 88.43平', '江汉-红旗渠常青路', 88.43, '3室2厅', 125.00, 14135.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368725.htm', '2026-02-23 12:46:03.283339', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2011, '万科城 2室2厅 86.44平', '江汉-红旗渠常青路', 86.44, '2室2厅', 106.00, 12262.84, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202377723.htm', '2026-02-23 12:46:03.287977', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2012, '万科翡翠国际 3室2厅 120.0平', '江汉-范湖西北湖', 120, '3室2厅', 315.00, 26250.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201395207.htm', '2026-02-23 12:46:03.293581', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2013, '金色雅园金源苑 2室2厅 101.99平', '江汉-红旗渠常青路', 101.99, '2室2厅', 145.00, 14217.08, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374590.htm', '2026-02-23 12:46:03.298296', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2014, '福星华府誉境 3室2厅 118.2平', '江汉-红旗渠常青路', 118.2, '3室2厅', 128.00, 10829.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202368723.htm', '2026-02-23 12:46:03.304646', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2015, '新世界常青南园 2室2厅 98.92平', '江汉-红旗渠常青路', 98.92, '2室2厅', 162.00, 16376.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202247165.htm', '2026-02-23 12:46:03.310566', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2016, '金鑫国际 2室2厅 66.69平', '武汉-光谷', 66.69, '2室2厅', 68.00, 10196.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201700986.htm', '2026-02-23 12:47:04.377190', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2017, '佳兆业金域天下 3室2厅 108.01平', '武汉-白沙洲', 108.01, '3室2厅', 90.00, 8332.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353056.htm', '2026-02-23 12:47:04.474418', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2018, '保利上城西区 3室2厅 101.52平', '武汉-白沙洲', 101.52, '3室2厅', 97.00, 9554.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325894.htm', '2026-02-23 12:47:04.478948', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2019, '保利新武昌 3室2厅 101.22平', '武汉-白沙洲', 101.22, '3室2厅', 111.90, 11055.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202287812.htm', '2026-02-23 12:47:04.491423', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2020, '佳兆业金域天下 3室2厅 91.11平', '武汉-白沙洲', 91.11, '3室2厅', 76.00, 8341.57, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353011.htm', '2026-02-23 12:47:04.503187', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2021, '保利新武昌 3室2厅 96.75平', '武汉-白沙洲', 96.75, '3室2厅', 103.90, 10739.02, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316954.htm', '2026-02-23 12:47:04.509495', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2022, '复地悦城二期东区 2室2厅 82.07平', '武汉-白沙洲', 82.07, '2室2厅', 75.00, 9138.54, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334462.htm', '2026-02-23 12:47:04.514180', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2023, '万科云城 3室2厅 124.17平', '武汉-武泰闸烽火', 124.17, '3室2厅', 118.00, 9503.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355739.htm', '2026-02-23 12:47:04.518859', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2024, '龙湖·天璞 3室2厅 114.81平', '武汉-白沙洲', 114.81, '3室2厅', 158.00, 13761.87, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202348896.htm', '2026-02-23 12:47:04.523333', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2025, '清能清江锦城 3室2厅 111.05平', '武汉-白沙洲', 111.05, '3室2厅', 92.00, 8284.56, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379912.htm', '2026-02-23 12:47:04.529708', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2026, '喜瑞都 3室2厅 102.84平', '武汉-白沙洲', 102.84, '3室2厅', 87.00, 8459.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357224.htm', '2026-02-23 12:47:04.534424', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2027, '清能清江锦城 4室1厅 114.47平', '武汉-白沙洲', 114.47, '4室1厅', 99.00, 8648.55, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379920.htm', '2026-02-23 12:47:04.540636', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2028, '万科云城 3室2厅 118.09平', '武汉-武泰闸烽火', 118.09, '3室2厅', 112.00, 9484.29, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355736.htm', '2026-02-23 12:47:04.551169', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2029, '喜瑞都 3室2厅 93.18平', '武汉-白沙洲', 93.18, '3室2厅', 78.00, 8370.90, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357253.htm', '2026-02-23 12:47:04.556367', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2030, '保利新武昌 3室2厅 109.8平', '武汉-白沙洲', 109.8, '3室2厅', 121.90, 11102.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294872.htm', '2026-02-23 12:47:04.564328', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2031, '保利新武昌 3室2厅 100.48平', '武汉-白沙洲', 100.48, '3室2厅', 108.00, 10748.41, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316883.htm', '2026-02-23 12:47:04.569447', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2032, '世茂云锦樱海园 3室2厅 120.28平', '武汉-白沙洲', 120.28, '3室2厅', 106.00, 8812.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372916.htm', '2026-02-23 12:47:04.574044', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2033, '喜瑞都 3室2厅 118.23平', '武汉-白沙洲', 118.23, '3室2厅', 100.00, 8458.09, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357214.htm', '2026-02-23 12:47:04.578532', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2034, '复地悦城二期东区 3室2厅 101.73平', '武汉-白沙洲', 101.73, '3室2厅', 95.00, 9338.44, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334185.htm', '2026-02-23 12:47:04.590071', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2035, '东原启城 3室2厅 97.09平', '武汉-白沙洲', 97.09, '3室2厅', 80.00, 8239.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364156.htm', '2026-02-23 12:47:04.595784', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2036, '清能清江锦城 2室2厅 93.59平', '武汉-白沙洲', 93.59, '2室2厅', 78.00, 8334.22, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366466.htm', '2026-02-23 12:47:04.607790', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2037, '万科城市之光 3室2厅 120.47平', '武汉-白沙洲', 120.47, '3室2厅', 140.00, 11621.15, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353320.htm', '2026-02-23 12:47:04.620067', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2038, '保利新武昌 3室2厅 100.48平', '武汉-白沙洲', 100.48, '3室2厅', 107.90, 10738.46, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316868.htm', '2026-02-23 12:47:04.627715', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2039, '保利新武昌 3室2厅 126.4平', '武汉-白沙洲', 126.4, '3室2厅', 133.90, 10593.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316910.htm', '2026-02-23 12:47:04.637430', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2040, '复地悦城二期东区 2室1厅 78.45平', '武汉-白沙洲', 78.45, '2室1厅', 72.00, 9177.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334217.htm', '2026-02-23 12:47:04.641791', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2041, '万科城市之光 3室2厅 119.29平', '武汉-白沙洲', 119.29, '3室2厅', 133.50, 11191.21, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352668.htm', '2026-02-23 12:47:04.647442', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2042, '菁英城 3室2厅 117.0平', '武汉-白沙洲', 117, '3室2厅', 95.00, 8119.66, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363467.htm', '2026-02-23 12:47:04.652196', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2043, '保利上城西区 3室2厅 104.7平', '武汉-白沙洲', 104.7, '3室2厅', 100.00, 9551.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325888.htm', '2026-02-23 12:47:04.656316', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2044, '保利新武昌 3室2厅 102.14平', '武汉-白沙洲', 102.14, '3室2厅', 109.00, 10671.63, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202369334.htm', '2026-02-23 12:47:04.662665', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2045, '保利新武昌 3室1厅 108.13平', '武汉-白沙洲', 108.13, '3室1厅', 119.90, 11088.50, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202055521.htm', '2026-02-23 12:47:04.668349', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2046, '万科城市之光 4室2厅 141.98平', '武汉-白沙洲', 141.98, '4室2厅', 154.00, 10846.60, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352655.htm', '2026-02-23 12:47:04.674334', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2047, '保利新武昌 3室2厅 130.23平', '武汉-白沙洲', 130.23, '3室2厅', 139.90, 10742.53, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316935.htm', '2026-02-23 12:47:04.690752', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2048, '洺悦芳华 3室2厅 105.87平', '武汉-三角湖', 105.87, '3室2厅', 103.00, 9728.91, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365246.htm', '2026-02-23 12:47:04.700713', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2049, '万科光澜道 3室2厅 116.39平', '武汉-白沙洲', 116.39, '3室2厅', 123.60, 10619.47, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353270.htm', '2026-02-23 12:47:04.712903', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2050, '清能清江锦城 2室2厅 88.65平', '武汉-白沙洲', 88.65, '2室2厅', 74.00, 8347.43, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366413.htm', '2026-02-23 12:47:04.718576', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2051, '复地悦城二期东区 3室2厅 89.12平', '武汉-白沙洲', 89.12, '3室2厅', 80.00, 8976.66, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334170.htm', '2026-02-23 12:47:04.729617', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2052, '清能清江锦城玥园 3室2厅 131.02平', '武汉-白沙洲', 131.02, '3室2厅', 109.00, 8319.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202198420.htm', '2026-02-23 12:47:04.734198', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2053, '喜瑞都 3室2厅 100.97平', '武汉-白沙洲', 100.97, '3室2厅', 85.00, 8418.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202357249.htm', '2026-02-23 12:47:04.747959', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2054, '复地悦城二期东区 3室2厅 102.12平', '武汉-白沙洲', 102.12, '3室2厅', 95.00, 9302.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334171.htm', '2026-02-23 12:47:04.753060', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2055, '洺悦芳华 4室2厅 155.69平', '武汉-三角湖', 155.69, '4室2厅', 170.00, 10919.13, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365244.htm', '2026-02-23 12:47:04.757367', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2056, '清能清江锦城 4室2厅 127.35平', '武汉-白沙洲', 127.35, '4室2厅', 110.00, 8637.61, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202332289.htm', '2026-02-23 12:47:04.764189', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2057, '中建铂公馆 3室2厅 110.15平', '武汉-白沙洲', 110.15, '3室2厅', 99.00, 8987.74, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202372576.htm', '2026-02-23 12:47:04.769310', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2058, '保利上城东区 3室2厅 99.23平', '武汉-白沙洲', 99.23, '3室2厅', 86.00, 8666.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202374371.htm', '2026-02-23 12:47:04.775127', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2059, '东原启城 3室2厅 116.1平', '武汉-白沙洲', 116.1, '3室2厅', 96.00, 8268.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364182.htm', '2026-02-23 12:47:04.781305', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2060, '清能清江锦城 3室2厅 131.02平', '武汉-白沙洲', 131.02, '3室2厅', 109.00, 8319.34, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202366460.htm', '2026-02-23 12:47:04.788420', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2061, '保利上城西区 2室2厅 79.09平', '武汉-白沙洲', 79.09, '2室2厅', 76.00, 9609.31, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202325881.htm', '2026-02-23 12:47:04.794977', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2062, '复地悦城二期东区 4室2厅 136.41平', '武汉-白沙洲', 136.41, '4室2厅', 129.00, 9456.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202288343.htm', '2026-02-23 12:47:04.801044', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2063, '保利新武昌 3室2厅 126.89平', '武汉-白沙洲', 126.89, '3室2厅', 134.00, 10560.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202316921.htm', '2026-02-23 12:47:04.806149', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2064, '清能清江锦城 3室2厅 92.4平', '武汉-白沙洲', 92.4, '3室2厅', 79.00, 8549.78, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379905.htm', '2026-02-23 12:47:04.810817', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2065, '万科云城 4室2厅 171.27平', '武汉-武泰闸烽火', 171.27, '4室2厅', 160.00, 9341.97, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202355822.htm', '2026-02-23 12:47:04.818359', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2066, '复地悦城二期东区 3室2厅 103.15平', '武汉-白沙洲', 103.15, '3室2厅', 93.00, 9016.00, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202310618.htm', '2026-02-23 12:47:04.824061', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2067, '清能清江锦城 2室2厅 80.08平', '武汉-白沙洲', 80.08, '2室2厅', 69.50, 8678.82, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202379906.htm', '2026-02-23 12:47:04.837044', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2068, '东原启城 3室2厅 98.16平', '武汉-白沙洲', 98.16, '3室2厅', 82.00, 8353.71, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202364133.htm', '2026-02-23 12:47:04.842835', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2069, '中建铂公馆 3室1厅 111.32平', '武汉-白沙洲', 111.32, '3室1厅', 100.00, 8983.11, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202363056.htm', '2026-02-23 12:47:04.848637', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2070, '万科城市之光 3室2厅 109.51平', '武汉-白沙洲', 109.51, '3室2厅', 123.00, 11231.85, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202352665.htm', '2026-02-23 12:47:04.853925', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2071, '洺悦芳华 3室2厅 127.95平', '武汉-三角湖', 127.95, '3室2厅', 118.00, 9222.35, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202365248.htm', '2026-02-23 12:47:04.866324', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2072, '龙湖·天璞 3室2厅 114.81平', '武汉-白沙洲', 114.81, '3室2厅', 157.00, 13674.77, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202348886.htm', '2026-02-23 12:47:04.870455', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2073, '保利新武昌 3室2厅 96.96平', '武汉-白沙洲', 96.96, '3室2厅', 107.90, 11128.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202294881.htm', '2026-02-23 12:47:04.882420', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2074, '复地悦城二期东区 2室2厅 76.99平', '武汉-白沙洲', 76.99, '2室2厅', 69.90, 9079.10, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202334210.htm', '2026-02-23 12:47:04.887875', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2075, '佳兆业金域天下二期 2室2厅 78.0平', '武汉-白沙洲', 78, '2室2厅', 65.00, 8333.33, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202353060.htm', '2026-02-23 12:47:04.893017', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2076, '福星惠誉东湖城二期 4室2厅 139.03平', '武汉-钢都', 139.03, '4室2厅', 180.00, 12946.85, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201222660.htm', '2026-02-23 12:47:04.897140', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2077, '万科云城 3室2厅 118.05平', '武汉-武泰闸烽火', 118.05, '3室2厅', 125.00, 10588.73, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201236840.htm', '2026-02-23 12:47:04.902720', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2078, '大华南湖公园世家 1室1厅 50.91平', '武汉-南湖花园', 50.91, '1室1厅', 76.00, 14928.30, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201365179.htm', '2026-02-23 12:47:04.907128', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2079, '保利中央公馆 2室2厅 86.71平', '武汉-南湖花园', 86.71, '2室2厅', 118.00, 13608.58, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_201231948.htm', '2026-02-23 12:47:04.912372', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2080, '锦绣江城 3室2厅 112.57平', '武汉-武泰闸烽火', 112.57, '3室2厅', 91.50, 8128.28, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202378393.htm', '2026-02-23 12:47:04.917033', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2081, '复地悦城二期东区 2室2厅 78.45平', '武汉-白沙洲', 78.45, '2室2厅', 66.80, 8514.98, 'Fang', 'https://wuhan.esf.fang.com/chushou/3_202107378.htm', '2026-02-23 12:47:04.923000', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2082, '碧桂园梓山湖 5室2厅 227.0平', '咸宁-咸安城区', 227, '5室2厅', 78.00, 3436.12, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155587005.htm', '2026-02-23 12:51:31.485687', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2083, '碧桂园温泉城 东南亚风格双拼别墅 带200多平大花园 !!', '咸宁-咸安', 184, '', 198.00, 10760.87, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155797450.htm', '2026-02-23 12:51:31.491307', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2084, '碧桂园梓山湖 4室2厅 135.0平', '咸宁-咸安城区', 135, '4室2厅', 56.00, 4148.15, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155587007.htm', '2026-02-23 12:51:31.497132', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2085, '降价急售58万南北通透135平碧桂园梓山湖3室2厅房东急', '咸宁-咸安', 135, '', 58.00, 4296.30, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155273426.htm', '2026-02-23 12:51:31.503077', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2086, '碧桂园梓山湖双拼别墅,4室带双阳台拎包入住,小区人气高', '咸宁-咸安', 142, '', 78.00, 5492.96, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155587002.htm', '2026-02-23 12:51:31.508335', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2087, '咸宁兴旺城一期 3室2厅 122.56平', '咸宁-长安大道65号', 122.56, '3室2厅', 26.80, 2186.68, 'Fang', 'https://xianning.esf.fang.com/chushou/16_5383784.htm', '2026-02-23 12:51:31.513846', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2088, '咸宁壹号院 3室2厅 123.63平', '咸宁-银泉大道', 123.63, '3室2厅', 57.00, 4610.53, 'Fang', 'https://xianning.esf.fang.com/chushou/16_5446963.htm', '2026-02-23 12:51:31.519623', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2089, '碧桂园温泉城 两层四房双拼别墅 一楼带老人房 壁炉 空调', '咸宁-咸安', 180, '', 220.00, 12222.22, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155797449.htm', '2026-02-23 12:51:31.524151', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2090, '1+8时代广场 1室1厅 58.0平', '咸宁-沃尔玛购物广场', 58, '1室1厅', 24.50, 4224.14, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155973875.htm', '2026-02-23 12:51:31.528879', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2091, '碧桂园温泉城 东南亚风格双拼别墅 带200平大花园 证满税低', '咸宁-咸宁职业技术学院', 133, '', 128.00, 9624.06, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155797451.htm', '2026-02-23 12:51:31.534151', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2092, '咸宁兴旺城一期 3室2厅 121.56平', '咸宁-长安大道65号', 121.56, '3室2厅', 28.00, 2303.39, 'Fang', 'https://xianning.esf.fang.com/chushou/16_5176725.htm', '2026-02-23 12:51:31.539843', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2093, '咸宁职业技术学院书苑小区 4室2厅 147.63平', '咸宁-五洲新天地', 147.63, '4室2厅', 72.00, 4877.06, 'Fang', 'https://xianning.esf.fang.com/chushou/16_5339966.htm', '2026-02-23 12:51:31.544562', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2094, '置境贺胜府 4室2厅 129.0平', '咸宁-咸安', 129, '4室2厅', 19.20, 1488.37, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155587288.htm', '2026-02-23 12:51:31.550187', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2095, '碧桂园春江月中式合院别墅,赠送地下车库,人车流', '咸宁-咸安', 145, '', 135.00, 9310.34, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155533807.htm', '2026-02-23 12:51:31.555983', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2096, '咸宁簏山温泉城别墅 8室4厅 228.0平', '咸宁-沃尔玛购物广场', 228, '8室4厅', 150.00, 6578.95, 'Fang', 'https://xianning.esf.fang.com/chushou/16_1122.htm', '2026-02-23 12:51:31.561150', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2097, '咸宁市咸宁大道特1号(香泉公馆) 2室2厅 88.18平', '咸宁-温泉潜山商业街', 88.18, '2室2厅', 30.00, 3402.13, 'Fang', 'https://xianning.esf.fang.com/chushou/16_5401682.htm', '2026-02-23 12:51:31.566160', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2098, '咸宁·未来天地 4室2厅 135.0平', '咸宁-温泉第一街', 135, '4室2厅', 48.60, 3600.00, 'Fang', 'https://xianning.esf.fang.com/chushou/3_155526475.htm', '2026-02-23 12:51:31.571627', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2099, '君越公寓 3室2厅 138.85平', '咸宁-青年路6号', 138.85, '3室2厅', 38.00, 2736.77, 'Fang', 'https://xianning.esf.fang.com/chushou/16_5398774.htm', '2026-02-23 12:51:31.576801', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2100, '咸宁市咸安区盘泗洲咸宁碧桂园(淦河茶韵09街)81幢13号1-3层住宅房地产及地上未登记的建筑物【不动产权证号:鄂(2024)咸安区不动产权第0015180号】', '咸宁-咸安', 282.19, '', 200.00, 7087.42, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11938133.html', '2026-02-23 12:51:31.582058', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2101, '湖北省咸宁市咸安区官埠桥镇渡船村(咸宁城际空间站B地块)12幢3层304', '咸宁-咸安区', 113.98, '', 25.76, 2260.05, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11770581.html', '2026-02-23 12:51:31.587966', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2102, '咸宁市咸安区向阳湖镇铁铺村十二组1幢1-4层住宅房地产及顶楼搭建彩钢棚【房屋所有权证号:咸宁市房权证咸安字第10040765号,国有土地证号:咸安国用(2014)第3048号】', '咸宁-咸安', 965.28, '', 166.98, 1729.86, 'Fang', 'https://xianning.esf.fang.com/fapai/out_12015527.html', '2026-02-23 12:51:31.593627', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2103, '咸宁市浮山办事处杨下村(青年宜家)5幢1单元6层602号住宅房地产【不动产权证号:鄂(2023)咸安区不动产权第0009731号】', '咸宁-咸安区', 87.85, '', 14.47, 1647.13, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11880963.html', '2026-02-23 12:51:31.598732', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2104, '湖北省咸宁市嘉鱼县鱼岳镇凤凰大道100号(凤凰大道60号5栋502室)的房地产', '咸宁-嘉鱼', 130.71, '', 12.44, 951.73, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11976190.html', '2026-02-23 12:51:31.603845', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2105, '咸宁市咸安区长安大道59号1幢7层702号住宅房地产【房屋所有权证号:咸宁市房权证咸安字第10026368号,国有土地证号:咸安国用(2013)第364号】', '咸宁-咸安', 163.43, '', 33.66, 2059.60, 'Fang', 'https://xianning.esf.fang.com/fapai/out_12017710.html', '2026-02-23 12:51:31.610192', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2106, '咸宁市浮山办事处杨下村(青年宜家)5幢3单元6层601号住宅房地产【不动产权证号:鄂(2023)咸安区不动产权第0009729号】', '咸宁-咸安区', 87.85, '', 14.47, 1647.13, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11883822.html', '2026-02-23 12:51:31.615362', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2107, '咸宁市咸安区桂乡大道南侧(际华园水晶谷)H-28幢1-2层102号住宅房地产【不动产权证号:鄂(2024)咸安区不动产权第0001209号】', '咸宁-咸安', 136.59, '', 85.07, 6228.13, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11990754.html', '2026-02-23 12:51:31.620006', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2108, '湖北省咸宁市咸安区咸宁大道西段(城市印象)2、3幢11层1102号的不动产', '咸宁-咸安区', 148.15, '', 27.96, 1887.28, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11776903.html', '2026-02-23 12:51:31.626318', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2109, '咸宁市浮山办事处杨下村(青年宜家)5幢3单元4层401号住宅房地产【不动产权证号:鄂(2023)咸安区不动产权第0009717号】', '咸宁-咸安区', 110.11, '', 20.79, 1888.11, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11884615.html', '2026-02-23 12:51:31.630991', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2110, '咸宁市咸安区泉塘村七组(法苑小区)4幢2单元6层601号住宅房地产【房屋所有权证号:咸宁市房权证温泉字第00056222号,国有土地证号:咸土资城国用(2016)第01620号】', '咸宁-咸安', 145.49, '', 32.46, 2231.08, 'Fang', 'https://xianning.esf.fang.com/fapai/out_12017706.html', '2026-02-23 12:51:31.636702', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2111, '咸宁市温泉路10号(阳光丽景)1幢12层1201号住宅房地产【房屋所有权证号:咸宁市房权证温泉字第00053525号】', '咸宁-咸安', 127.06, '', 33.50, 2636.55, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11950675.html', '2026-02-23 12:51:31.641910', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2112, '湖北省咸宁市通城县隽水镇通麦公路1-5层房屋', '咸宁-通城', 560.4, '', 128.44, 2291.93, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11950069.html', '2026-02-23 12:51:31.647524', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2113, '咸宁市浮山办事处杨下村(青年宜家)5幢1单元6层601号住宅房地产【不动产权证号:鄂(2023)咸安区不动产权第0009728号】', '咸宁-咸安区', 87.85, '', 14.47, 1647.13, 'Fang', 'https://xianning.esf.fang.com/fapai/out_11881787.html', '2026-02-23 12:51:31.652395', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2114, '咸宁市咸安区渔水路1号(咸安区水产局院内)5幢1单元5层501号住宅房地产【不动产权证号:鄂(2019)咸安区不动产权第0031173号】', '咸宁-咸安', 108.79, '', 14.99, 1377.88, 'Fang', 'https://xianning.esf.fang.com/fapai/out_12020542.html', '2026-02-23 12:51:31.658485', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2115, '咸宁市咸安区渔水路123号(咸安区水产局院内)2单元2层201号住宅房地产【房屋所有权证号:咸宁市房权证咸安字第10024311号,国有土地使用证号:咸安国用(2012)第3284号】', '咸宁-咸安', 144.21, '', 21.94, 1521.39, 'Fang', 'https://xianning.esf.fang.com/fapai/out_12016959.html', '2026-02-23 12:51:31.663342', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2116, '荆州绿地海外滩 3室2厅 95.0平', '荆州-荆沙大道', 95, '3室2厅', 46.00, 4842.11, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155990431.htm', '2026-02-23 12:54:23.060641', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2117, '荆州海洋世界 4室2厅 142.0平', '荆州-花台好邻居购物广场', 142, '4室2厅', 76.00, 5352.11, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155996825.htm', '2026-02-23 12:54:23.069946', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2118, '海伦堡玖悦府(新房) 3室2厅 122.0平', '荆州-小北门', 122, '3室2厅', 47.00, 3852.46, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155932396.htm', '2026-02-23 12:54:23.075202', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2119, '荆州碧桂园 3室2厅 111.0平', '荆州-沙北新区', 111, '3室2厅', 60.00, 5405.41, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155996819.htm', '2026-02-23 12:54:23.080252', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2120, '楚天都市·佳园 3室2厅 134.0平', '荆州-荆沙大道', 134, '3室2厅', 95.00, 7089.55, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155996823.htm', '2026-02-23 12:54:23.085573', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2121, '荆州海洋世界 4室2厅 138.0平', '荆州-花台好邻居购物广场', 138, '4室2厅', 75.00, 5434.78, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155974001.htm', '2026-02-23 12:54:23.092258', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2122, '荆州绿地海外滩 3室2厅 100.0平', '荆州-荆沙大道', 100, '3室2厅', 55.00, 5500.00, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155879267.htm', '2026-02-23 12:54:23.097548', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2123, '荆州绿地海外滩 3室1厅 99.0平', '荆州-荆沙大道', 99, '3室1厅', 99.00, 10000.00, 'Fang', 'https://jingzhou.esf.fang.com/chushou/16_5256565.htm', '2026-02-23 12:54:23.102786', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2124, '荆州新天地 3室2厅 130.0平', '荆州-美佳华购物广场', 130, '3室2厅', 63.00, 4846.15, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155820820.htm', '2026-02-23 12:54:23.107984', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2125, '荆州新天地 3室2厅 130.0平', '荆州-美佳华购物广场', 130, '3室2厅', 70.00, 5384.62, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155891297.htm', '2026-02-23 12:54:23.112627', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2126, '中建三局荆州之星 3室1厅 97.0平', '荆州-红门路', 97, '3室1厅', 69.00, 7113.40, 'Fang', 'https://jingzhou.esf.fang.com/chushou/16_5282701.htm', '2026-02-23 12:54:23.118418', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2127, '荆州地区监利 2室2厅 59.5平', '荆州-城北大市场', 59.5, '2室2厅', 2.10, 352.94, 'Fang', 'https://jingzhou.esf.fang.com/chushou/16_5341496.htm', '2026-02-23 12:54:23.123540', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2128, '荆州日报社宿舍(太岳路) 3室2厅 97.0平', '荆州-荆沙大道', 97, '3室2厅', 25.00, 2577.32, 'Fang', 'https://jingzhou.esf.fang.com/chushou/3_155931190.htm', '2026-02-23 12:54:23.128758', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2129, '雅居乐锦城 3室2厅 117.15平', '荆州-武德路', 117.15, '3室2厅', 69.00, 5889.88, 'Fang', 'https://jingzhou.esf.fang.com/chushou/16_5439878.htm', '2026-02-23 12:54:23.134435', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2130, '位于荆州区江津西路1号(观邸小区)第8栋的住宅房地产', '荆州-荆州', 203.33, '', 126.67, 6229.77, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11964810.html', '2026-02-23 12:54:23.139720', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2131, '荆州市沙市区塔桥路东63号荆州新天地B区5栋1层31号', '荆州-沙市', 72.25, '', 60.48, 8370.93, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11974162.html', '2026-02-23 12:54:23.145442', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2132, '荆州区荆州大道65号 (新乡理想家园)第3 栋1单元2层1号', '荆州-荆州区', 102.13, '', 39.02, 3820.62, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11997089.html', '2026-02-23 12:54:23.150659', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2133, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元3层2号', '荆州-荆州', 89.56, '', 33.74, 3767.31, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12004251.html', '2026-02-23 12:54:23.156403', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2134, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元3层1号', '荆州-荆州区', 121.75, '', 46.80, 3843.94, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12004361.html', '2026-02-23 12:54:23.163651', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2135, '荆州区荆州大道65号 (新乡理想家园)第2 栋1单元4层1号', '荆州-荆州区', 101.36, '', 39.21, 3868.39, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11999677.html', '2026-02-23 12:54:23.168930', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2136, '荆州市荆州区太湖港路与刘家台路交汇处(恒大金名都)第8栋2-2802号房地产', '荆州-荆州', 105.09, '', 45.40, 4320.11, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11974180.html', '2026-02-23 12:54:23.174631', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2137, '位于荆州市荆州开发区江津东路(人信.阳光青年城)13栋1单元2层1号的房地产', '荆州-沙市', 103.87, '', 34.61, 3332.05, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11972784.html', '2026-02-23 12:54:23.178404', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2138, '位于荆州市荆州开发区三湾路27号(恒隆四季城)10栋2单元12层1号的房地产', '荆州-沙市', 110.72, '', 46.13, 4166.37, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11975244.html', '2026-02-23 12:54:23.184158', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2139, '荆州区荆州大道65号 (新乡理想家园)第2 栋1单元2层2号', '荆州-荆州区', 70.08, '', 26.24, 3744.29, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12004174.html', '2026-02-23 12:54:23.189767', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2140, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元4层2号', '荆州-荆州区', 89.07, '', 33.78, 3792.52, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12004507.html', '2026-02-23 12:54:23.195473', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2141, '荆州市荆州区北京西路(万达广场)A1栋1单元5层502号房地产', '荆州-荆州', 138.48, '', 80.50, 5813.11, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11972641.html', '2026-02-23 12:54:23.201196', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2142, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元4层3号', '荆州-荆州', 89.56, '', 33.96, 3791.87, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11998762.html', '2026-02-23 12:54:23.207072', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2143, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元5层3号', '荆州-荆州区', 89.56, '', 34.18, 3816.44, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12002903.html', '2026-02-23 12:54:23.212552', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2144, '位于荆州市荆州区荆秘路(龙城怡景园) 7-1-303、7-1-502、7-1-503、7-1-603、7-1-902、7-1-1802、7-1-1803、7-1-2002室房屋', '荆州-荆州', 26.9, '', 210.29, 78174.72, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12023940.html', '2026-02-23 12:54:23.217648', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2145, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元4层1号', '荆州-荆州', 121.75, '', 47.10, 3868.58, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11998304.html', '2026-02-23 12:54:23.223082', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2146, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元4层4号', '荆州-荆州', 121.75, '', 47.10, 3868.58, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11999893.html', '2026-02-23 12:54:23.229288', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2147, '位于荆州市荆州开发区江津东路6号(金源世纪城)4号地块16栋1单元25层2号的房地', '荆州-沙市', 90.55, '', 31.55, 3484.26, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12007134.html', '2026-02-23 12:54:23.234529', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2148, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元4层2号', '荆州-荆州', 89.56, '', 33.96, 3791.87, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11999680.html', '2026-02-23 12:54:23.239794', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2149, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元2层1号', '荆州-荆州', 121.75, '', 46.51, 3820.12, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11997827.html', '2026-02-23 12:54:23.245534', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2150, '荆州区荆州大道65号 (新乡理想家园)第3 栋1单元4层2号', '荆州-荆州', 88.01, '', 33.38, 3792.75, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12003073.html', '2026-02-23 12:54:23.250698', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2151, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元2层3号', '荆州-荆州', 89.56, '', 33.53, 3743.86, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12005200.html', '2026-02-23 12:54:23.256993', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2152, '荆州区荆州大道65号 (新乡理想家园)第2 栋1单元2层1号', '荆州-荆州', 101.36, '', 38.72, 3820.05, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11998436.html', '2026-02-23 12:54:23.262088', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2153, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元4层3号', '荆州-荆州区', 89.07, '', 33.78, 3792.52, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11998065.html', '2026-02-23 12:54:23.267883', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2154, '位于荆州区人民北路20号(水榭花园B区)第318栋2单元坡层4号的房地产', '荆州-荆州', 81.78, '', 20.25, 2476.16, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12007128.html', '2026-02-23 12:54:23.273592', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2155, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元2层3号', '荆州-荆州区', 89.07, '', 33.34, 3743.12, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12005077.html', '2026-02-23 12:54:23.278748', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2156, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元3层3号', '荆州-荆州', 89.07, '', 33.56, 3767.82, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11997851.html', '2026-02-23 12:54:23.283937', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2157, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元3层2号', '荆州-荆州', 89.07, '', 33.56, 3767.82, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11999512.html', '2026-02-23 12:54:23.289720', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2158, '荆州区荆州大道65号 (新乡理想家园)第3 栋1单元3层3号', '荆州-荆州', 92.14, '', 34.72, 3768.18, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11999270.html', '2026-02-23 12:54:23.295508', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2159, '荆州区荆州大道65号 (新乡理想家园)第3 栋1单元2层3号', '荆州-荆州区', 92.14, '', 34.50, 3744.30, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11998963.html', '2026-02-23 12:54:23.301168', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2160, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元3层3号', '荆州-荆州', 89.56, '', 33.74, 3767.31, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12000240.html', '2026-02-23 12:54:23.306901', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2161, '荆州区荆州大道65号 (新乡理想家园)第4 栋1单元2层2号', '荆州-荆州', 89.56, '', 33.53, 3743.86, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11996907.html', '2026-02-23 12:54:23.311122', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2162, '位于荆州区人民北路20号(水榭花园B区)第558栋 1-坡层1号房地产', '荆州-荆州', 353.9, '', 272.53, 7700.76, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11959995.html', '2026-02-23 12:54:23.316796', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2163, '位于荆州市沙市区园林路116号荆州碧桂园2栋1单元22层2号的住宅房地产', '荆州-沙市区', 104.7, '', 53.07, 5068.77, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_11998356.html', '2026-02-23 12:54:23.320969', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2164, '位于荆州市荆州开发区江津东路6号(金源世纪城)2号地块11栋1单元16层4号的房地产', '荆州-沙市', 125.2, '', 41.19, 3289.94, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12007120.html', '2026-02-23 12:54:23.325646', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2165, '荆州区荆州大道65号 (新乡理想家园)第1 栋1单元2层4号', '荆州-荆州区', 121.75, '', 46.51, 3820.12, 'Fang', 'https://jingzhou.esf.fang.com/fapai/out_12005364.html', '2026-02-23 12:54:23.331942', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2166, '周口市郸城县教育社区 2室1厅 87.0平', '周口-新世纪广场', 87, '2室1厅', 43.00, 4942.53, 'Fang', 'https://zhoukou.esf.fang.com/chushou/16_5439287.htm', '2026-02-23 12:59:39.369170', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2167, '建业春天里 3室2厅 133.0平', '周口-周口市川汇区开元大道与中州大道交汇处向东200米路南', 133, '3室2厅', 60.00, 4511.28, 'Fang', 'https://zhoukou.esf.fang.com/chushou/16_5339344.htm', '2026-02-23 12:59:39.379094', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2168, '周口万科溥天龙堂 3室2厅 116.0平', '周口-万顺达', 116, '3室2厅', 80.00, 6896.55, 'Fang', 'https://zhoukou.esf.fang.com/chushou/16_5128760.htm', '2026-02-23 12:59:39.384253', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2169, '景园·盛世华都 2室2厅 122.6平', '周口-关帝庙', 122.6, '2室2厅', 61.00, 4975.53, 'Fang', 'https://zhoukou.esf.fang.com/chushou/16_5391851.htm', '2026-02-23 12:59:39.389398', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2170, '山水郡府 2室2厅 92.99平', '周口-关帝庙', 92.99, '2室2厅', 37.00, 3978.92, 'Fang', 'https://zhoukou.esf.fang.com/chushou/16_5333233.htm', '2026-02-23 12:59:39.395099', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2171, '周口碧桂园 3室2厅 120.0平', '周口-万顺达', 120, '3室2厅', 158.00, 13166.67, 'Fang', 'https://zhoukou.esf.fang.com/chushou/16_5454005.htm', '2026-02-23 12:59:39.400224', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2172, '河南省周口市川汇区新街小区5号楼2单元205号房产', '周口-川汇', 69.21, '', 13.77, 1989.60, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12013245.html', '2026-02-23 12:59:39.412675', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2173, '河南省周口市川汇区交通大道北侧、红旗四路西侧万科溥天龙堂兴龙轩16号楼1单元2902号房产', '周口-川汇', 94.76, '', 45.63, 4815.32, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009594.html', '2026-02-23 12:59:39.418718', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2174, '周口市川汇区周淮路南侧、泰山路西侧周口恒大名都14号楼2单元3008号住宅', '周口-川汇', 148.79, '', 60.00, 4032.53, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12014968.html', '2026-02-23 12:59:39.423454', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2175, '位于河南省周口市鹿邑县卫真办事处城角居民委员会法姬娜·欧洲城柏林风情?3 # 1 单元 1 - 102号房地产', '周口-鹿邑', 117.47, '', 36.00, 3064.61, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12021316.html', '2026-02-23 12:59:39.429034', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2176, '河南省周口市川汇区腾飞路东侧,桂园路北侧,文体路南侧,新一路西侧周口碧桂园天玺湾一期26号楼1单元202号房产', '周口-川汇', 134.31, '', 65.88, 4905.07, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12012811.html', '2026-02-23 12:59:39.433226', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2177, '河南省周口市郸城县新城交通路郸城国际城住宅小区11号楼1单元1003', '周口-郸城', 118.62, '', 33.66, 2837.63, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017929.html', '2026-02-23 12:59:39.438281', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2178, '河南省周口市川汇区纬二路北侧、经二路西侧建业?未来城12号楼3单元605号房产', '周口-川汇', 15, '', 45.41, 30273.33, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009597.html', '2026-02-23 12:59:39.443322', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2179, '位于河南省周口市淮阳区北关龙都大道东侧油坊庄房产', '周口-淮阳', 274.5, '', 36.30, 1322.40, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11987015.html', '2026-02-23 12:59:39.448656', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2180, '河南省周口市川汇区文昌路南侧,新民路西侧周口佳利幸福花开8号楼1单元2602房产', '周口-川汇区', 82.1, '', 23.31, 2839.22, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009602.html', '2026-02-23 12:59:39.452717', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2181, '河南省周口市川汇区文体路南侧、桂园路北侧周口碧桂园79号楼1单元2302号房产', '周口-川汇', 105.32, '', 48.03, 4560.39, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009587.html', '2026-02-23 12:59:39.458244', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2182, '河南省周口市郸城县交通路郸城金域华府小区(一期)10号楼1单元402室{不动产权证号:豫(2023)郸城县不动产权第0041952号}不动产一处', '周口-郸城', 118.66, '', 40.00, 3370.98, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11976444.html', '2026-02-23 12:59:39.463285', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2183, '河南省周口市西华县箕城上院八号楼101号房产', '周口-西华', 138.58, '', 43.94, 3170.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12021098.html', '2026-02-23 12:59:39.468474', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2184, '河南省周口市西华县箕城上院七号楼2401号房产', '周口-西华', 141.96, '', 46.39, 3267.82, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017907.html', '2026-02-23 12:59:39.473011', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2185, '河南省周口市川汇区七一路与大庆路交叉口金泰王朝11号楼1单元2601号房产', '周口-川汇区', 140.56, '', 52.50, 3735.06, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017049.html', '2026-02-23 12:59:39.477557', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2186, '河南省周口市沈丘县槐店回族镇沙南产业集聚区育才小区5#教师公寓楼104', '周口-沈丘县', 128.95, '', 29.80, 2310.97, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11896703.html', '2026-02-23 12:59:39.483315', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2187, '河南省周口市川汇区大闸路东侧金汇花园一期2号楼3单元502住宅', '周口-川汇', 144.92, '', 31.54, 2176.37, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12026517.html', '2026-02-23 12:59:39.488387', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2188, '河南省周口市川汇区周商路东侧2号楼2单元102房产', '周口-川汇', 146.49, '', 43.00, 2935.35, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12028571.html', '2026-02-23 12:59:39.493534', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2189, '河南省周口市川汇区碧桂园天玺湾一期13号楼2单元1404号房产', '周口-川汇', 134.35, '', 64.99, 4837.37, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009589.html', '2026-02-23 12:59:39.498073', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2190, '河南省周口市郸城县新城交通路郸城国际城住宅小区5号楼1单元101', '周口-郸城', 135.19, '', 38.11, 2819.00, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12016825.html', '2026-02-23 12:59:39.502714', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2191, '河南省周口市川汇区车站路川汇区黄河路41号盛世家园', '周口-川汇', 118.03, '', 42.39, 3591.46, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009599.html', '2026-02-23 12:59:39.507661', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2192, '河南省周口市商水县周商路中段西侧融辉城一期A9号楼1单元802号房产', '周口-商水', 87.08, '', 32.53, 3735.65, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009588.html', '2026-02-23 12:59:39.512224', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2193, '周口久鸿农贸市场开发有限公司所有的位于郸城县科技大道与东明路交叉口东南角A6号楼3-4层A301号房产', '周口-郸城', 186.49, '', 25.60, 1372.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12029846.html', '2026-02-23 12:59:39.517884', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2194, '周口久鸿农贸市场开发有限公司所有的位于郸城县科技大道与东明路交叉口东南角A6号楼3-4层A302号房产', '周口-郸城', 186.49, '', 25.60, 1372.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12033137.html', '2026-02-23 12:59:39.521990', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2195, '河南省周口市川汇区汉阳路南段西侧巴黎左岸16号楼1单元602号住宅', '周口-川汇', 130.86, '', 60.48, 4621.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11950835.html', '2026-02-23 12:59:39.527551', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2196, '河南省周口市鹿邑县鸣鹿办事处尚品天成8#楼2单元2-601', '周口-鹿邑县', 121.6, '', 41.86, 3442.43, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11926014.html', '2026-02-23 12:59:39.532106', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2197, '周口市商水县殷川大道一号亚龙国际居然之家8号楼332号', '周口-商水', 93.74, '', 29.75, 3173.67, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11951401.html', '2026-02-23 12:59:39.537396', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2198, '河南省周口市西华县箕城上院六号楼1303号商铺', '周口-西华', 119.43, '', 39.03, 3268.02, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017392.html', '2026-02-23 12:59:39.542508', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2199, '河南省周口市西华县箕城上院七号楼101号房产', '周口-西华', 138.58, '', 43.94, 3170.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017061.html', '2026-02-23 12:59:39.547924', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2200, '河南省周口市川汇区莲花路隆达花园7号楼1单元602室', '周口-川汇', 165.66, '', 31.81, 1920.20, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12034119.html', '2026-02-23 12:59:39.553010', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2201, '河南省周口市川汇区交通路北侧、红旗三路西侧建业壹号城邦7号楼一单元2601号房屋', '周口-川汇', 134.08, '', 52.89, 3944.66, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12012310.html', '2026-02-23 12:59:39.558616', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2202, '河南省周口市西华县箕城上院二号楼1504号房产', '周口-西华县', 143.62, '', 46.94, 3268.35, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017371.html', '2026-02-23 12:59:39.563452', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2203, '河南省周口市西华县箕城上院六号楼2601号住宅', '周口-西华', 143.65, '', 44.13, 3072.05, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12016681.html', '2026-02-23 12:59:39.568517', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2204, '河南省周口市郸城县胡集乡郸城县学府春天6号楼1单元602', '周口-郸城', 139.27, '', 57.62, 4137.29, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12026135.html', '2026-02-23 12:59:39.574105', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2205, '河南省周口市郸城县新城交通路郸城国际城住宅小区11号楼1单元1103', '周口-郸城', 118.62, '', 33.67, 2838.48, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12019587.html', '2026-02-23 12:59:39.579196', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2206, '周口市西华县箕城上院九号楼2603号房产', '周口-西华', 117.95, '', 36.24, 3072.49, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12020118.html', '2026-02-23 12:59:39.583568', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2207, '河南省周口市川汇区人和路以西、淮阳路以南周口天明城名门府邸(二期)2-20号楼1单元1003号房产', '周口-川汇', 98.26, '', 35.75, 3638.31, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009592.html', '2026-02-23 12:59:39.588896', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2208, '河南省周口市郸城县学府春天小区3号楼1单元202房', '周口-郸城', 144.83, '', 53.74, 3710.56, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12021950.html', '2026-02-23 12:59:39.594042', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2209, '周口久鸿农贸市场开发有限公司所有的位于郸城县科技大道与东明路交叉口东南角A6号楼3-4层A303号房产', '周口-郸城', 186.49, '', 25.60, 1372.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12027886.html', '2026-02-23 12:59:39.600235', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2210, '周口市川汇区中州路与纬二路东北角翔宇花园37号楼3单元206', '周口-川汇', 113.34, '', 43.11, 3803.60, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11964657.html', '2026-02-23 12:59:39.604860', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2211, '周口市川汇区八一路与太昊路东南角香榭丽舍10号楼1单元605号', '周口-商水县', 142.76, '', 45.94, 3217.99, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11870910.html', '2026-02-23 12:59:39.609271', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2212, '河南省周口市商水县周商路中段西侧融辉城C28号楼2单元301号房产', '周口-商水', 130.02, '', 51.41, 3954.01, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12032309.html', '2026-02-23 12:59:39.614455', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2213, '河南省周口市川汇区周商路南段西侧恒基小区2幢一单元1003号房产', '周口-川汇', 105.02, '', 27.18, 2588.08, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11956897.html', '2026-02-23 12:59:39.619873', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2214, '河南省周口市川汇区开元大道南侧、毛楼西侧周口建业春天里17号楼1单元102住宅', '周口-川汇', 160.46, '', 82.68, 5152.69, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12009601.html', '2026-02-23 12:59:39.624502', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2215, '商水县周商大道中段东侧周口慈善公益园(美景康城)10号楼1单元202室', '周口-商水', 132.03, '', 35.07, 2656.21, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11950037.html', '2026-02-23 12:59:39.630628', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2216, '河南省周口市西华县箕城上院二号楼2701号房产', '周口-西华县', 143.62, '', 44.12, 3072.00, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12017919.html', '2026-02-23 12:59:39.635674', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2217, '坐落于河南省周口市郸城县胡集乡郸城县学府春天3号楼1单元601、701', '周口-郸城', 146.75, '', 113.29, 7719.93, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12023973.html', '2026-02-23 12:59:39.640751', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2218, '周口久鸿农贸市场开发有限公司所有的位于郸城县科技大道与东明路交叉口东南角A5号楼3-4层A301号房产', '周口-郸城', 186.49, '', 25.60, 1372.73, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_12032965.html', '2026-02-23 12:59:39.645280', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2219, '河南省周口市川汇区交通路北侧、红旗三路西侧建业壹号城邦6号楼2单元2204号房产', '周口-川汇', 134.21, '', 56.70, 4224.72, 'Fang', 'https://zhoukou.esf.fang.com/fapai/out_11949509.html', '2026-02-23 12:59:39.651592', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2220, '凤凰国际 3室2厅 131.0平', '大同-城区', 131, '3室2厅', 49.00, 3740.46, 'Fang', 'https://datong.esf.fang.com/chushou/16_4616134.htm', '2026-02-25 02:31:05.073594', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2221, '凤凰国际 3室2厅 131.8平', '大同-城区', 131.8, '3室2厅', 49.00, 3717.75, 'Fang', 'https://datong.esf.fang.com/chushou/16_5320514.htm', '2026-02-25 02:31:05.081242', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2222, '水泉湾龙园 3室2厅 145.95平', '大同-城区', 145.95, '3室2厅', 115.00, 7879.41, 'Fang', 'https://datong.esf.fang.com/chushou/16_5408514.htm', '2026-02-25 02:31:05.086820', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2223, '宏洋美都 1室1厅 68.15平', '大同-西环路', 68.15, '1室1厅', 36.00, 5282.47, 'Fang', 'https://datong.esf.fang.com/chushou/16_5374508.htm', '2026-02-25 02:31:05.091819', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2224, '福园小区 2室1厅 68.0平', '大同-南郊', 68, '2室1厅', 5.00, 735.29, 'Fang', 'https://datong.esf.fang.com/chushou/16_5434006.htm', '2026-02-25 02:31:05.095818', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2225, '凯顺佳园 2室1厅 102.0平', '大同-西环路', 102, '2室1厅', 50.00, 4901.96, 'Fang', 'https://datong.esf.fang.com/chushou/16_5339111.htm', '2026-02-25 02:31:05.102262', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2226, '尚郡翠林苑 2室2厅 89.0平', '大同-火车站', 89, '2室2厅', 39.00, 4382.02, 'Fang', 'https://datong.esf.fang.com/chushou/16_5188101.htm', '2026-02-25 02:31:05.108087', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2227, '鸿儒小区 2室2厅 99.98平', '大同-城区', 99.98, '2室2厅', 54.00, 5401.08, 'Fang', 'https://datong.esf.fang.com/chushou/16_5352279.htm', '2026-02-25 02:31:05.113534', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2228, '福兴园 2室1厅 56.0平', '大同-城区', 56, '2室1厅', 26.00, 4642.86, 'Fang', 'https://datong.esf.fang.com/chushou/16_5357244.htm', '2026-02-25 02:31:05.119540', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2229, '大同碧桂园 4室2厅 148.0平', '大同-未知', 148, '4室2厅', 136.00, 9189.19, 'Fang', 'https://datong.esf.fang.com/chushou/8_1012779137.htm', '2026-02-25 02:31:05.123777', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2230, '大同碧桂园 4室2厅 209.0平', '大同-未知', 209, '4室2厅', 190.00, 9090.91, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606656.htm', '2026-02-25 02:31:05.129259', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2231, '大同碧桂园 5室2厅 275.0平', '大同-未知', 275, '5室2厅', 210.00, 7636.36, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606670.htm', '2026-02-25 02:31:05.134538', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2232, '大同碧桂园 4室2厅 209.0平', '大同-未知', 209, '4室2厅', 163.00, 7799.04, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606658.htm', '2026-02-25 02:31:05.139718', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2233, '大同碧桂园 4室2厅 209.0平', '大同-未知', 209, '4室2厅', 230.00, 11004.78, 'Fang', 'https://datong.esf.fang.com/chushou/8_1017012072.htm', '2026-02-25 02:31:05.144078', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2234, '【新】大同碧桂园别墅上三下一 前后院双车库双教育', '大同-未知', 260, '', 430.00, 16538.46, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606662.htm', '2026-02-25 02:31:05.149537', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2235, '大同碧桂园 3室2厅 126.6平', '大同-未知', 126.6, '3室2厅', 112.00, 8846.76, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606640.htm', '2026-02-25 02:31:05.154274', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2236, '大同碧桂园 4室2厅 209.0平', '大同-未知', 209, '4室2厅', 188.80, 9033.49, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606650.htm', '2026-02-25 02:31:05.159350', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2237, '【新】大同碧桂园别墅上三下一前后侧院双车位双教育', '大同-未知', 259, '', 380.00, 14671.81, 'Fang', 'https://datong.esf.fang.com/chushou/8_1017400593.htm', '2026-02-25 02:31:05.164840', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2238, '大同碧桂园 5室2厅 234.63平', '大同-未知', 234.63, '5室2厅', 239.00, 10186.25, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606659.htm', '2026-02-25 02:31:05.170084', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2239, '大同大学专家公寓 3室2厅 134.17平', '大同-未知', 134.17, '3室2厅', 89.80, 6693.00, 'Fang', 'https://datong.esf.fang.com/chushou/8_1017356878.htm', '2026-02-25 02:31:05.174472', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2240, '金色水岸龙园 5室3厅 270.0平', '大同-城区', 270, '5室3厅', 137.00, 5074.07, 'Fang', 'https://datong.esf.fang.com/chushou/8_1013693403.htm', '2026-02-25 02:31:05.179311', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2241, '大同碧桂园 3室1厅 275.0平', '大同-未知', 275, '3室1厅', 168.90, 6141.82, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606669.htm', '2026-02-25 02:31:05.184939', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2242, '大同碧桂园 5室2厅 285.48平', '大同-未知', 285.48, '5室2厅', 225.00, 7881.46, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606672.htm', '2026-02-25 02:31:05.189966', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2243, '大同大学专家公寓 3室2厅 157.0平', '大同-未知', 157, '3室2厅', 108.00, 6878.98, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001611619.htm', '2026-02-25 02:31:05.195952', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2244, '大同碧桂园4室2厅南西北', '大同-未知', 260, '', 389.60, 14984.62, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606661.htm', '2026-02-25 02:31:05.200953', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2245, '大同一中柳航里小区 2室1厅 54.5平', '大同-城区', 54.5, '2室1厅', 38.00, 6972.48, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606959.htm', '2026-02-25 02:31:05.206952', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2246, '凯利佳园 2室2厅 108.0平', '大同-未知', 108, '2室2厅', 31.50, 2916.67, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001612646.htm', '2026-02-25 02:31:05.211676', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2247, '大同一中柳航里小区 2室1厅 56.0平', '大同-城区', 56, '2室1厅', 26.00, 4642.86, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606966.htm', '2026-02-25 02:31:05.216680', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2248, '大同一中柳航里小区 2室1厅 56.0平', '大同-城区', 56, '2室1厅', 26.00, 4642.86, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606967.htm', '2026-02-25 02:31:05.221680', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2249, '富力城1期瀛湖湾 3室2厅 142.0平', '大同-未知', 142, '3室2厅', 78.50, 5528.17, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001611800.htm', '2026-02-25 02:31:05.228189', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2250, '化纤厂二生活区 2室1厅 58.0平', '大同-未知', 58, '2室1厅', 22.90, 3948.28, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001612366.htm', '2026-02-25 02:31:05.232189', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2251, '凯顺佳园 2室1厅 98.0平', '大同-西环路', 98, '2室1厅', 46.00, 4693.88, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001616945.htm', '2026-02-25 02:31:05.238189', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2252, '凯旋城 2室1厅 97.0平', '大同-御河西路', 97, '2室1厅', 52.00, 5360.82, 'Fang', 'https://datong.esf.fang.com/chushou/8_1014209739.htm', '2026-02-25 02:31:05.243075', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2253, '大同一中柳航里小区 2室1厅 60.0平', '大同-城区', 60, '2室1厅', 20.00, 3333.33, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606981.htm', '2026-02-25 02:31:05.248072', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2254, '峰景山水 2室1厅 81.0平', '大同-未知', 81, '2室1厅', 23.60, 2913.58, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001611707.htm', '2026-02-25 02:31:05.252778', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2255, '大同一中柳航里小区 2室1厅 57.0平', '大同-城区', 57, '2室1厅', 24.80, 4350.88, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606976.htm', '2026-02-25 02:31:05.258778', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2256, '大同碧桂园 5室2厅 275.0平', '大同-未知', 275, '5室2厅', 200.00, 7272.73, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606668.htm', '2026-02-25 02:31:05.263778', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2257, '大同一中柳航里小区 2室1厅 57.0平', '大同-城区', 57, '2室1厅', 22.00, 3859.65, 'Fang', 'https://datong.esf.fang.com/chushou/8_1018153973.htm', '2026-02-25 02:31:05.268778', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2258, '大同一中柳航里小区 2室1厅 54.32平', '大同-城区', 54.32, '2室1厅', 29.60, 5449.19, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606958.htm', '2026-02-25 02:31:05.273459', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2259, '大同碧桂园 3室2厅 177.0平', '大同-未知', 177, '3室2厅', 150.00, 8474.58, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606644.htm', '2026-02-25 02:31:05.278885', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2260, '大同一中柳航里小区 2室1厅 55.0平', '大同-城区', 55, '2室1厅', 29.80, 5418.18, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606962.htm', '2026-02-25 02:31:05.283681', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2261, '大同一中柳航里小区 2室1厅 44.0平', '大同-城区', 44, '2室1厅', 28.00, 6363.64, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606949.htm', '2026-02-25 02:31:05.289035', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2262, '柳航里 3室1厅 128.0平', '大同-城区', 128, '3室1厅', 86.00, 6718.75, 'Fang', 'https://datong.esf.fang.com/chushou/8_1013693056.htm', '2026-02-25 02:31:05.294034', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2263, '大同大学专家公寓 3室2厅 145.0平', '大同-未知', 145, '3室2厅', 93.00, 6413.79, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001611616.htm', '2026-02-25 02:31:05.298035', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2264, '兴梓园A区 3室1厅 87.32平', '大同-未知', 87.32, '3室1厅', 32.00, 3664.68, 'Fang', 'https://datong.esf.fang.com/chushou/8_1015672261.htm', '2026-02-25 02:31:05.303209', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2265, '金色水岸龙园 2室2厅 103.41平', '大同-城区', 103.41, '2室2厅', 63.00, 6092.25, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001617506.htm', '2026-02-25 02:31:05.308357', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2266, '大同一中柳航里小区 1室1厅 55.0平', '大同-城区', 55, '1室1厅', 39.00, 7090.91, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606961.htm', '2026-02-25 02:31:05.314956', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2267, '大同碧桂园 5室2厅 275.0平', '大同-未知', 275, '5室2厅', 190.00, 6909.09, 'Fang', 'https://datong.esf.fang.com/chushou/8_1017765579.htm', '2026-02-25 02:31:05.320304', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2268, '万城华府 4室2厅 177.36平', '大同-南环路', 177.36, '4室2厅', 84.70, 4775.60, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001615331.htm', '2026-02-25 02:31:05.325305', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2269, '大同一中柳航里小区 3室1厅 80.0平', '大同-城区', 80, '3室1厅', 40.00, 5000.00, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606994.htm', '2026-02-25 02:31:05.329811', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2270, '大同大学专家公寓 3室2厅 134.17平', '大同-未知', 134.17, '3室2厅', 80.00, 5962.58, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001611612.htm', '2026-02-25 02:31:05.334562', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2271, '大同一中柳航里小区 2室1厅 56.65平', '大同-城区', 56.65, '2室1厅', 29.00, 5119.15, 'Fang', 'https://datong.esf.fang.com/chushou/8_1011194182.htm', '2026-02-25 02:31:05.340077', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2272, '大同一中柳航里小区 2室1厅 57.0平', '大同-城区', 57, '2室1厅', 24.00, 4210.53, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606979.htm', '2026-02-25 02:31:05.344811', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2273, '大同一中柳航里小区 2室1厅 56.0平', '大同-城区', 56, '2室1厅', 33.00, 5892.86, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606965.htm', '2026-02-25 02:31:05.348934', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2274, '大同一中柳航里小区 3室1厅 61.71平', '大同-城区', 61.71, '3室1厅', 29.30, 4748.01, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001606983.htm', '2026-02-25 02:31:05.354769', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2275, '大同一中柳航里小区 2室1厅 56.65平', '大同-城区', 56.65, '2室1厅', 23.60, 4165.93, 'Fang', 'https://datong.esf.fang.com/chushou/8_1013938725.htm', '2026-02-25 02:31:05.359764', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2276, '大同大学专家公寓 3室2厅 130.0平', '大同-未知', 130, '3室2厅', 82.60, 6353.85, 'Fang', 'https://datong.esf.fang.com/chushou/8_1012779356.htm', '2026-02-25 02:31:05.365246', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2277, '大同一中柳航里小区 2室2厅 65.67平', '大同-城区', 65.67, '2室2厅', 27.50, 4187.60, 'Fang', 'https://datong.esf.fang.com/chushou/8_1013693026.htm', '2026-02-25 02:31:05.370291', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2278, '紫山城 2室2厅 99.0平', '大同-未知', 99, '2室2厅', 36.00, 3636.36, 'Fang', 'https://datong.esf.fang.com/chushou/8_1016782323.htm', '2026-02-25 02:31:05.374528', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `spider_house` VALUES (2279, '大同大学专家公寓 3室2厅 135.0平', '大同-未知', 135, '3室2厅', 94.00, 6962.96, 'Fang', 'https://datong.esf.fang.com/chushou/8_1001611615.htm', '2026-02-25 02:31:05.379539', NULL, NULL, NULL, NULL, NULL, NULL);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of system_config
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
