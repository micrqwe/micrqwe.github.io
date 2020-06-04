# jvm中常用工具和命令
1. jstack -- 如果Java程序崩溃生成core文件，jstack工具可以用来获得core文件的java stack和native stack的信息，从而可以轻松地知道java程序是如何崩溃和在程序何处发生问题。另外，jstack工具还可以附属到正在运行的java程序中，看到 当时运行的java程序的java stack和native stack的信息, 如果现在运行的java程序呈现hung的状态，jstack是非常有用的。目前只有在Solaris和Linux的JDK版本里面才有。

2. jconsole – jconsole是基于Java Management Extensions (JMX)的实时图形化监测工具，这个工具利用了内建到JVM里面的JMX指令来提供实时的性能和资源的监控，包括了Java 程序的内存使用，Heap size, 线程的状态，类的分配状态和空间使用等等。

1. jvisualvm-最新出现的功能强大的工具

3. jinfo – jinfo可以从core文件里面知道崩溃的Java应用程序的配置信息，目前只有在Solaris和Linux的JDK版本里面才有。

4. jmap – jmap 可以从core文件或进程中获得内存的具体匹配情况，包括Heap size, Perm size等等，目前只有在Solaris和Linux的JDK版本里面才有。

5. jdb – jdb 用来对core文件和正在运行的Java进程进行实时地调试，里面包含了丰富的命令帮助您进行调试，它的功能和Sun studio里面所带的dbx非常相似，但 jdb是专门用来针对Java应用程序的。

6. jstat – jstat利用了JVM内建的指令对Java应用程序的资源和性能进行实时的命令行的监控，包括了对Heap size和垃圾回收状况的监控等等。

7. jps – jps是用来查看JVM里面所有进程的具体状态, 包括进程ID，进程启动的路径等等。

## 具体使用

1. jmap的使用.pid 使用ps命令获取
	```
	1. 查看整个JVM内存状态 
	jmap -heap [pid]
	要注意的是在使用CMS GC 情况下，jmap -heap的执行有可能会导致JAVA 进程挂起
	
	2. 查看JVM堆中对象详细占用情况
	jmap -histo [pid]
	
	3. 导出整个JVM 中内存信息
	jmap -dump:format=b,file=文件名 [pid]
	```

1. jstat的具体使用
	
	* option： 参数选项
	*	-t： 可以在打印的列加上Timestamp列，用于显示系统运行的时间
	*	-h： 可以在周期性数据数据的时候，可以在指定输出多少行以后输出一次表头
	*	vmid： Virtual Machine ID（ 进程的 pid）
	*	interval： 执行每次的间隔时间，单位为毫秒
	*	count： 用于指定输出多少次记录，缺省则会一直打印

  option   可以从下面参数中选择

	```
	-class                 显示ClassLoad的相关信息；
	-compiler           显示JIT编译的相关信息；
	-gc                     显示和gc相关的堆信息；
	-gccapacity 　　  显示各个代的容量以及使用情况；
	-gcmetacapacity 显示metaspace的大小
	-gcnew               显示新生代信息；
	-gcnewcapacity  显示新生代大小和使用情况；
	-gcold                 显示老年代和永久代的信息；
	-gcoldcapacity    显示老年代的大小；
	-gcutil　　           显示垃圾收集信息；
	-gccause             显示垃圾回收的相关信息（通-gcutil）,同时显示最后一次或当前正在发生的垃圾回收的诱因；
	-printcompilation 输出JIT编译的方法信息；
	```
* 示例一：-class
	```
	显示加载class的数量，及所占空间等信息。
	jstat -class <pid>
	Loaded : 已经装载的类的数量
	Bytes : 装载类所占用的字节数
	Unloaded：已经卸载类的数量
	Bytes：卸载类的字节数
	Time：装载和卸载类所花费的时间
	```

* 示例二： -compiler
	```
	显示VM实时编译(JIT)的数量等信息。
	jstat -compiler <pid>
	Compiled：编译任务执行数量
	Failed：编译任务执行失败数量
	Invalid  ：编译任务执行失效数量
	Time  ：编译任务消耗时间
	FailedType：最后一个编译失败任务的类型
	FailedMethod：最后一个编译失败任务所在的类及方法
	```

