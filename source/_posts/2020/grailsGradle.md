# grails3开发
## gradle的依赖本地项目
```
注：gradle 在我们国内有时候快有时候慢，gradle是google的项目
grails引入其他项目做为依赖项目，官网介绍在专门的一张plugins中
-->在主工程目录settings.gradle 添加 include '额外工程名',还有includeFlat。include/includeFlat 意思都是引入，但是层级不一样。自行学习
-->在build.gradle中添加compile project(':额外工程名')
```

## gradle的学习
1. 代码csdn[地址](https://code.csdn.net/micrqwe/gradletestone/tree/master)
```
新建gradleTestOne，gradleTestTwo作为子项目，用于多模块构建，为了方便，作为子节点存在，使用include引用。不使用includeFlat
创建java项目：格式如下:
└── src
    └── main
        └── java
            └── OneTest
IDEA在右侧栏有gradle project的窗口，可以提供快捷的操作，不需要在命令行执行gradle build，run命令
```

## grails2升级grails3
```
问题1:org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'redisMessageListenerContainer' defined in class path resource [org/springframework/session/data/redis/config/annotation/web/http/RedisHttpSessionConfiguration.class]: Unsatisfied dependency expressed through constructor argument with index 0 of type [org.springframework.data.redis.connection.RedisConnectionFactory]: No qualifying bean of type [org.springframework.data.redis.connection.RedisConnectionFactory] is defined: expected single matching bean but found 2: redisConnectionFactory,jedisConnectionFactory; nested exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException: No qualifying bean of type [org.springframework.data.redis.connection.RedisConnectionFactory] is defined: expected single matching bean but found 2: redisConnectionFactory,jedisConnectionFactory
解决:grails3是不是不支持resouce注入
	1. 在src/main/groovy/
	@EnableRedisHttpSession // <1>
	public class Config {
		@Bean
		public JedisConnectionFactory connectionFactory() {
			JedisConnectionFactory jedisConnectionFactory = new JedisConnectionFactory();
			return jedisConnectionFactory; // <2>
		}
	}
	2.  记得在init/Application上加上@ComponentScan("上面文件路径包名")
```

## grails3的domain时候save不出错误日志
```
failOnError: true
```