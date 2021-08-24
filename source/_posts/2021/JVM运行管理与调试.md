id: 202006231110
title: 线上JVM运行调试
date: 2021-04-19 09:12:08
tags: "java开发"
---------

# jvm调试

## gc部分

* jvm的垃圾收集器状态
  1. jmap -heap [pid]
    * 参考文章:[内存分配和垃圾收集器](/2020/06/23/2019/jvmXmSurvivor/)
    ```aidl
      前面几行中标记有使用的垃圾收集器，以及目前各个分代中的使用和剩余
    ```

* jvm dump堆文件
 1. jmap -dump:format=b,file=[路径].hprof [pid]

* 手动gc
 1. jmap -histo:live [pid]  
 
* 查看gc的次数和频率
 1. 使用jstat。参考文章:[java性能调试工具](https://docs.qq.com/sheet/DWWZ5WnNiSG5Yb1pl?tab=BB08J2)
 2. 在实际使用中发现如下的问题。后面在一篇文章有部分说明:[参考文章](https://blog.csdn.net/luzhensmart/article/details/82563734)
 ```aidl
    1. 新生代为680M。SurvivorRatio为8。也就是新生区544M，2个幸存区各68M。但结合线上的jmap和jstat中，这个使用内存量会变，幸存区实际再用低于68M，新生区会大于544。
    原因：使用的是ps新生代垃圾收集器才会是这个问题。parnew则是按照配置来预先分配
    parallel scavenge新生代中具体分配策略参见： 
    备注： Parallel Scavenge 收集器
        特点：属于新生代收集器也是采用复制算法的收集器，又是并行的多线程收集器（与ParNew收集器类似）。
        该收集器的目标是达到一个可控制的吞吐量。还有一个值得关注的点是：GC自适应调节策略(这就是为啥幸存区不是按照比例的来配置大小的原因)（与ParNew收集器最重要的一个区别）
        GC自适应调节策略：Parallel Scavenge收集器可设置-XX:+UseAdaptiveSizePolicy参数。当开关打开时不需要手动指定新生代的大小（-Xmn）、Eden与Survivor区的比例（-XX:SurvivorRation）、晋升老年代的对象年龄（-XX:PretenureSizeThreshold）等，虚拟机会根据系统的运行状况收集性能监控信息，动态设置这些参数以提供最优的停顿时间和最高的吞吐量，这种调节方式称为GC的自适应调节策略。
        Parallel Scavenge收集器使用两个参数控制吞吐量：
            XX:MaxGCPauseMillis 控制最大的垃圾收集停顿时间
            XX:GCRatio 直接设置吞吐量的大小。
```

## jvm更换垃圾收集器

1. Serial（串行）收集器
    1. -XX:+UseSerialGC
1. Parallel（并行）收集器
    1. -XX:+UseParallelGC -XX:+UseParallelOldGC
1. CMS（并发）收集器
    1. -XX:+UseParNewGC -XX:+UseConcMarkSweepGC
1. 开启G1收集器的方式
    1. -XX:+UseG1GC
1. 组合说明
   ```text
       -XX:+UseParNewGC = ParNew + SerialOld这个组合已经很少用（在某些版本中已经废弃）
       -XX:+UseConc(urrent)MarkSweepGC = ParNew + CMS + Serial Old
       -XX:+UseParallelGC = Parallel Scavenge + Parallel Old (1.8默认) 【PS + SerialOld】
       -XX:+UseParallelOldGC = Parallel Scavenge + Parallel Old
       -XX:+UseG1GC = G1
   ```
* [附带截图](/imgs/WX20210823-201316.png)

## jvm内存管理

1. [Java_JVM参数-XX:MaxDirectMemorySize 与 两种 ByteBuffer: heap,direct ByteBuffer](https://www.cnblogs.com/laoqing/p/10380536.html)（参考：https://www.cnblogs.com/laoqing/p/10380536.html）
1. ByteBuffer有两种:
    * heap ByteBuffer -> -XX:Xmx
        *  1.1、一种是heap ByteBuffer,该类对象分配在JVM的堆内存里面，直接由Java虚拟机负责垃圾回收； 
    * direct ByteBuffer -> -XX:MaxDirectMemorySize
        * 1.2、一种是direct ByteBuffer是通过jni在虚拟机外内存中分配的。通过jmap无法查看该快内存的使用情况。只能通过top来看它的内存使用情况。
            * 1.2.1、JVM堆内存大小可以通过-Xmx来设置，同样的direct ByteBuffer可以通过-XX:MaxDirectMemorySize来设置，此参数的含义是当Direct ByteBuffer分配的堆外内存到达指定大小后，即触发Full GC。注意该值是有上限的，默认是64M，最大为sun.misc.VM.maxDirectMemory()，在程序中中可以获得-XX:MaxDirectMemorySize的设置的值。
            * 1.2.2、没有配置MaxDirectMemorySize的，因此MaxDirectMemorySize的大小即等于-Xmx
            * 1.2.3、Direct Memory的回收机制，Direct Memory是受GC控制的
            * 1.2.4、对于使用Direct Memory较多的场景，需要注意下MaxDirectMemorySize的设置，避免-Xmx + Direct Memory超出物理内存大小的现象

## 常用参数说明
* jvm一些常用参数
```text
-server                                             ## 服务器模式
-Xms2g                                              ## 初始化堆内存大小
-Xmx2g                                              ## 堆内存最大值
-Xmn256m                                            ## 年轻代内存大小，整个JVM内存=年轻代 + 年老代 + 持久代
-Xss256k                                            ## 设置每个线程的堆栈大小
-XX:PermSize=256m                                   ## 持久代内存大小
-XX:MetaspaceSize=21m                               ## 最大持久代内存大小
-XX:MaxMetaspaceSize=21m                            ## 最大可分配元空间
-XX:MaxDirectMemorySize=21m                          ## 直接内存分配
-XX:ReservedCodeCacheSize=256m                      ## 代码缓存，存储已编译方法生成的本地代码
-XX:+UseCodeCacheFlushing                           ## 代码缓存满时，让JVM放弃一些编译代码
-XX:+DisableExplicitGC                              ## 忽略手动调用GC, System.gc()的调用就会变成一个空调用，完全不触发GC
-Xnoclassgc                                         ## 禁用类的垃圾回收，性能会高一点
-XX:+UseConcMarkSweepGC                             ## 并发标记清除（CMS）收集器
-XX:+CMSParallelRemarkEnabled                       ## 启用并行标记，降低标记停顿
-XX:+UseParNewGC                                    ## 对年轻代采用多线程并行回收，这样收得快
-XX:+UseCMSCompactAtFullCollection                  ## 在FULL GC的时候对年老代的压缩，Full GC后会进行内存碎片整理，过程无法并发，空间碎片问题没有了，但提顿时间不得不变长了
-XX:CMSFullGCsBeforeCompaction=3                    ## 多少次Full GC 后压缩old generation一次
-XX:LargePageSizeInBytes=128m                       ## 内存页的大小
-XX:+UseFastAccessorMethods                         ## 原始类型的快速优化
-XX:+UseCMSInitiatingOccupancyOnly                  ## 使用设定的回收阈值(下面指定的70%)开始CMS收集,如果不指定,JVM仅在第一次使用设定值,后续则自动调整
-XX:CMSInitiatingOccupancyFraction=70               ## 使用cms作为垃圾回收使用70％后开始CMS收集
-XX:SoftRefLRUPolicyMSPerMB=50                      ## Soft reference清除频率，默认存活1s,设置为0就是不用就清除
-XX:+AlwaysPreTouch                                 ## 强制操作系统把内存真正分配给JVM
-XX:+PrintClassHistogram                            ## 按下Ctrl+Break后，打印类的信息
-XX:+PrintGCDetails                                 ## 输出GC详细日志
-XX:+PrintGCTimeStamps                              ## 输出GC的时间戳（以基准时间的形式）
-XX:+PrintHeapAtGC                                  ## 在进行GC的前后打印出堆的信息
-XX:+PrintGCApplicationConcurrentTime               ## 输出GC之间运行了多少时间
-XX:+PrintTenuringDistribution                      ## 参数观察各个Age的对象总大小
-XX:+PrintGCApplicationStoppedTime                  ## GC造成应用暂停的时间
-Xloggc:../log/gc.log                               ## 指定GC日志文件的输出路径
-ea                                                 ## 打开断言机制，jvm默认关闭
-Dsun.io.useCanonCaches=false                       ## java_home没有配置，或配置错误会报异常
-Dsun.awt.keepWorkingSetOnMinimize=true             ## 可以让IDEA最小化到任务栏时依然保持以占有的内存，当你重新回到IDEA，能够被快速显示，而不是由灰白的界面逐渐显现整个界面，加快回复到原界面的速度
-Djava.net.preferIPv4Stack=true                     ## 让tomcat默认使用IPv4
-Djdk.http.auth.tunneling.disabledSchemes=""        ## 等于Basic会禁止proxy使用用户名密码这种鉴权方式,反之空就可以使用
-Djsse.enablesSNIExtension=false                    ## SNI支持，默认开启，开启会造成ssl握手警告
-XX:+HeapDumpOnOutOfMemoryError                     ## 表示当JVM发生OOM时，自动生成DUMP文件
-XX:HeapDumpPath=D:/data/log                        ## 表示生成DUMP文件的路径，也可以指定文件名称，如果不指定文件名，默认为：java_<pid>_<date>_<time>_heapDump.hprof。  
-XX:-OmitStackTraceInFastThrow                      ## 省略异常栈信息从而快速抛出,这个配置抛出这个异常非常快，不用额外分配内存，也不用爬栈,但是出问题看不到stack trace，不利于排查问题
-Dfile.encoding=UTF-8
-Duser.name=qhong

-XX:NewRatio=3                                         ## 新生代与年老代的比例。比如为3，则新生代占堆的1/4，年老代占3/4。
-XX:SurvivorRatio=8                                    ## 新生代中调整eden区与survivor区的比例，默认为8，即eden区为80%的大小，两个survivor分别为10%的大小。 
-XX:PretenureSizeThreshold=10m                         ## 晋升年老代的对象大小。默认为0，比如设为10M，则超过10M的对象将不在eden区分配，而直接进入年老代。
-XX:MaxTenuringThreshold=15                            ## 晋升老年代的最大年龄。默认为15，比如设为10，则对象在10次普通GC后将会被放入年老代。
-XX:MaxTenuringThreshold=0                          ## 垃圾最大年龄，如果设置为0的话,则年轻代对象不经过Survivor区,直接进入年老代，该参数只有在串行GC时才有效
-XX:+HeapDumpBeforeFullGC                           ## 当JVM 执行 FullGC 前执行 dump
-XX:+HeapDumpAfterFullGC                            ## 当JVM 执行 FullGC 后执行 dump
-XX:+HeapDumpOnCtrlBreak                            ## 交互式获取dump。在控制台按下快捷键Ctrl + Break时，JVM就会转存一下堆快照
-XX:+PrintGC                                        ## 输出GC日志
-verbose:gc                                         ## 同PrintGC,输出GC日志
-XX:+PrintGCDateStamps                              ## 输出GC的时间戳（以日期的形式，如 2013-05-04T21:53:59.234+0800）
-XX:+PrintFlagsInitial                              ## 显示所有可设置参数及默认值 
-enablesystemassertions                             ## 激活系统类的断言
-esa                                                ## 同上
-disablesystemassertions                            ## 关闭系统类的断言
-dsa                                                ## 同上
-XX:+ScavengeBeforeFullGC                           ## FullGC前回收年轻代内存，默认开启
-XX:+CMSScavengeBeforeRemark                        ## CMS remark前回收年轻代内存    
-XX:+CMSIncrementalMode                             ## 采用增量式的标记方式，减少标记时应用停顿时间
-XX:+CMSClassUnloadingEnabled                       ## 相对于并行收集器，CMS收集器默认不会对永久代进行垃圾回收。如果希望回收，就使用该标志，注意，即使没有设置这个标志，一旦永久代耗尽空间也会尝试进行垃圾回收，但是收集不会是并行的，而再一次进行Full GC
-XX:+CMSConcurrentMTEnabled                         ## 当该标志被启用时，并发的CMS阶段将以多线程执行(因此，多个GC线程
```