* 示例三： -gc

	```

		显示gc相关的堆信息，查看gc的次数，及时间。
		jstat –gc <pid>
		
		S0C：年轻代中第一个survivor（幸存区）的容量 （字节）
		S1C：年轻代中第二个survivor（幸存区）的容量 (字节)
		S0U   ：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)
		S1U     ：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)
		EC      ：年轻代中Eden（伊甸园）的容量 (字节)
		EU       ：年轻代中Eden（伊甸园）目前已使用空间 (字节)
		OC        ：Old代的容量 (字节)
		OU      ：Old代目前已使用空间 (字节)
		MC：metaspace(元空间)的容量 (字节)
		MU：metaspace(元空间)目前已使用空间 (字节)
		YGC    ：从应用程序启动到采样时年轻代中gc次数
		YGCT   ：从应用程序启动到采样时年轻代中gc所用时间(s)
		FGC   ：从应用程序启动到采样时old代(全gc)gc次数
		FGCT    ：从应用程序启动到采样时old代(全gc)gc所用时间(s)
		GCT：从应用程序启动到采样时gc用的总时间(s)
	```

* 示例四：  -gccapacity
	```

		可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小
		jstat -gccapacity <pid>
		
		NGCMN   ：年轻代(young)中初始化(最小)的大小(字节)
		NGCMX    ：年轻代(young)的最大容量 (字节)
		NGC    ：年轻代(young)中当前的容量 (字节)
		S0C  ：年轻代中第一个survivor（幸存区）的容量 (字节)
		S1C  ：    年轻代中第二个survivor（幸存区）的容量 (字节)
		EC    ：年轻代中Eden（伊甸园）的容量 (字节)
		OGCMN     ：old代中初始化(最小)的大小 (字节)
		OGCMX      ：old代的最大容量(字节)
		OGC：old代当前新生成的容量 (字节)
		OC     ：Old代的容量 (字节)
		MCMN：metaspace(元空间)中初始化(最小)的大小 (字节)
		MCMX ：metaspace(元空间)的最大容量 (字节)
		MC ：metaspace(元空间)当前新生成的容量 (字节)
		CCSMN：最小压缩类空间大小
		CCSMX：最大压缩类空间大小
		CCSC：当前压缩类空间大小
		YGC   ：从应用程序启动到采样时年轻代中gc次数
		FGC：从应用程序启动到采样时old代(全gc)gc次数
	```

* 示例五：-gcmetacapacity

	```
	metaspace 中对象的信息及其占用量。
	jstat -gcmetacapacity<pid>
	
	MCMN:最小元数据容量
	MCMX：最大元数据容量
	MC：当前元数据空间大小
	CCSMN：最小压缩类空间大小
	CCSMX：最大压缩类空间大小
	CCSC：当前压缩类空间大小
	YGC  ：从应用程序启动到采样时年轻代中gc次数
	FGC   ：从应用程序启动到采样时old代(全gc)gc次数
	FGCT    ：从应用程序启动到采样时old代(全gc)gc所用时间(s)
	GCT：从应用程序启动到采样时gc用的总时间(s)
	```

* 示例六： -gcnew

	```
	年轻代对象的信息。
	jstat -gcnew <pid>
	
	S0C   ：年轻代中第一个survivor（幸存区）的容量 (字节)
	S1C   ：年轻代中第二个survivor（幸存区）的容量 (字节)
	S0U   ：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)
	S1U  ：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)
	TT：持有次数限制
	MTT：最大持有次数限制
	DSS：期望的幸存区大小
	EC：年轻代中Eden（伊甸园）的容量 (字节)
	EU ：年轻代中Eden（伊甸园）目前已使用空间 (字节)
	YGC ：从应用程序启动到采样时年轻代中gc次数
	YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)
	```

* 示例七： -gcnewcapacity

	``` 
	年轻代对象的信息及其占用量
	jstat -gcnewcapacity <pid>
	
	NGCMN     ：年轻代(young)中初始化(最小)的大小(字节)
	NGCMX      ：年轻代(young)的最大容量 (字节)
	NGC     ：年轻代(young)中当前的容量 (字节)
	S0CMX    ：年轻代中第一个survivor（幸存区）的最大容量 (字节)
	S0C    ：年轻代中第一个survivor（幸存区）的容量 (字节)
	S1CMX ：年轻代中第二个survivor（幸存区）的最大容量 (字节)
	S1C：年轻代中第二个survivor（幸存区）的容量 (字节)
	ECMX：年轻代中Eden（伊甸园）的最大容量 (字节)
	EC：年轻代中Eden（伊甸园）的容量 (字节)
	YGC：从应用程序启动到采样时年轻代中gc次数
	FGC：从应用程序启动到采样时old代(全gc)gc次数
	```

