import requests
import time
import random
import os
import logging
from urllib.parse import urlparse

logger = logging.getLogger("spider.http")

# 扩展的 User-Agent 池
USER_AGENTS = [
    # Chrome
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    # Firefox
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0",
    # Safari
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15",
    # Edge
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0",
]

def get_random_ua():
    return random.choice(USER_AGENTS)

def get_session():
    """
    创建一个带有默认配置的 requests.Session 对象。
    """
    session = requests.Session()
    session.headers.update({
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
        "Connection": "keep-alive",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent": get_random_ua(),  # 初始随机 UA
    })
    return session

class RateLimiter:
    """
    速率限制器，用于在请求之间添加随机延迟。
    """
    def __init__(self, jitter_range=(1.0, 3.0)):
        self.min_delay, self.max_delay = jitter_range

    def wait(self):
        delay = random.uniform(self.min_delay, self.max_delay)
        time.sleep(delay)

def get_proxy():
    """
    获取代理 IP。
    支持从环境变量 PROXY_POOL_URL 获取代理，或者直接配置代理列表。
    这里仅作为示例，实际需对接代理池 API。
    """
    proxy_url = os.getenv("PROXY_POOL_URL") # 例如: http://localhost:5010/get/
    if proxy_url:
        try:
            resp = requests.get(proxy_url, timeout=2)
            if resp.status_code == 200:
                # 假设返回格式为 {"proxy": "1.2.3.4:8080"} 或直接 "1.2.3.4:8080"
                # 这里做简单处理，视具体代理池实现而定
                proxy = resp.json().get("proxy") if "proxy" in resp.json() else resp.text
                return {"http": f"http://{proxy}", "https": f"http://{proxy}"}
        except Exception as e:
            logger.warning(f"Failed to get proxy from pool: {e}")
    
    return None

def fetch(url, session=None, rate_limiter=None, retries=3, use_proxy=False):
    """
    发送 GET 请求获取页面内容。
    
    参数:
        url (str): 目标 URL
        session (requests.Session): 会话对象
        rate_limiter (RateLimiter): 速率限制器
        retries (int): 重试次数
        use_proxy (bool): 是否使用代理
        
    返回:
        str: 响应的文本内容
    """
    if session is None:
        session = get_session()
        
    if rate_limiter:
        rate_limiter.wait()
        
    for attempt in range(retries):
        try:
            # 动态轮换 User-Agent
            session.headers["User-Agent"] = get_random_ua()
            
            proxies = None
            if use_proxy:
                proxies = get_proxy()
                if proxies:
                    logger.info(f"Using proxy: {proxies}")

            response = session.get(url, timeout=10, proxies=proxies)
            
            # 检查 HTTP 状态码
            if response.status_code == 200:
                # 简单的反爬检查（如链家重定向到登录页）
                if "captcha" in response.url or "login" in response.url or "verify" in response.url:
                    # 针对安居客，有时虽然 url 有 verify 但其实是验证页面，需要进一步检查内容
                    if "anjuke" in url and "verify" in response.url:
                         # 降低日志级别，不要抛出异常，让解析器去判断 title
                         # logger.warning(f"Anjuke verify page detected: {response.url}")
                         # raise Exception("Redirected to captcha/login page")
                         pass
                    
                    # 针对链家
                    elif "lianjia" in url and ("login" in response.url or "captcha" in response.url):
                         raise Exception("Redirected to captcha/login page")
                         
                return response.text
            elif response.status_code in [403, 429]:
                # 遇到 403/429 禁止访问，可能是 IP 被封，尝试重试（如果开启了代理，下一次重试会换代理）
                raise Exception(f"Anti-scraping block (Status {response.status_code})")
            else:
                response.raise_for_status()
                
        except Exception as e:
            logger.warning(f"[Fetch Error] {url}: {e} (Attempt {attempt + 1}/{retries})")
            time.sleep(2 * (attempt + 1))  # 指数退避
            
    raise Exception(f"Failed to fetch {url} after {retries} attempts")
