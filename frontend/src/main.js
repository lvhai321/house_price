/**
 * 前端入口文件
 * 初始化 Vue 应用，挂载 Router、Pinia 和 Element Plus UI 库
 */
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import faviconUrl from '../fang.png'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(ElementPlus)

document.title = '房价预测系统'
const head = document.head || document.getElementsByTagName('head')[0]
let link = head.querySelector("link[rel*='icon']")
if (!link) {
  link = document.createElement('link')
  link.rel = 'icon'
  link.type = 'image/png'
  head.appendChild(link)
}
link.href = faviconUrl

app.mount('#app')
