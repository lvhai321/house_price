/**
 * Vite 配置文件
 * 配置 Vue 插件、路径别名 (@) 以及开发服务器的反向代理 (Proxy)
 */
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:8000',
        changeOrigin: true,
        // rewrite: (path) => path.replace(/^\/api/, '') // Django uses /api prefix so no rewrite needed usually if we map /api to /api
      }
    }
  }
})
