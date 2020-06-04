# 开启用户管理

1. 编辑tomcat-user.xml文件  添加一下内容
```
 <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <user username="admin" password="admin" roles="manager-gui, manager-script"/>
```

## 添加后依然403无法访问

1. manager 配置有问题，因为只允许本机访问所以其他人无法访问，
```
$TOMCAT_HOME/webapps/manager/META-INF/context.xml文件中
<Context antiResourceLocking="false" privileged="true" >
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
</Context>
```
2. 只需加入本机ip即可，或者注释掉上面的语句
```
<Context antiResourceLocking="false" privileged="true" >
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|10.0.1.143" />
</Context>
```

