# maven私服配置
1. 下载nexus直接运行bin目录 ./nexus start启动;
2. 浏览器输入http://localhost:8081/nexus
3. maven需要配置。在~/.m2/setting.xml,添加一下内容

```
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <pluginGroups>
  </pluginGroups>

  <proxies>
  </proxies>

  <servers>
  </servers>

  <mirrors>
    <mirror>
      <mirrorOf>*</mirrorOf>
      <name>kingsilk</name>
      <url>http://mvn.kingsilk.xyz/content/groups/public/</url>
      <id>kingsilk</id>
    </mirror>
  </mirrors>

  <profiles>
    <profile>
        <id>downloadSources</id>
        <properties>
            <downloadSources>true</downloadSources>
            <downloadJavadocs>true</downloadJavadocs>
        </properties>
    </profile>
  </profiles>

  <activeProfiles>
    <activeProfile>downloadSources</activeProfile>
  </activeProfiles>
</settings>
```

 1.nexus[下载地址](http://www.sonatype.org/nexus/go/)选择对应的包

clean install -Dmaven.test.skip=true