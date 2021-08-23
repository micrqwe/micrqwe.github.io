id: 202006231110
title: Runcher2.0安装
date: 2021-06-26 09:12:08
tags: "笔记"
---------

# hello word开始
* 使用的ubuntu 20.04.

## 安装1.6版本

1. 镜像地址:https://hub.docker.com/r/rancher/server
2. 启动docker:docker run -d --restart=unless-stopped -p 8082:8080 --name rancher1.6  rancher/server

* 问题
  1. 添加主机的时候,如果是单机版本,住下docker-agent的dns错误.可参考下面: https://github.com/rancher/rancher/issues/1108
  ```text
   我用的是:
   vim /etc/default/docker
   # replace
   # # DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"
   # by
   DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"
   # then restart Docker
    service docker restar
   ```
   
## 安装2.5版本

* 官方中文文档:http://docs.rancher.cn/docs/rancher2.5/installation/other-installation-methods/single-node-docker/_index

1. 安装rancher（v2.5）:直接通过docker镜像来运行我们的rancher，首先，先从镜像中心下载rancher镜像，如果是1.x系列的，镜像名为rancher/server，而2.x是rancher/rancher，我们使用2.x版本的，所以，执行如下命令即可：
    ```text
    docker pull rancher/rancher
    ```
1. 执行如下命令，在宿主机创建两个挂载目录.(根据情况来使用,就只看看不用了);
    ```text
     mkdir -p /docker_volume/rancher_home/rancher
     mkdir -p /docker_volume/rancher_home/auditlog
     mkdir -p /home/rancher/ssl
    ```
1. 生成签名证书:http://docs.rancher.cn/docs/rancher2/installation/resources/advanced/self-signed-ssl/_index
   ```text
     官方文档有很好的解决
   ```
1. 接下来我们启动rancher容器:(端口根据自己需要来定义.我这里有其他端口被占用了).2.5版本中docker需要提权加:--privileged
    ```text
    docker run -d --privileged --restart=unless-stopped  \
   -p 8081:80 -p 8443:443 \
   -e NO_PROXY="localhost,127.0.0.1,0.0.0.0,10.0.0.0/8,192.168.0.0/24,124.160.111.194" \
   -v /home/rancher/ssl:/container/certs \
   -e SSL_CERT_DIR="/container/certs" \
   -v /docker_volume/rancher_home/rancher:/var/lib/rancher \
   -v /docker_volume/rancher_home/auditlog:/var/log/auditlog \
   --name rancher rancher/rancher:v2.5-head
    ```
1. 查看日志:
    ```text
     docker logs -f $ID
    ```
## 单机(测试)使用

1. 端口映射选择集群IP.
1. 高级选项中:网络是用主机网络
1. rancher如果是1.5版本,网络选择桥接,方便单机中使用.
备注: 端口映射的是使用的iptables,非docker的端口映射.这里选择是为了方便,使用其他类型需要做网络转发.
