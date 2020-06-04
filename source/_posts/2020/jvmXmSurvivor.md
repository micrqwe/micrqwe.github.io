# jvm的运行参数

## jvm的配置参数

1. -Xms40m //初始内存
1. -Xmx256m //最大内存
1. -Xmn16m //最小内存
1. -XX:PermSize=128M  // 永久带的内存
1. -XX:MaxPermSize=256M  // 永久带的最大内存（一般默认64MB）
1. -XX:SurvivorRatio=8  // 新生代中Eden区域与Survivor区域的容量比值 
![jvm内存的分配图](https://csdn-code.oss.aliyuncs.com/php-upload-images/20170414-2244-24247-9647/r_heap1.PNG "jvm内存的分配图")

1. -XX:MaxTenuringThreshold=15 // 一般jvm默认值15 晋升到老年代的对象年龄，每个对象坚持一次MinorGC之后，年龄就增加1，当超过这个参数的值时就进入老年代

## jvm常用一些配置参数

1. GC参数

  ```
  -XX:+PrintGC    每次触发GC的时候打印相关日志

  -XX:+PrintGCDetails    更详细的GC日志

  -XX:+PrintHeapAtGC    每次GC时打印堆的详细详细信息

  -XX:+PrintGCApplicationConcurrentTime    打印应用程序执行时间

  -XX:+PrintGCApplicationAtoppedTime    打印应用程序由GC引起的停顿时间

  -XX:+PrintReferenceGC    跟踪系统内的软引用，弱引用，虚引用和finallize队列。
  ```

2. 类跟踪

	```
	-verbose:class    跟踪类的加载和卸载

	-XX:+TraceClassLoading    单独跟踪类加载

	-XX:+TraceClassUnloading    单独跟踪类卸载

	-XX:+PrintClassHistogram    查看运行时类的分布情况，使用时在控制台按ctrl+break
	```

3. 系统参数查看

	```
	-XX:+PrintVMOptions       运行时，打印jvm接受的命令行显式参数

	-XX:+PrintCommandLineFlags    打印传递jvm的显式和隐式参数

	-XX:+PrintFlagsFinal    打印所有系统参数值
	```

4. 堆

	```
	-Xms    堆初始值

	-Xmx    堆最大可用值

	-Xmn    新生代大小，一般设为整个堆的1/3到1/4左右

	-XX:SurvivorRatio    设置新生代中eden区和from/to空间的比例关系n/1

	-XX:NewRatio    设置老年代与新生代的比
	```