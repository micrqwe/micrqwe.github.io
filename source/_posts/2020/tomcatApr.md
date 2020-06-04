# 启用apr模式步聚
## 安装依赖库

1. 因为apr模式本质是使用JNI技术调用操作系统IO接口，需要用到相关API的头文件
 * yum install apr-devel
 * yum install openssl-devel
 * yum install gcc
 * yum install make
```
注意：openssl库要求在0.9.7以上版本，APR要求在1.2以上版本，用rpm -qa | grep openssl检查本机安装的依赖库版本是否大于或等于apr要求的版本。
```
1. 安装apr动态库
  * 进入tomcat的bin目录，解压tomcat-native.tar.gz文件，并进入tomcat-native-1.2.7-src/native目录，执行./configure && make && make install 命令
```
apr如何openssh版本错误,手动指定安装目录: ./configure --with-apr=/usr/local/apr  --with-ssl=/usr/local/openssl
```

1. 编辑$TOMCAT_HOME/bin/catalina.sh文件，在虚拟机启动参数JAVA_OPTS中添加java.library.path参数，指定apr库的路径
  * JAVA_OPTS="$JAVA_OPTS -Djava.library.path=/usr/local/apr/lib"

1. Tomcat8以下版本，需要指定运行模式，将protocol从HTTP/1.1改成org.apache.coyote.http11.Http11AprProtocol
```
<Connector port="8080" protocol="org.apache.coyote.http11.Http11AprProtocol"
connectionTimeout="20000"
redirectPort="8443" />
```

## apr和openssl版本错误
* apr地址:[http://apr.apache.org/download.cgi#apr1](http://apr.apache.org/download.cgi#apr1)
* ssl地址:[https://www.openssl.org/source/](https://www.openssl.org/source/)

1. apr安装
```
tar zxvf apr-1.4.5.tar  
cd apr-1.4.5  
./configure --prefix=/usr/local/apr  
make && make install  
```
1. openssl安装
```
tar -xvzf openssl-1.1.0e.tar.gz
cd openssl-1.1.0e/
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make && make install
```

