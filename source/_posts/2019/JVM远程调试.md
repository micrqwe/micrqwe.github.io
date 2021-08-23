title: jvm性能调试工具调试远程程序
date: 2020-06-23 11:10:08
tags: ["java开发"]
---------
# 远程调试程序性能

* 不论使用什么工具调试，都需要jvm开启远程调试功能
* 本案列使用tomcat运行war包程序进行调试

## tomcat开启jvm远程调试
1. 请参考另外一篇文章[tomcat设置启动参数](https://code.aliyun.com/287507016/mywork/wikis/tomcat-setenv)，讲解了如何配置tomcat启动参数
1. 在脚本中添加
```
JAVA_OPTS='-Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.authenticate=false'   
或者
    JAVA_OPTS=’-Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=192.168.1.54  其他配置’  
```
备注:
```$xslt
 在Java启动时，JMX会绑定一个接口，RMI也会绑定一个接口，在复杂网络环境下，有可能你通过打开防火墙允许了JMX端口的通过，但是由于没有放行RMI，远程连接也是会失败的。
这是因为JMX在远程连接时，会随机开启一个RMI端口作为连接的数据端口，这个端口会被防火墙给阻止，以至于连接超时失败。在Java7u25版本后，
可以使用 -Dcom.sun.management.jmxremote.rmi.port参数来指定这个端口；好消息是，你可以将这个端口和jmx.port的端口设置成一个端口，这样防火墙就只需要放行一个端口就可以了。
```

1. 参数说明
```
1. -Dcom.sun.management.jmxremote.port ：这个是配置远程 connection 的端口号的，要确定这个端口没有被占用
2. -Dcom.sun.management.jmxremote.ssl=false 指定了 JMX 是否启用 ssl
3. -Dcom.sun.management.jmxremote.authenticate=false   指定了JMX 是否启用鉴权（需要用户名，密码鉴权）
   2,3两个是固定配置，是 JMX 的远程服务权限的
4. -Djava.rmi.server.hostname ：这个是配置 server 的 IP 的 
```
