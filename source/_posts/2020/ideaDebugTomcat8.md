# idea中调试Tomcat源代码

1. 代码跟踪时tomcat进入的代码有时候会错误。和正在使用tomcat不符合。在pom下新增以下代码进行指定
```
<dependency>
			<groupId>org.apache.tomcat</groupId>
			<artifactId>tomcat-catalina</artifactId>
			<version>8.5.35</version>
			<scope>provided</scope>
		</dependency>
```