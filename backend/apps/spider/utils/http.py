"""
网络请求工具模块
----------------
封装了基于 requests 库的 HTTP 请求逻辑。
提供随机 User-Agent 切换、速率限制（防止封 IP）、代理池对接以及自动重试机制。
"""
import requests
import time
import random
import os
import logging
from urllib.parse import urlparse

logger = logging.getLogger("spider.http")

# 常见的浏览器 User-Agent 池，用于模拟真实用户访问
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0",
]

def get_random_ua():
    """随机获取一个 User-Agent"""
    return random.choice(USER_AGENTS)

def get_session():
    """
    【会话工厂】
    创建一个配置好基础请求头的 requests.Session 对象。
    使用 Session 可以保持 Cookie，并复用 TCP 连接，显著提升抓取效率。
    """
    session = requests.Session()
    session.headers.update({
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "User-Agent": get_random_ua(),
    })
    return session

class RateLimiter:
    """
    【速率限制器】
    在两次请求之间引入随机的停顿时间，降低被目标网站反爬虫系统识别的概率。
    """
    def __init__(self, jitter_range=(1.0, 3.0)):
        self.min_delay, self.max_delay = jitter_range

    def wait(self):
        """执行等待（阻塞当前线程）"""
        delay = random.uniform(self.min_delay, self.max_delay)
        time.sleep(delay)

def get_proxy():
    """
    【代理获取】
    对接外部代理池 API。若环境变量中配置了 PROXY_POOL_URL，则从中提取一个有效代理 IP。
    """
    proxy_url = os.getenv("PROXY_POOL_URL")
    if proxy_url:
        try:
            resp = requests.get(proxy_url, timeout=2)
            if resp.status_code == 200:
                proxy = resp.json().get("proxy") if "proxy" in resp.json() else resp.text
                return {"http": f"http://{proxy}", "https": f"http://{proxy}"}
        except Exception as e:
            logger.warning(f"无法从代理池获取 IP: {e}")
    return None

def fetch(url, session=None, rate_limiter=None, retries=3, use_proxy=False):
    """
    【核心：网页抓取器】
    发送安全、健壮的 GET 请求。
    
    特性：
    1. 自动重试：遇到网络抖动或临时封禁时，支持指数退避重试。
    2. 动态 UA：每次重试都会更换新的浏览器标识。
    3. 代理支持：若开启 use_proxy，则尝试通过代理访问。
    4. 反爬检测：自动识别并拦截登录重定向或验证码页面。
    """
    if session is None:
        session = get_session()
        
    if rate_limiter:
        rate_limiter.wait()
        
    for attempt in range(retries):
        try:
            # 1. 动态更换 User-Agent
            session.headers["User-Agent"] = get_random_ua()
            
            # 2. 代理准备
            proxies = {"http": None, "https": None}
            if use_proxy:
                p = get_proxy()
                if p: proxies = p

            # 3. 发起请求
            response = session.get(url, timeout=10, proxies=proxies)
            
            # 4. 状态校验与反爬拦截
            if response.status_code == 200:
                # 检测是否被重定向到了验证码或登录页
                lowered_url = response.url.lower()
                if any(k in lowered_url for k in ["captcha", "login", "verify"]):
                    if "lianjia" in url: # 链家反爬严，直接抛异常重试
                         raise Exception("命中链家反爬，已重定向至登录/验证码页")
                return response.text
                
            elif response.status_code in [403, 429]:
                raise Exception(f"目标站点拒绝访问 (Status {response.status_code})，可能 IP 被封")
            else:
                response.raise_for_status()
                
        except Exception as e:
            logger.warning(f"抓取失败: {url} | 错误: {e} | 正在进行第 {attempt + 1} 次重试...")
            # 随着重试次数增加，等待时间变长（指数退避）
            time.sleep(2 * (attempt + 1))
            
    raise Exception(f"在 {retries} 次尝试后，依然无法获取页面: {url}")
