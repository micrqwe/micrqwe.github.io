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
 2. 在现场使用中发现如下的问题。后面在一篇文章有部分说明:[参考文章](https://blog.csdn.net/luzhensmart/article/details/82563734)
 ```aidl
    1. 新生代假设为1000M。SurvivorRatio为8。也就是新生区800M，2个幸存区各100M。但结合线上的jmap和jstat中，这个使用内存量会变，幸存区实际再用低于100M，新生区会大于800。
    2. 也就是说参数配置的只是一个类似约定的最大值，实际会根据具体业务变动 
```
 