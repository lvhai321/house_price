<!--
  根组件 (App.vue)
  
  功能描述：
  应用程序的根容器，负责渲染路由视图。
  同时定义了全局的基础样式。
-->
<template>
  <router-view></router-view>
</template>

<style>
body {
  margin: 0;
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
  background-color: #f0f2f5;
}
</style>
