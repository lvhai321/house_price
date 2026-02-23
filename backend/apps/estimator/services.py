import re
from decimal import Decimal
from django.db.models import Avg
from apps.spider.models import House
from .models import EstimationHistory

class PriceEstimator:
    """
    房价估算服务类。
    基于相似房源比较法（Market Comparison Approach）和特征调整法进行估价。
    """
    def __init__(self, query_params):
        """
        初始化估价器。
        
        参数:
            query_params (dict): 包含房屋特征的字典，应包括:
            - region (str): 区域
            - area (float): 面积
            - layout (str): 户型
            - has_subway (bool): 是否近地铁
            - is_school_district (bool): 是否学区房
            - floor_type (str): 楼层类型 ('low', 'mid', 'high')
            - building_age (int): 房龄
            - decoration (str): 装修 ('rough', 'simple', 'exquisite')
            - orientation (str): 朝向 ('east', 'west', 'south', 'north')
        """
        self.params = query_params
        self.similar_houses = []
    
    def parse_layout(self, layout_str):
        """
        解析户型字符串，如 '2室1厅' 解析为 (2, 1)。
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
        计算目标房源与数据库中某房源的相似度得分（0-100）。
        
        打分规则:
        1. 区域 (40%): 完全匹配得40分，包含匹配得30分。
        2. 面积 (30%): 差异在10%以内得30分，20%以内得20分，30%以内得10分。
        3. 户型 (20%): 完全匹配得20分，室数差1得10分，室数相同得15分。
        4. 其他 (10%): 基础分5分。
        """
        score = 0
        
        # 1. 区域匹配度 (权重 40%)
        if house.region == self.params['region']:
            score += 40
        else:
            if self.params['region'] in house.region or house.region in self.params['region']:
                score += 30
        
        # 2. 面积接近度 (权重 30%)
        diff_pct = abs(house.area - self.params['area']) / self.params['area']
        if diff_pct <= 0.10:
            score += 30
        elif diff_pct <= 0.20:
            score += 20
        elif diff_pct <= 0.30:
            score += 10
            
        # 3. 户型相似度 (权重 20%)
        q_shi, q_ting = self.parse_layout(self.params['layout'])
        h_shi, h_ting = self.parse_layout(house.layout)
        
        if q_shi == h_shi and q_ting == h_ting:
            score += 20
        elif abs(q_shi - h_shi) == 1:
            score += 10
        elif q_shi == h_shi:
            score += 15
            
        # 4. 其他因素 (权重 10%)
        score += 5
        
        return score

    def find_similar_houses(self):
        """
        在数据库中查找相似房源。
        筛选条件: 
        1. 优先查找: 同一区域，面积在目标面积的 60%-140% 之间。
        2. 降级查找 (方案A): 如果上述条件未找到足够房源，尝试放宽面积限制 (40%-160%)。
        3. 最终降级 (方案A): 仅按区域匹配，不限制面积。
        按相似度得分排序。
        """
        area = self.params['area']
        
        # 第一阶段：标准搜索 (面积 60%-140%)
        qs = House.objects.filter(
            region__icontains=self.params['region'],
            area__gte=area * 0.6,
            area__lte=area * 1.4
        )
        
        # 降级策略 (方案A): 如果数据不足5条，放宽条件
        if qs.count() < 5:
            # 第二阶段：放宽面积 (面积 40%-160%)
            qs = House.objects.filter(
                region__icontains=self.params['region'],
                area__gte=area * 0.4,
                area__lte=area * 1.6
            )
            
            if qs.count() < 5:
                # 第三阶段：仅按区域匹配 (取消面积限制)
                qs = House.objects.filter(region__icontains=self.params['region'])
        
        scored_houses = []
        for h in qs:
            score = self.calculate_similarity(h)
            # 在降级模式下，适当放宽分数要求
            min_score = 30 if qs.count() < 5 else 50
            if score >= min_score: 
                scored_houses.append((h, score))
        
        # 按分数降序排列
        self.similar_houses = sorted(scored_houses, key=lambda x: x[1], reverse=True)
        return self.similar_houses

    def get_search_results(self):
        """
        获取当前区域的搜索结果（非相似房源，仅用于展示搜索结果）。
        获取最新的5条房源。
        """
        return House.objects.filter(
            region__icontains=self.params['region']
        ).order_by('-id')[:5]

    def calculate_base_price(self):
        """
        计算基础估价。
        使用相似房源的加权平均单价 * 目标面积。
        权重为相似度得分。
        """
        if not self.similar_houses:
            return None
            
        total_score = sum(s for h, s in self.similar_houses)
        
        # 异常值过滤: 过滤单价 > 200000 或 < 2000 的极端数据
        valid_houses = [
            (h, s) for h, s in self.similar_houses 
            if 2000 <= h.unit_price <= 200000
        ]
        
        if not valid_houses:
             # 如果过滤后为空，回退到原始数据
             valid_houses = self.similar_houses
             
        total_score = sum(s for h, s in valid_houses)
        
        # 加权平均单价 = sum(单价 * 分数) / 总分数
        weighted_unit_price = sum(h.unit_price * Decimal(s) for h, s in valid_houses) / Decimal(total_score)
        base_total = weighted_unit_price * Decimal(self.params['area'])
        return base_total

    def get_city_benchmark_price(self, region):
        """
        根据区域获取城市基准单价 (2025/2026年参考均价)。
        用于兜底估价。
        """
        # 支持中文区域名：若包含中文，先转为拼音再做基准价匹配
        region_lower = region.lower()
        try:
            if any('\u4e00' <= ch <= '\u9fff' for ch in region):
                from pypinyin import lazy_pinyin
                region_lower = ''.join(lazy_pinyin(region)).lower()
        except Exception:
            # 转换失败则退回原始小写字符串
            region_lower = region.lower()
        
        # 城市基准价字典 (单位: 元/平米)
        benchmarks = {
            # 一线城市
            'bj': 55000, 'beijing': 55000,
            'sh': 58000, 'shanghai': 58000,
            'sz': 56000, 'shenzhen': 56000,
            'gz': 32000, 'guangzhou': 32000,
            
            # 新一线/二线城市
            'hz': 28000, 'hangzhou': 28000,
            'nj': 22000, 'nanjing': 22000,
            'su': 20000, 'suzhou': 20000,
            'wh': 16000, 'wuhan': 16000,  # 武汉
            'cd': 15000, 'chengdu': 15000,
            'cq': 12000, 'chongqing': 12000,
            'tj': 14000, 'tianjin': 14000,
            'xa': 13000, 'xian': 13000,
            
            # 常见区域名匹配
            'chaoyang': 58000, # 北京朝阳
            'haidian': 85000,  # 北京海淀
            'dongcheng': 90000, # 北京东城
            'xicheng': 95000,  # 北京西城
            'pudong': 52000,   # 上海浦东
            'huangpu': 80000,  # 上海黄浦
        }
        
        # 尝试精确匹配
        if region_lower in benchmarks:
            return Decimal(benchmarks[region_lower])
            
        # 尝试模糊匹配 (如 'wuhan-洪山区' -> 匹配 'wuhan')
        for key, price in benchmarks.items():
            if key in region_lower:
                return Decimal(price)
                
        # 默认兜底价 (三线城市水平)
        return Decimal(10000)

    def get_adjustment_factor(self):
        """
        计算特征调整系数。
        根据地铁、学区、楼层、房龄、装修、朝向等因素对价格进行微调。
        """
        factor = 1.0
        
        # 地铁因素：+6.5%
        if self.params.get('has_subway'):
            factor *= 1.065
            
        # 学区因素：+11.5%
        if self.params.get('is_school_district'):
            factor *= 1.115
            
        # 楼层因素
        ft = self.params.get('floor_type')
        if ft == 'high':
            factor *= 1.04 # 高楼层溢价
        elif ft == 'low':
            factor *= 0.96 # 低楼层折价
            
        # 房龄折旧
        age = self.params.get('building_age', 0)
        if age > 0:
            # 每年折旧 0.75%，最高折旧 30%
            depreciation = min(age * 0.0075, 0.30)
            factor *= (1 - depreciation)
            
        # 装修状况
        dec = self.params.get('decoration')
        if dec == 'exquisite':
            factor *= 1.075 # 精装溢价
        elif dec == 'rough':
            factor *= 0.935 # 毛坯折价
            
        # 朝向因素
        ori = self.params.get('orientation')
        if ori == 'south':
            factor *= 1.04 # 南向溢价
        elif ori == 'north':
            factor *= 0.975 # 北向折价
            
        return factor

    def estimate(self):
        """
        执行完整的估价流程。
        1. 查找相似房源
        2. 计算基础价格
        3. 应用特征调整系数
        4. 生成价格范围
        5. 保存查询历史
        """
        self.find_similar_houses()
        
        base_price = Decimal(0)
        
        if not self.similar_houses:
            # 降级策略：如果没有找到相似房源，使用该区域的平均单价
            avg_data = House.objects.filter(region__icontains=self.params['region']).aggregate(Avg('unit_price'))
            avg_price = avg_data.get('unit_price__avg')
            if avg_price:
                base_price = Decimal(avg_price) * Decimal(self.params['area'])
            else:
                # 兜底默认值 (根据城市基准价)
                benchmark = self.get_city_benchmark_price(self.params['region'])
                base_price = benchmark * Decimal(self.params['area'])
        else:
            base_price = self.calculate_base_price()
            
        # 应用调整系数
        factor = self.get_adjustment_factor()
        final_price = base_price * Decimal(factor)
        
        # 计算价格区间 (+/- 5%)
        price_low = final_price * Decimal(0.95)
        price_high = final_price * Decimal(1.05)
        
        # 提取前5个最相似的房源用于展示
        similar_houses_list = [h for h, s in self.similar_houses[:5]]
        
        # 获取搜索结果 (当前区域的最新房源)
        search_results = self.get_search_results()
        
        result = {
            "estimated_price": round(final_price, 2),
            "base_price": round(base_price, 2),
            "unit_price": round(final_price / Decimal(self.params['area']), 2),
            "price_range_low": round(price_low, 2),
            "price_range_high": round(price_high, 2),
            "similar_houses": similar_houses_list,
            "search_results": search_results,  # 添加搜索结果
            "market_trend": "稳中有升" if factor > 1.1 else "平稳",
            "factor": factor
        }
        
        # 保存此次估价记录到数据库
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
