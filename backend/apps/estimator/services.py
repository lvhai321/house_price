import re
import pandas as pd
import numpy as np
from decimal import Decimal
from django.db.models import Avg, F
from django.db.models.functions import Abs
from sklearn.ensemble import RandomForestRegressor
from apps.spider.models import House
from .models import EstimationHistory

class PriceEstimator:
    """
    房价估算核心服务
    结合两条思路：基于相似房源的经验加权 + 随机森林机器学习。
    小样本时依赖经验法，样本充足时引入随机森林并与经验法融合。
    """
    
    # 特征映射表：将分类字符串转为数值，便于机器学习模型处理
    DECORATION_MAP = {'rough': 0, 'simple': 1, 'exquisite': 2}
    FLOOR_MAP = {'low': 0, 'mid': 1, 'high': 2}
    ORIENTATION_MAP = {'south': 3, 'east': 2, 'west': 1, 'north': 0} # 朝向权重：南 > 东 > 西 > 北

    def __init__(self, query_params):
        """
        初始化估价引擎。
        
        参数:
            query_params (dict): 前端传来的房源特征字典，包含：
            - region (str): 区域（如：武汉-白沙洲）
            - area (float): 建筑面积 (㎡)
            - layout (str): 户型（如：3室2厅）
            - has_subway (bool): 是否靠近地铁站
            - is_school_district (bool): 是否属于优质学区
            - floor_type (str): 楼层高低 ('low', 'mid', 'high')
            - building_age (int): 建筑房龄（年）
            - decoration (str): 装修程度 ('rough'-毛坯, 'simple'-简装, 'exquisite'-精装)
            - orientation (str): 房屋朝向 ('south'-南, 'north'-北, 'east'-东, 'west'-西)
        """
        self.params = query_params
        self.similar_houses = []
    
    def parse_layout(self, layout_str):
        """
        解析户型字符串（如“2室1厅”）为 (室数, 厅数) 元组，便于比较。
        """
        if not layout_str:
            return (0, 0)
        shi = re.search(r'(\d+)室', layout_str)
        ting = re.search(r'(\d+)厅', layout_str)
        s = int(shi.group(1)) if shi else 0
        t = int(ting.group(1)) if ting else 0
        return (s, t)

    def calculate_similarity(self, house):
        """
        计算相似度（满分 100）：
        - 区域匹配 40 分（包含关系记 30 分）
        - 面积接近 30 分（10%内满分，20%/30%递减）
        - 户型相似 20 分（完全一致满分，室数差 1 间降分）
        - 基础分 10 分（默认给 5 分）
        """
        score = 0
        
        # 1. 区域匹配度计算
        if house.region == self.params['region']:
            score += 40
        else:
            if self.params['region'] in house.region or house.region in self.params['region']:
                score += 30
        
        # 2. 面积接近度计算
        diff_pct = abs(house.area - self.params['area']) / self.params['area']
        if diff_pct <= 0.10:
            score += 30
        elif diff_pct <= 0.20:
            score += 20
        elif diff_pct <= 0.30:
            score += 10
            
        # 3. 户型相似度计算
        q_shi, q_ting = self.parse_layout(self.params['layout'])
        h_shi, h_ting = self.parse_layout(house.layout)
        
        if q_shi == h_shi and q_ting == h_ting:
            score += 20
        elif abs(q_shi - h_shi) == 1:
            score += 10
        elif q_shi == h_shi:
            score += 15
            
        # 4. 基础分
        score += 5
        
        return score

    def find_similar_houses(self):
        """
        搜索相似房源（带降级策略）：
        - 第一层：同区域，面积在目标的 ±40%
        - 第二层：若不足 5 条，放宽到 ±60%
        - 第三层：若仍不足，仅按区域匹配
        按相似度打分并排序返回。
        """
        area = self.params['area']
        
        # 策略一：标准搜索
        qs = House.objects.filter(
            region__icontains=self.params['region'],
            area__gte=area * 0.6,
            area__lte=area * 1.4
        )
        
        # 策略二：如果数据太少，放宽面积限制
        if qs.count() < 5:
            qs = House.objects.filter(
                region__icontains=self.params['region'],
                area__gte=area * 0.4,
                area__lte=area * 1.6
            )
            
            # 策略三：极端情况，只管区域，不管面积
            if qs.count() < 5:
                qs = House.objects.filter(region__icontains=self.params['region'])
        
        scored_houses = []
        for h in qs:
            score = self.calculate_similarity(h)
            # 根据搜索结果的数量，动态调整入选分数门槛
            min_score = 30 if qs.count() < 5 else 50
            if score >= min_score: 
                scored_houses.append((h, score))
        
        # 按相似度分数从高到低排序
        self.similar_houses = sorted(scored_houses, key=lambda x: x[1], reverse=True)
        return self.similar_houses

    def get_search_results(self):
        """
        获取该区域贴近面积的房源列表（仅用于展示，不参与估价计算）。
        优先返回面积在目标的 ±20%（不足则放宽至 ±40%），
        并按面积差绝对值升序、id 降序排序。
        """
        # 面积贴近策略：优先返回与用户输入面积更接近的房源
        target_area = float(self.params['area'])
        region_kw = self.params['region']
        
        # 1) 首选 ±20% 面积范围
        qs = House.objects.filter(
            region__icontains=region_kw,
            area__gte=target_area * 0.8,
            area__lte=target_area * 1.2
        )
        # 2) 若不足，放宽至 ±40%
        if qs.count() < 5:
            qs = House.objects.filter(
                region__icontains=region_kw,
                area__gte=target_area * 0.6,
                area__lte=target_area * 1.4
            )
            # 3) 极端情况，仅按区域匹配
            if qs.count() < 5:
                qs = House.objects.filter(region__icontains=region_kw)
        
        # 最终按“面积差绝对值”升序、id降序排序，返回前5条
        qs = qs.annotate(
            area_diff=Abs(F('area') - target_area)
        ).order_by('area_diff', '-id')[:5]
        
        return qs

    def calculate_base_price(self):
        """
        计算基础价（不含系数）：
        1) 过滤异常单价（<2000 或 >200000 元/㎡）
        2) 用相似度作为权重做加权单价
        3) 加权单价 × 面积 = 基础总价
        """
        if not self.similar_houses:
            return None
            
        # 异常值过滤：剔除可能干扰结果的极端单价
        valid_houses = [
            (h, s) for h, s in self.similar_houses 
            if 2000 <= h.unit_price <= 200000
        ]
        
        if not valid_houses:
             valid_houses = self.similar_houses
             
        total_score = sum(s for h, s in valid_houses)
        
        # 执行加权平均计算
        weighted_unit_price = sum(h.unit_price * Decimal(s) for h, s in valid_houses) / Decimal(total_score)
        base_total = weighted_unit_price * Decimal(self.params['area'])
        return base_total

    def get_city_benchmark_price(self, region):
        """
        兜底：返回城市/板块的预设基准单价（元/㎡）。
        先精确匹配，再模糊匹配；都没有时用三线城市水平。
        """
        region_lower = region.lower()
        try:
            # 如果包含中文，尝试转为拼音进行匹配
            if any('\u4e00' <= ch <= '\u9fff' for ch in region):
                from pypinyin import lazy_pinyin
                region_lower = ''.join(lazy_pinyin(region)).lower()
        except Exception:
            region_lower = region.lower()
        
        # 预设的各主要城市及热门板块基准价 (单位: 元/㎡)
        benchmarks = {
            'bj': 55000, 'beijing': 55000,
            'sh': 58000, 'shanghai': 58000,
            'sz': 56000, 'shenzhen': 56000,
            'gz': 32000, 'guangzhou': 32000,
            'hz': 28000, 'hangzhou': 28000,
            'wh': 16000, 'wuhan': 16000,
            'cd': 15000, 'chengdu': 15000,
            'chaoyang': 58000, 'haidian': 85000,
            'pudong': 52000, 'huangpu': 80000,
        }
        
        # 优先精准匹配，其次模糊匹配
        if region_lower in benchmarks:
            return Decimal(benchmarks[region_lower])
            
        for key, price in benchmarks.items():
            if key in region_lower:
                return Decimal(price)
                
        # 最终兜底价格（按三线城市水平设定）
        return Decimal(10000)

    def get_adjustment_factor(self):
        """
        计算价格修正系数：
        - 地铁 +6.5%，学区 +11.5%
        - 楼层：高 +4%，低 -4%
        - 房龄：每年折旧 0.75%，最多 30%
        - 装修：精装 +7.5%，毛坯 -6.5%
        - 朝向：南 +4%，北 -2.5%
        """
        factor = 1.0
        
        if self.params.get('has_subway'):
            factor *= 1.065
            
        if self.params.get('is_school_district'):
            factor *= 1.115
            
        ft = self.params.get('floor_type')
        if ft == 'high':
            factor *= 1.04
        elif ft == 'low':
            factor *= 0.96
            
        age = self.params.get('building_age', 0)
        if age > 0:
            depreciation = min(age * 0.0075, 0.30)
            factor *= (1 - depreciation)
            
        dec = self.params.get('decoration')
        if dec == 'exquisite':
            factor *= 1.075
        elif dec == 'rough':
            factor *= 0.935
            
        ori = self.params.get('orientation')
        if ori == 'south':
            factor *= 1.04
        elif ori == 'north':
            factor *= 0.975
            
        return factor

    def _estimate_by_rf(self, similar_houses):
        """
        随机森林即时预测（样本 ≥10）：
        1) 组装训练集（面积/室/厅 → 单价）
        2) 用 3-Sigma 清理异常单价
        3) 训练 50 棵树的回归模型
        4) 提取特征重要性（可解释）
        5) 预测单价并乘面积与修正系数
        """
        if len(similar_houses) < 10: # 如果样本太少，RF效果不佳
            return None, {}
            
        # 1. 构造训练数据集
        train_data = []
        for h, score in similar_houses:
            s, t = self.parse_layout(h.layout)
            train_data.append({
                'area': float(h.area),
                'shi': s,
                'ting': t,
                'price': float(h.unit_price) # Label: 单位单价
            })
            
        df = pd.DataFrame(train_data)
        
        # --- [新增] 异常值过滤 (3-Sigma) ---
        # 目的：剔除价格过高或过低的“脏数据”，提高模型鲁棒性
        if len(df) > 5:
            mean_price = df['price'].mean()
            std_price = df['price'].std()
            if std_price > 0:
                df_clean = df[
                    (df['price'] >= mean_price - 2 * std_price) & 
                    (df['price'] <= mean_price + 2 * std_price)
                ]
            else:
                df_clean = df
                
            # 如果过滤后数据太少，回退使用原始数据
            if len(df_clean) < 5:
                df_clean = df
        else:
            df_clean = df

        X = df_clean.drop('price', axis=1)
        y = df_clean['price']
        
        # 2. 实时训练模型
        model = RandomForestRegressor(n_estimators=50, random_state=42)
        model.fit(X, y)
        
        # --- [新增] 提取特征重要性 ---
        # 目的：让算法具有可解释性，知道是面积、室数还是厅数在影响价格
        importances = model.feature_importances_
        feature_names = ['area', 'shi', 'ting'] # 与 X 的列对应
        feature_importance = {}
        if len(importances) == len(feature_names):
             feature_importance = dict(zip(feature_names, [round(float(x), 4) for x in importances]))

        # 3. 构造预测特征
        q_s, q_t = self.parse_layout(self.params.get('layout'))
        predict_features = pd.DataFrame([{
            'area': float(self.params['area']),
            'shi': q_s,
            'ting': q_t
        }])
        
        # 4. 得到预测单价 (Base)
        predicted_base_unit_price = model.predict(predict_features)[0]
        
        # 5. 同样应用调节系数（使 RF 预测值更具实际参考意义）
        factor = self.get_adjustment_factor()
        final_predicted_price = Decimal(predicted_base_unit_price) * Decimal(self.params['area']) * Decimal(factor)
        
        return final_predicted_price, feature_importance

    def estimate(self):
        """
        估价流程：
        1) 找相似房源
        2) 经验法估价并应用修正系数
        3) 若样本充足，进行随机森林预测
        4) 成功则 70% RF + 30% 经验法融合，否则仅用经验法
        返回最终价、区间、相似房源与特征重要性。
        """
        self.find_similar_houses()
        
        # --- 算法 A: 启发式估价 ---
        base_price_heuristic = Decimal(0)
        if not self.similar_houses:
            avg_data = House.objects.filter(region__icontains=self.params['region']).aggregate(Avg('unit_price'))
            avg_price = avg_data.get('unit_price__avg')
            if avg_price:
                base_price_heuristic = Decimal(avg_price) * Decimal(self.params['area'])
            else:
                benchmark = self.get_city_benchmark_price(self.params['region'])
                base_price_heuristic = benchmark * Decimal(self.params['area'])
        else:
            base_price_heuristic = self.calculate_base_price()
            
        factor = self.get_adjustment_factor()
        final_price_heuristic = base_price_heuristic * Decimal(factor)
        
        # --- 算法 B: 随机森林估价 ---
        # [修改] 接收特征重要性字典
        final_price_rf, feature_importance = self._estimate_by_rf(self.similar_houses)
        
        # --- 决策融合 ---
        # 如果 RF 预测成功，我们采用加权融合（RF 占 70%，启发式占 30%）
        if final_price_rf:
            final_price = (final_price_rf * Decimal(0.7)) + (final_price_heuristic * Decimal(0.3))
            algorithm_used = "随机森林+启发式融合"
        else:
            final_price = final_price_heuristic
            algorithm_used = "启发式加权平均"
        
        # 计算价格波动的合理区间
        price_low = final_price * Decimal(0.95)
        price_high = final_price * Decimal(1.05)
        
        # 提取展示数据
        similar_houses_list = [h for h, s in self.similar_houses[:5]]
        search_results = self.get_search_results()
        
        result = {
            "estimated_price": round(final_price, 2),
            "heuristic_price": round(final_price_heuristic, 2),
            "rf_price": round(final_price_rf, 2) if final_price_rf else None,
            "algorithm": algorithm_used,
            "unit_price": round(final_price / Decimal(self.params['area']), 2),
            "price_range_low": round(price_low, 2),
            "price_range_high": round(price_high, 2),
            "similar_houses": similar_houses_list,
            "search_results": search_results,
            "market_trend": "稳中有升" if factor > 1.1 else "平稳",
            "factor": factor,
            # [新增] 返回特征重要性，便于前端展示或后台分析
            "feature_importance": feature_importance
        }
        
        # 记录到估价历史表
        EstimationHistory.objects.create(
            region=self.params['region'],
            area=self.params['area'],
            layout=self.params['layout'],
            has_subway=self.params.get('has_subway', False),
            is_school_district=self.params.get('is_school_district', False),
            floor_type=self.params.get('floor_type', 'mid'),
            building_age=self.params.get('building_age', 0),
            decoration=self.params.get('decoration', 'simple'),
            orientation=self.params.get('orientation', 'south'),
            base_price=base_price_heuristic, # 记录基础参考价
            estimated_price=result['estimated_price'],
            price_range_low=result['price_range_low'],
            price_range_high=result['price_range_high']
        )
        
        return result
