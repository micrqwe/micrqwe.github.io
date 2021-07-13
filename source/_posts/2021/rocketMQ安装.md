id: 202006231110
title: rocketmq安装
date: 2021-07-13 18:30:08
tags: "笔记"
---------

# 官网地址

## 本文使用的是4.9.0

  * [官网](https://rocketmq.apache.org/docs/quick-start/)
   ```text
      大写的备注:第一次下载的是:rocketmq-all-4.9.0-source-release.zip,想自己编译,编译后运行broker一直抛出链接不上nameserver,一开始怀疑配置,后面重新下载低版本的通过.
      重新下载回该版本,下载了一个编译的好的包.一运行直接通过了.要么自行编译时候需要改参数(官网没看到).要么编译的代码就有问题.耗时4小时
   ```

## 启动rocketmq

* 这里是单机测试,修改jvm使用的内存.默认的会占用4+8=12G内存.
1. cd rocketmq-all-4.9.0-bin-release/
1. vim bin/runserver.sh  和  vim bin/runbroker.sh
   ```text
   找到一行带有设置内存的,修改为下面的一句话
   runserver : JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
   runbroker : JAVA_OPT="${JAVA_OPT} -server -Xms1g -Xmx1g -Xmn512m"
   ```
1. 开启 Name Server
   ```text
     > nohup sh bin/mqnamesrv &
     > tail -f ~/logs/rocketmqlogs/namesrv.log
       The Name Server boot success...
   ```
1. 开启Broker
   ```text
     备注:测试中我是在docker中,需要指定一下外网ip
    > vim conf/broker.conf (加入以下.根据个人需求来定) 
         # brokerIP1和brokerIP2默认获取本地ip地址,在云服务器上会获取内网ip地址,因此必须显式设置
           brokerIP1=192.168.0.x
           brokerIP2=192.168.0.x
     > nohup sh bin/mqbroker -n 192.168.0.x:9876 -c conf/broker.conf &
     > tail -f ~/logs/rocketmqlogs/broker.log 
     The broker[%s, 172.30.30.233:10911] boot success...
   ```

## 启动rocketmq console

1. github:https://github.com/apache/rocketmq-externals
2. 进入到文件夹:rocketmq-console
   ```text
   mvn clean package -Dmaven.test.skip=true
   nohup java -jar target/rocketmq-console-ng-2.0.0.jar  > /dev/null 2>&1 &
   tail -100f  ~/logs/consolelogs/rocketmq-console.log 
   ```
3. 启动后在管理台上有填入集群地址.进行查看