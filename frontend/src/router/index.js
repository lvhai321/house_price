/**
 * 路由配置模块
 * 定义应用的前端路由规则，实现单页应用 (SPA) 的页面跳转。
 */
import { createRouter, createWebHistory } from 'vue-router'
// 导入视图组件
import Home from '../views/Home.vue'

// 路由定义数组
const routes = [
    {
        path: '/',      // 根路径
        name: 'Home',   // 路由名称
        component: Home // 对应的组件
    }
]

// 创建路由实例
const router = createRouter({
    // 使用 HTML5 History 模式 (不带 # 号)
    history: createWebHistory(),
    routes
})

export default router
