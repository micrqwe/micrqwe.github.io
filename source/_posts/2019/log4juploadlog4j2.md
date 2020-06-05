title: 未分组
date: 2020-06-23 11:10:08
---------
# log4j升级

* log4j在异步日志打印下性能极大提升，好处多多

1. log4j2可以选择异步与同步日志打印.使用异步打印必须配置disruptor包
```
             <dependency>
			<groupId>com.lmax</groupId>
			<artifactId>disruptor</artifactId>
			<version>3.4.2</version>
		</dependency>
```

1. log4j2的xml配置中有AsyncLogger和Logger配置区别。Async就是异步配置
1. log4j2有包架构不匹配。当原有系统不方便需改时。可以使用桥接包
```
<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-1.2-api</artifactId>
			<version>2.13.0</version>
		</dependency>
```

1. 参考其他文章
  * [log4j平稳升级](https://www.cnblogs.com/hujunzheng/p/9937097.html)