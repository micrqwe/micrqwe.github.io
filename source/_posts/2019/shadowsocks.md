title: shadowsocks安装
date: 2020-06-23 11:10:08
tags: ["linux"]
---------
## 安装pip3
yum install python34-pip -y
pip3 install shadowsocks

## 编辑配置文件
vim /etc/shadows.conf
{
    "server":"0.0.0.0",
    "port_password":{
     "9001":"vb6Zx5ty",
     "9002":"vb6Zx5ty",
     "9003":"vb6Zx5ty"
     },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}

#注：配置文件中，启动了三个监听端口


## 启动
ssserver -c /etc/shadows.conf -d start &
