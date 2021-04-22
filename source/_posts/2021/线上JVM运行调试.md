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
        GC自适应调节策略：Parallel Scavenge收集器可设置-XX:+UseAdptiveSizePolicy参数。当开关打开时不需要手动指定新生代的大小（-Xmn）、Eden与Survivor区的比例（-XX:SurvivorRation）、晋升老年代的对象年龄（-XX:PretenureSizeThreshold）等，虚拟机会根据系统的运行状况收集性能监控信息，动态设置这些参数以提供最优的停顿时间和最高的吞吐量，这种调节方式称为GC的自适应调节策略。
        Parallel Scavenge收集器使用两个参数控制吞吐量：
            XX:MaxGCPauseMillis 控制最大的垃圾收集停顿时间
            XX:GCRatio 直接设置吞吐量的大小。
```
 