# docker运行

## docker的安装
```
一个大写的略过
```

## docker 登陆
```
sudo docker login --username=xxxxx@qq.com registry.cn-hangzhou.aliyuncs.com
```

## docker自动构建gitHub项目(阿里云为例子)

1. 先github或者阿里云git创建项目:[以下为例子](https://code.aliyun.com/287507016/swagger "以下为例子")
2. 进入[阿里云开发者](https://dev.aliyun.com "阿里云开发者");登陆，创建我的镜像进入我的镜像仓库
3. 选择创建镜像仓库
4. 这里会要求建立一个密码，用于登陆docker使用，这里会先以账户名建立一个namespace。
5. 下面选择阿里云Code创建，构建设置可以设置：代码自动构建，不使用缓存
```
自动构建是在代码有变动的时候会重新编译镜像。
```

6. 使用代码构件，最顶层要有一个Dockerfile文件，会按照该文件进行构件
7. 进入详细信息，里面就会列举下载地址，包括如下下载，并且重新发布

## 配置固定的ip
第一步：安装最新版的Docker
备注：操作系统自带的docker的版本太低，不支持静态IP，因此需要自定义安装。
root@localhost:~# apt-get update
root@localhost:~# apt-get install curl
root@localhost:~# curl -fsSL https://get.docker.com/ | sh
root@localhost:~# docker -v
Docker version 1.10.3, build 20f81dd

第二步：创建自定义网络
备注：这里选取了172.18.0.0网段，也可以指定其他任意空闲的网段
docker network create --subnet=172.18.0.0/16 shadownet
注：shadown为自定义网桥的名字，可自己任意取名。

第三步：在你自定义的网段选取任意IP地址作为你要启动的container的静态IP地址
备注：这里在第二步中创建的网段中选取了172.18.0.10作为静态IP地址。这里以启动shadowsocks为例。
docker run -d -p 2001:2001 --net shadownet --ip 172.18.0.10 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 2001 -k 123456 -m aes-256-cfb

其他
备注1：这里是固定IP地址的一个应用场景的延续，仅作记录用，可忽略不看。
备注2：如果需要将指定IP地址的容器出去的请求的源地址改为宿主机上的其他可路由IP地址，可用iptables来实现。比如将静态IP地址172.18.0.10出去的请求的源地址改成公网IP104.232.36.109(前提是本机存在这个IP地址)，可执行如下命令：
iptables -t nat -I POSTROUTING -o eth0 -d  0.0.0.0/0 -s 172.18.0.10  -j SNAT --to-source 104.232.36.109

```
  1. 获取docker容器的IP使用命令:docker inspect 容器ID
  2. 然后过虑出 IPAddress 即可查看 Docker 的IP :docker inspect 容器ID | grep IPAddress
```

## 容器修改后创建镜像推送，阿里云为例
1. sudo docker commit [容器的名字] [nameSpace]/[名字]:[版本]
```
注： 这里已经创建了一个新的image镜像文件
```

2. 推送到阿里云上面，需要重新命名
```
  $ sudo docker login --username=xxx xxx
  $ sudo docker tag [ImageId] xxx:[镜像版本号]
  $ sudo docker push xxx:[镜像版本号]
  其中xxx请参考自己的仓库的信息
```

## docker容器和主机互相拷贝文件

```
    1.容器到主机 docker cp <containerId>:/file/path/within/container /host/path/target
    2. 主机到容器，反过来就可以
```

## docker容器启动

```
    1. docker run -dti -p 11:11 -v E:/worke:/data  --name nginx  --restart always nginxId
    2. 使用在Docker run的时候使用--restart参数来设置。
    3. no - container：不重启 / on-failure - container:退出状态非0时重启 / always:始终重启
    4. -d 后台启动 -t -i ?  / -p 映射的端口 / -v 挂载的目录 / --name 重定义名字
    5. 一个gitlab的例子:
    docker run -t -i --detach  --hostname 10.2.2.189  --publish 8443:443 --publish 80:80 --publish 8022:22 --name gitlab  --restart always  --volume /home/le/gitlab/config:/etc/gitlab  --volume /home/le/gitlab/logs:/var/log/gitlab  --volume /home/le/gitlab/data:/var/opt/gitlab --privileged=true registry.cn-hangzhou.aliyuncs.com/lab99/gitlab-ce-zh
(22和443端口经常会被占用，这里看自己的情况修改)
```

## docker mq启动
```
docker run --name='activemq' -d \
-e 'ACTIVEMQ_NAME=amqp-srv1' \
-e 'ACTIVEMQ_REMOVE_DEFAULT_ACCOUNT=true' \
-e 'ACTIVEMQ_ADMIN_LOGIN=admin' -e 'ACTIVEMQ_ADMIN_PASSWORD=fJbbIDUzllkv' \
-e 'ACTIVEMQ_WRITE_LOGIN=producer_login' -e 'ACTIVEMQ_WRITE_PASSWORD=TgVodjA1WYoR' \
-e 'ACTIVEMQ_READ_LOGIN=consumer_login' -e 'ACTIVEMQ_READ_PASSWORD=YRq49Vz6kv3X' \
-e 'ACTIVEMQ_JMX_LOGIN=jmx_login' -e 'ACTIVEMQ_JMX_PASSWORD=3RincOQObyK5' \
-e 'ACTIVEMQ_STATIC_TOPICS=topic1;topic2;topic3' \
-e 'ACTIVEMQ_STATIC_QUEUES=queue1;queue2;queue3' \
-e 'ACTIVEMQ_MIN_MEMORY=1024' -e  'ACTIVEMQ_MAX_MEMORY=4096' \
-e 'ACTIVEMQ_ENABLED_SCHEDULER=true' \
-v /data/activemq:/data/activemq \
-v /var/log/activemq:/var/log/activemq \
-p 8161:8161 \
-p 61616:61616 \
-p 61613:61613 \
docker.io/webcenter/activemq
```

## 容器挂载目录权限不够

```
 加上  --privileged=true 参数，给与容器特殊权限
```

## docker pull镜像很慢

1. 因为pull直接是国外的镜像，docker hub在中国没有cdn分发。
1. [阿里云开发者](https://dev.aliyun.com "阿里云开发者")
2. 使用阿里云的镜像加速，在阿里云开发者注册帐号。在控制台->docker镜像仓库->加速器
3. 在这里会有每个人的专属加速的url网址，下面有介绍如何使用
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20170606-1049-22475-3389/QQ%25E6%2588%25AA%25E5%259B%25BE20170606104905.jpg)

## docker镜像

1. 容器转成镜像：
```
 sudo docker commit <CONTAINER ID> imagename01
```

1. 容器转成文件：
```
 sudo docker export <CONTAINER ID> > /home/export.tar
```

1. 镜像转成文件：
```
sudo docker save imagename01 > /home/save.tar
注：一般情况下，save.tar比export.tar大一点点而已，export比较小，因为它丢失了历史和数据元metadata
```

1. 文件转成镜像：
```
 cat /home/export.tar | sudo docker import - imagename02:latest
```

1. save.tar文件转成镜像：
```
docker load < /home/save.tar
```
注： save和export的区别是 save会记录历史，export只记录当前的镜像
查看转成的镜像：sudo docker images