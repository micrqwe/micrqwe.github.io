id: 202307201110
title: SpringBoot内嵌Tomcat优化
date: 2023-07-20 13:12:08
tags: "java开发"
categories: 性能
---------
## 背景
 
  * springboot内嵌tomcat学习

## 系统参数

### 应用服务优化项
1. springboot tomcat配置数字，当链接超出后依然会阻塞，不会立即返回链接失败
2. tomcat配置线程不是轮询分配，相对轮询分配。
3. dubbo链接超出配置线程数后会立即返回失败