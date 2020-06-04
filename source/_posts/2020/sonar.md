# java代码规范工具安装和Idea下的使用
```
	预置条件
	1.已安装JAVA环境
	2.已安装有MySQL数据库

	软件下载地址：http://www.sonarqube.org/downloads/
	下载SonarQube与SonarQube Runner
	中文补丁包下载：http://docs.codehaus.org/display/SONAR/Chinese+Pack
```

1. 数据库配置
```
	进入数据库命令
	#mysql -u root -p
	mysql> CREATE DATABASE sonar CHARACTER SET utf8 COLLATE utf8_general_ci; 
	mysql> CREATE USER 'sonar' IDENTIFIED BY 'sonar';
	mysql> GRANT ALL ON sonar.* TO 'sonar'@'%' IDENTIFIED BY 'sonar';
	mysql> GRANT ALL ON sonar.* TO 'sonar'@'localhost' IDENTIFIED BY 'sonar';
	mysql> FLUSH PRIVILEGES;
```

2. 安装sonar
```
	#vi conf/sonar.properties
	sonar.jdbc.username=sonar
	sonar.jdbc.password=sonar
	sonar.jdbc.url=jdbc:mysql://test12.kingsilk.xyz:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance
	将上面几行注释打开
```

3. 启动服务
```
目录切换至sonar的<install_directory>/bin/linux-x86-64/目录，启动服务
#./sonar.sh start   启动服务
#./sonar.sh stop    停止服务
#./sonar.sh restart 重启服务
```

4. 安装sonar-runner 
```
sonar是一个平台，运行还需要其他插件
http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
包含(maven jenkins)
```

5. 添加到jenkins中
```
	http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Jenkins  
	jenkins添加sonarQbue plugins
	在system config中填写 SonarQube servers
	必须配置：SonarQube Scanner ，用来扫描
	windows中配置：SonarQube Scanner for MSBuild

	在jenkins任务中进行配置：add build step添加:Execute SonarQube Scanner  。
```