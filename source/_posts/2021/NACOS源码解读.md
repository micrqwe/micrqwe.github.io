title: NACOS源码解读(2.0.0版本)
date: 2021-04-14 11:36:08
tags: "源码解读"
---------
## 概述

* nacos作用不在赘述直接进入正题。
  * 官网：https://nacos.io/zh-cn/
  * github： https://github.com/alibaba/nacos

## 工程简介。

* 站在前人肩膀，少走弯路，快速切入入口；文章属于较早的，本文解读从2.0.0开始。
```$xslt
参考文章：1. https://blog.csdn.net/ZhangQingmu/article/details/105212470
        2. https://blog.csdn.net/CX610602108/article/details/110099591
        3. https://www.cnblogs.com/HendSame-JMZ/p/13046614.html
划重点：上述3篇文章仅供参考，实际需要根据自己的版本所建立
```
1. nacos-console: nacos主体项目入口和启动项目
2. nacos-naming: nacos注册发现业务。
3. nacos-config: nacos的配置中心服务


## 启动demo

1. 执行脚本 （MySQL）
```$xslt
create database nacos_config;
\distribution\conf\nacos-db.sql
```
2. IDEA 找到 nacos-console项目并运行 Nacos.java
```$xslt
jvm参数配置如下：
-Dnacos.standalone=true
-DuseAddressServer=false
-Ddb.num=1
-Ddb.url=jdbc:mysql://localhost:3306/nacos_config
-Ddb.user=nacos
-Ddb.password=nacos
```
3.  运行控制台页面
```$xslt
http://localhost:8848/nacos/index.html#/login
用户名密码 nacos/nacos
```
   