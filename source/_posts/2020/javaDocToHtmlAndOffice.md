# doc转html

## POI，Office，libreoffice，openoffice
1. linux中无法调用windows的office组件来进行转换。微软office组件解析最佳
2. linux下libreoffice解析最佳
3. poi工具适用于简单转换。无法兼容doc下的数学公式。只对普通文本有效果
4. openoffice存在同样与poi一样的问题。
结论：windows下可以使用libreoffice 微软office。linux只有libreoffice

## libreoffice在java中使用

1. [libreoffice链接](https://www.libreoffice.org/)
2. 安装步骤。 大写的**省略**
3. 安装完成后需要启动监听端口:

***
soffice -headless -accept="socket,port=8100;urp;"

部分电脑可能需要输入：soffice -headless -accept="socket,host=127.0.0.1,port=8100;urp;" -nofirststartwizard
***

## java中使用

1. 百度的结果
```
1. 引入maven：--------------------- 
<dependency> 
    <groupId>com.artofsolving</groupId> 
    <artifactId>jodconverter</artifactId>
    <version>2.2.2</version> 
</dependency>
注： com.artofsolving 已经不维护。maven仓库版本最高只有2.2.1 。而且不支持docx的解析。2.2.2需要自己去其他地方下载
----------------------------
```

2.  artofsolving已经代码公开，目前已经由org.jodconverter 接手

```
maven引入：
	<dependency>
		<groupId>org.jodconverter</groupId>
		<artifactId>jodconverter-local</artifactId>
		<version>4.2.2</version>
	</dependency>
```

3. github连接地址:https://github.com/sbraconnier/jodconverter




