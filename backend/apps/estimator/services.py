import re
from decimal import Decimal
from django.db.models import Avg
from apps.spider.models import House
from .models import EstimationHistory

class PriceEstimator:
    """
    房价估算核心服务类。
    ------------------
    该类实现了“市场比较法”（Market Comparison Approach）的简化版逻辑。
    通过在数据库中寻找相似房源，计算加权平均单价，并根据目标房源的各项特征（楼层、朝向、装修等）进行系数修正，
    从而得出一个科学、合理的预估价格。
    """
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
        解析户型字符串。
        例如：将 '2室1厅' 转化为数字元组 (2, 1)，便于后续进行数学比较。
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
        计算目标房源与库中某条房源的“相似度得分”（满分 100 分）。
        
        评分维度及权重：
        1. 区域匹配 (40%): 区域完全一致得 40 分，包含关系（如：武汉 vs 武汉-白沙洲）得 30 分。
        2. 面积接近 (30%): 面积差异越小得分越高。10%以内得满分，超过30%则该项得 10 分。
        3. 户型相似 (20%): 室数和厅数完全一致得满分，室数差 1 间则减分。
        4. 其他基础分 (10%): 默认赋予 5 分作为基础权重。
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
        在数据库中检索相似的参考房源。
        
        采用三层“降级检索”策略，确保即便数据稀少也能找到参考：
        - 第一层：精准匹配。同一区域且面积差异在 ±40% 以内的房源。
        - 第二层：放宽面积。若第一层不满 5 条，将面积差异放宽至 ±60%。
        - 第三层：仅匹配区域。若依然不足，则不再限制面积，只匹配该区域的所有房源。
        
        检索完成后，会根据 calculate_similarity 进行打分并由高到低排序。
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
        获取该区域最新的房源记录。
        仅用于前端展示“该区域最新房源”，不直接参与估价计算。
        """
        return House.objects.filter(
            region__icontains=self.params['region']
        ).order_by('-id')[:5]

    def calculate_base_price(self):
        """
        计算基础预估价格。
        ----------------
        算法逻辑：
        1. 排除单价过高（>20万）或过低（<2000元）的异常噪音数据。
        2. 对筛选出的相似房源执行“加权平均”：
           相似度得分越高的房源，对最终价格的影响力越大。
        3. 加权平均单价 * 目标房源面积 = 基础总价。
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
        【兜底机制】获取城市基准单价。
        ---------------------------
        如果数据库中没有任何相似房源可供参考，则根据预设的各城市/热门区域基准价进行估算。
        这些数据反映了 2025/2026 年度的宏观市场水位。
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
        计算特征调整系数（加减分项）。
        --------------------------
        基于房源的具体特征对基础价格进行微调：
        - 地铁房：溢价 +6.5%
        - 优质学区：溢价 +11.5%
        - 楼层：高楼层通常更贵(+4%)，低楼层相对便宜(-4%)。
        - 房龄：每年按 0.75% 的比例进行折旧，最高折损 30%。
        - 装修：精装(+7.5%) vs 毛坯(-6.5%)。
        - 朝向：南向阳光充足(+4%)，北向相对折价(-2.5%)。
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

    def estimate(self):
        """
        执行完整的估价工作流。
        -------------------
        1. 检索相似房源并排序。
        2. 如果有参考数据，执行加权平均计算基础价；若无数据，启动基准价兜底。
        3. 根据目标房源的装修、楼层、地铁等特征，计算综合调整系数。
        4. 得出最终预估总价，并推算出一个 ±5% 的合理价格区间。
        5. 将此次估价请求和结果存入数据库历史记录，供日后分析。
        """
        self.find_similar_houses()
        
        base_price = Decimal(0)
        
        if not self.similar_houses:
            # 数据库无数据时的降级处理
            avg_data = House.objects.filter(region__icontains=self.params['region']).aggregate(Avg('unit_price'))
            avg_price = avg_data.get('unit_price__avg')
            if avg_price:
                base_price = Decimal(avg_price) * Decimal(self.params['area'])
            else:
                benchmark = self.get_city_benchmark_price(self.params['region'])
                base_price = benchmark * Decimal(self.params['area'])
        else:
            base_price = self.calculate_base_price()
            
        # 应用调整系数
        factor = self.get_adjustment_factor()
        final_price = base_price * Decimal(factor)
        
        # 计算价格波动的合理区间
        price_low = final_price * Decimal(0.95)
        price_high = final_price * Decimal(1.05)
        
        # 提取展示数据
        similar_houses_list = [h for h, s in self.similar_houses[:5]]
        search_results = self.get_search_results()
        
        result = {
            "estimated_price": round(final_price, 2),
            "base_price": round(base_price, 2),
            "unit_price": round(final_price / Decimal(self.params['area']), 2),
            "price_range_low": round(price_low, 2),
            "price_range_high": round(price_high, 2),
            "similar_houses": similar_houses_list,
            "search_results": search_results,
            "market_trend": "稳中有升" if factor > 1.1 else "平稳",
            "factor": factor
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
            base_price=result['base_price'],
            estimated_price=result['estimated_price'],
            price_range_low=result['price_range_low'],
            price_range_high=result['price_range_high']
        )
        
        return result