* 示例八： -gcold

	```
	old代对象的信息
	jstat -gcold <pid>
	
	MC ：metaspace(元空间)的容量 (字节)
	MU：metaspace(元空间)目前已使用空间 (字节)
	CCSC:压缩类空间大小
	CCSU:压缩类空间使用大小
	OC：Old代的容量 (字节)
	OU：Old代目前已使用空间 (字节)
	YGC：从应用程序启动到采样时年轻代中gc次数
	FGC：从应用程序启动到采样时old代(全gc)gc次数
	FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)
	GCT：从应用程序启动到采样时gc用的总时间(s)
	```

* 示例九：-gcoldcapacity

	```
	old代对象的信息及其占用量
	jstat -gcoldcapacity <pid>
	
	OGCMN      ：old代中初始化(最小)的大小 (字节)
	OGCMX       ：old代的最大容量(字节)
	OGC        ：old代当前新生成的容量 (字节)
	OC      ：Old代的容量 (字节)
	YGC  ：从应用程序启动到采样时年轻代中gc次数
	FGC   ：从应用程序启动到采样时old代(全gc)gc次数
	FGCT    ：从应用程序启动到采样时old代(全gc)gc所用时间(s)
	GCT：从应用程序启动到采样时gc用的总时间(s)
	```

* 示例十： - gcutil

	```
	统计gc信息
	jstat -gcutil <pid>
	
	S0    ：年轻代中第一个survivor（幸存区）已使用的占当前容量百分比
	S1    ：年轻代中第二个survivor（幸存区）已使用的占当前容量百分比
	E     ：年轻代中Eden（伊甸园）已使用的占当前容量百分比
	O     ：old代已使用的占当前容量百分比
	P    ：perm代已使用的占当前容量百分比
	YGC  ：从应用程序启动到采样时年轻代中gc次数
	YGCT   ：从应用程序启动到采样时年轻代中gc所用时间(s)
	FGC   ：从应用程序启动到采样时old代(全gc)gc次数
	FGCT    ：从应用程序启动到采样时old代(全gc)gc所用时间(s)
	GCT：从应用程序启动到采样时gc用的总时间(s)
	```

* 示例十一：-gccause

	```
	显示垃圾回收的相关信息（通-gcutil）,同时显示最后一次或当前正在发生的垃圾回收的诱因。
	jstat -gccause <pid>
	
	
	LGCC：最后一次GC原因
	GCC：当前GC原因（No GC 为当前没有执行GC）
	```

* 示例十二： -printcompilation

	```
	当前VM执行的信息。
	jstat -printcompilation <pid>
	
	Compiled ：编译任务的数目
	Size ：方法生成的字节码的大小
	Type：编译类型
	Method：类名和方法名用来标识编译的方法。类名使用/做为一个命名空间分隔符。方法名是给定类中的方法。上述格式是由-XX:+PrintComplation选项进行设置的
	```

## 网络代理，访问限制网站
1. 通过 命令行参数 指定

1. 如果只需要考虑代理 HTTP 协议请求，只需添加如下命令行参数：
> -Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=1080

1. 想要 HTTP 和 HTTPS 协议的请求都通过代理访问网络，可以追加上：
>-Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=1080

1. 最终填写的值为：
>-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=1080 -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=1080


议	属性（代理主机/代理端口/不使用代理的主机列表）	默认值
HTTP	http.proxyHost	<none>
http.proxyPort	80
http.nonProxyHosts	<none>
>
HTTPS	https.proxyHost	<none>
https.proxyPort	443
https.nonProxyHosts	<none>
>
FTP	ftp.proxyHost	<none>
ftp.proxyPort	80
ftp.nonProxyHosts	<none>
>
SOCKS	socksProxyHost	<none>
socksProxyPort	1080