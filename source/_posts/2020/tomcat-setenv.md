# tomcat设置启动参数

## 个人倾向不修改原文件进行添加覆盖

1. 可以直接修改catalina.sh本身的启动文件进行添加参数
1. 额外添加文件(后续自己修改添加也比较方便。只知道自己是否添加过文件)

## 在tomcat/bin目录下新建setenv.sh脚本文件

1. 根据自己的需要进行调整参数。后面注释自己复制的时候去掉，这里只是提供说明

```
#!/bin/bash
 // 引入系统变量，大部分linux没有设置全局变量，所以这里需要自己导入变量，比如java环境
. /etc/profile.d/air.sh
 // 打印日志的格式
export today=`date +%Y%m%d%H%M%S`

export CATALINA_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
 // 管理进程
export CATALINA_PID=${CATALINA_HOME}/tomcat.pid
 // 以下参数可以查找jvm
export CATALINA_OPTS='
    -server
    -XX:+UnlockCommercialFeatures
    -XX:+FlightRecorder
    -Xms2048m
    -Xmx2048m
    -Xss256k 
    -XX:ErrorFile=${CATALINA_HOME}/logs/start.at.${today}.hs_err_pid.log 
    -XX:+UseConcMarkSweepGC 
    -XX:+HeapDumpOnOutOfMemoryError 
    -XX:HeapDumpPath=${CATALINA_HOME}/logs/start.at.${today}.dump.hprof 
    -XX:+PrintGCDateStamps 
    -XX:+PrintGCDetails 
    -Xloggc:${CATALINA_HOME}/logs/start.at.${today}.gc.log 
    -Duser.timezone=GMT+08 
    -Dfile.encoding=UTF-8 '
```

## 附录：设置java的垃圾回收器
* 这里有五种可以在应用里使用的垃圾回收类型。仅需要使用JVM开关就可以在我们的应用里启用垃圾回收策略。让我们一起来逐一了解：

1.  Serial GC（-XX:+UseSerialGC）：Serial GC使用简单的标记、清除、压缩方法对年轻代和年老代进行垃圾回收，即Minor GC和Major GC。Serial GC在client模式（客户端模式）很有用，比如在简单的独立应用和CPU配置较低的机器。这个模式对占有内存较少的应用很管用。
1.  Parallel GC（-XX:+UseParallelGC）：除了会产生N个线程来进行年轻代的垃圾收集外，Parallel GC和Serial GC几乎一样。这里的N是系统CPU的核数。我们可以使用 -XX:ParallelGCThreads=n 这个JVM选项来控制线程数量。并行垃圾收集器也叫throughput收集器。因为它使用了多CPU加快垃圾回收性能。Parallel GC在进行年老代垃圾收集时使用单线程。
1.  Parallel Old GC（-XX:+UseParallelOldGC）：和Parallel GC一样。不同之处，Parallel Old GC在年轻代垃圾收集和年老代垃圾回收时都使用多线程收集。
1.  并发标记清除（CMS）收集器（-XX:+UseConcMarkSweepGC)：CMS收集器也被称为短暂停顿并发收集器。它是对年老代进行垃圾收集的。CMS收集器通过多线程并发进行垃圾回收，尽量减少垃圾收集造成的停顿。CMS收集器对年轻代进行垃圾回收使用的算法和Parallel收集器一样。这个垃圾收集器适用于不能忍受长时间停顿要求快速响应的应用。可使用 -XX:ParallelCMSThreads=n JVM选项来限制CMS收集器的线程数量。
1.  G1垃圾收集器（-XX:+UseG1GC) G1（Garbage First）：垃圾收集器是在Java 7后才可以使用的特性，它的长远目标时代替CMS收集器。G1收集器是一个并行的、并发的和增量式压缩短暂停顿的垃圾收集器。G1收集器和其他的收集器运行方式不一样，不区分年轻代和年老代空间。它把堆空间划分为多个大小相等的区域。当进行垃圾收集时，它会优先收集存活对象较少的区域，因此叫“Garbage First”。