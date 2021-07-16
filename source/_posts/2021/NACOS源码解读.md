title: NACOS源码解读(2.0.0版本)
date: 2021-04-14 11:36:08
tags: "源码解读"
---------
# nacos使用方面概述
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
1. nacos-naming: nacos注册发现业务。
1. nacos-config: nacos的配置中心服务
1. nacos-api: 用户nacos客户端和服务端进行通信的定义
1. nacos-client: nacos客户端，进行和服务端通信
1. nacos-test: 测试用例

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

## 编译源码jar包启动
1. 选择nacos-distribution项目执行:mvn  clean install -Dmaven.test.skip=true -P release-nacos
1. 选择对应的压缩包.进行传输
1. 解压压缩包到bin目录:sh startup.sh -m standalone
   * 如果使用ubuntu或者运行脚本报错提示[[符号找不到，可尝试如下运行:bash startup.sh -m standalone
1. 修改链接数据等前往conf目录.

3.  运行控制台页面
```$xslt
http://localhost:8848/nacos/index.html#/login
用户名密码 nacos/nacos
```

## 项目分析解读

1. nacos-test
```$xslt
1. 包下面的结构还是挺清晰的，每个不同的模块都会聚集在一个包下面。以下举例config。
2. 第一个类：ConfigAPI_CITCase->nacos_getconfig_1
3. 测试方法用于一个配置注册和删除，在进行获取。
4. 启动该测试类的会启动:Nacos.class（参照上面demo启动）。
5. 随后用nacos-client包下的类进行远程调用进行各项方法。
总结：test方法会一同启动nacos服务，同时用client进行调用。这里会进行一个全链路的测试。
这个一个很好的方法，学习了。
```

#nacos理念

## 数据一致性

1. nacos由AP CP组成混合使用；
  * 临时节点使用AP模式，进行服务端存储，存在在一个Map中
      ```aidl
       AP协议：Distro协议。Distro是阿里巴巴的私有协议，目前流行的 Nacos服务管理框架就采用了 Distro协议。Distro 协议被定位为 临时数据的一致性协议 ：该类型协议， 不需要把数据存储到磁盘或者数据库 ，因为临时数据通常和服务器保持一个session会话， 该会话只要存在，数据就不会丢失 。
      ```
  * 持久化节点使用CP模式（集群Leader），该数据会序列化进磁盘中。备注：nacos1.4之前使用raft自己实现，之后版本使用了:蚂蚁金服的jraft。
      ```aidl
        Raft 适用于一个管理日志一致性的协议，相比于 Paxos 协议 Raft 更易于理解和去实现它。为了提高理解性，Raft 将一致性算法分为了几个部分，包括领导选取（leader selection）、日志复制（log replication）、安全（safety），并且使用了更强的一致性来减少了必须需要考虑的状态。
      ```
  1. 参考文章:[Nacos注册中心设计分析-CP模式(重点)](https://blog.csdn.net/swordyijianpku/article/details/105393459)
  1. 参考文章：[蚂蚁金服开源 SOFAJRaft：生产级 Java Raft 算法库](https://blog.csdn.net/yunqiinsight/article/details/88569294)
  1. 参考文章:[Nacos中Distro协议梳理](https://blog.csdn.net/u012050299/article/details/110946637)
  1. 参考文章:[Nacos 实现 AP+CP原理Raft 算法](https://blog.csdn.net/m0_37235955/article/details/115036527)
  1. 参考文章:[Raft协议动态图](/2021/04/09/2021/Raft协议/)
## 2.0版本

1. 新增gprc。
2. 支持长链接
...