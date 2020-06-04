# log4j2结合springboot

## 初始化项目

1. pom文件引入
```
      <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-log4j2</artifactId>
        </dependency>
-- 一下distuptor需要根据log4j2的配置。是否需要异步输入日志来判断
        <dependency>
            <groupId>com.lmax</groupId>
            <artifactId>disruptor</artifactId>
            <version>3.4.2</version>
        </dependency>
```
2. 文档地址[springboot logger](https://docs.spring.io/spring-boot/docs/2.2.2.RELEASE/reference/htmlsingle/#boot-features-logging-format) 4.4.6章节

## demo文件

1. 文件默认加载:log4j2-spring.xml or log4j2.xml 。这里推荐使用前者
2. 配置演示文件
```
<?xml version="1.0" encoding="UTF-8"?>
<!--设置log4j2的自身log级别为ERROR-->
<!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
<!--Configuration后面的status，这个用于设置log4j2自身内部的信息输出，可以不设置，当设置成trace时，你会看到log4j2内部各种详细输出-->
<!--monitorInterval：监控间隔，例如：monitorInterval=”600” 指log4j2每隔600秒（10分钟），自动监控该配置文件是否有变化，如果变化，则自动根据文件内容重新配置-->
<configuration status="INFO" monitorInterval="30">
    <Properties>
        <!-- 配置日志文件输出目录 -->
        <Property name="LOG_HOME">E:\\work\\logs</Property>
        <Property name="LOG_BUSINESS_LEVEL">INFO</Property>
        <Property name="LOG_LEVEL">INFO</Property>
        <Property name="LOG_SQL_LEVEL">TRACE</Property>
    </Properties>

    <!--先定义所有的appender-->
    <appenders>

        <!--这个输出控制台的配置-->
        <Console name="Console" target="SYSTEM_OUT">
            <!--输出日志的格式-->
            <PatternLayout pattern="%d [%t] %-5p [%c] - %m%n"/>
        </Console>

       <!--business的日志记录追加器-->
        <RollingRandomAccessFile  name="businessFile" fileName="${LOG_HOME}/leke-business.log" immediateFlush="false" append="true"
                           filePattern="${LOG_HOME}/business-%d{yyyy-MM-dd}-%i.log.gz">
            <PatternLayout pattern="%d [%t] %-5p [%c] - %m%n"/>
            <!--    该日志文件只会打印INFO等级的日志    -->
            <Filters>
                <!--WARN(含WARN)以上的级别信息直接拒绝，WARN以下交由下一个过滤器-->
                <ThresholdFilter level="WARN" onMatch="DENY" onMismatch="NEUTRAL"/>
                <!--接收上一个过滤器来的内容:大于DEBUG信息通过，低于INFO信息的拒绝-->
                <ThresholdFilter level="DEBUG" onMatch="ACCEPT" onMismatch="DENY" />
            </Filters>
            <Policies>
                <SizeBasedTriggeringPolicy size="1000 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingRandomAccessFile >

        <!--exception的日志记录追加器-->
        <RollingRandomAccessFile  name="exceptionFile" fileName="${LOG_HOME}/exception.log" immediateFlush="false" append="true"
                           filePattern="${LOG_HOME}/exception-%d{yyyy-MM-dd}-%i.log.gz">
          <!--WARN(含WARN)以上的级别信息通过，低于WARN的拒绝执行-->
            <Filters>
                <ThresholdFilter level="WARN" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
            <PatternLayout pattern="%d [%t] %-5p [%c] - %m%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="1000 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingRandomAccessFile >

        <Async name="Async">
            <appender-ref ref="Console"/>
            <appender-ref ref="businessFile"/>
            <appender-ref ref="exceptionFile"/>
        </Async>

    </appenders>

    <!--然后定义logger，只有定义了logger并引入的appender，appender才会生效-->
    <loggers>
        <root level="WARN">
            <appender-ref ref="Async"/>
        </root>
        <!--这个是异步输出日志文件。性能高，添加该项依赖要加入disruptor包-->
        <AsyncLogger name="com.alibaba.nacos.client.naming" level="info" additivity="false">
            <appender-ref ref="Console"/>
        </AsyncLogger>
        <!--同步输出日志文件。-->
        <Logger name="com.example.demo.controller" level="WARN" additivity="false">
            <appender-ref ref="Console"/>
            <appender-ref ref="businessFile"/>
            <appender-ref ref="exceptionFile"/>
        </Logger>
    </loggers>
</configuration>
```

## 结合springboot的使用

1. springboot中的YML文件配置优先级高于log4j2.xml 可以在YML配置多环境多配置
2. YML有以下配置。那么整体的日志级别是INFO。非上面XML中配置的WARN。同时controller也一样是info级别的日志也会输出
```
logging:
  level:
    root: INFO
    com:
      example:
        demo:
          controller: INFO
```

## 配置项说明

1. onMatch和onMismatch都有三个属性值，分别为Accept、DENY和NEUTRAL
1. 分别介绍这两个配置项的三个属性值：
```
onMatch="ACCEPT" 表示匹配该级别及以上
onMatch="DENY" 表示不匹配该级别及以上
onMatch="NEUTRAL" 表示该级别及以上的，由下一个filter处理，如果当前是最后一个，则表示匹配该级别及以上
onMismatch="ACCEPT" 表示匹配该级别以下
onMismatch="NEUTRAL" 表示该级别及以下的，由下一个filter处理，如果当前是最后一个，则不匹配该级别以下的
onMismatch="DENY" 表示不匹配该级别以下的
```
