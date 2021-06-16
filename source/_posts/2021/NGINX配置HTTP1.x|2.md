id: 20201009110
title: nginx配置HTTP1.x|2
date: 2021-06-16 09:34:08
tags: "笔记"
---------

# nginx配置

## nginx概念

  * nginx反向代理这里不在赘述了.

  1. nginx在配置中,默认是用http1.0进行代理的.
  1. http1.0在压测中也能发现问题.一旦QPS量大后,会出现很多的time_wait.连接不复用.吞吐量无法提升

## nginx1.1的配置
* 1.1的持久化连接,可以复用是提高吞吐量的秘诀
* {PATH}:根据自己的电脑路径设置
* {URLDOMIAN}:根据自己需要的域名设置.
```text
    upstream test-local {
      server 127.0.0.1:8443;
      # 配置连接数量,超时时间.线上根据实际情况配置
      keepalive 50;
      keepalive_requests 20;
    }
    http配置
    server {
        listen       80;
        server_name  {URLDOMIAN}; # 没有可以忽略
        access_log {PATH}/local.log;
        location / {
            proxy_pass  https://test-local;
            proxy_set_header Connection "keep-alive";
            proxy_set_header    Host    $host;
            proxy_set_header    X-Real-IP   $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto $scheme;
            proxy_set_header    Reverse-Proxy nginx;
        }

    }
    # HTTPS server 需要安装https证书
    server {
        listen   443 ssl;
        server_name  {URLDOMIAN};
        access_log {PATH}/local.log;
       ssl_certificate      {PATH}/localhost_ca.cer;
       ssl_certificate_key  {PATH}/localhost_ca.pvk;
        # 以下参数根据自己的情况以及服务的量来制定.在后面有部分说明字段的含义
        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;
        # 必须声明HTTP的版本
        proxy_http_version 1.1; 
        location / {
            proxy_pass  https://test-local/;
            # 中间代理了一层,要告诉服务器,持久化链接
            proxy_set_header Connection "keep-alive";
            # 以下参数根据实际情况来配置
            proxy_set_header    Host    $host;
            proxy_set_header    X-Real-IP   $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto  $scheme;
            proxy_set_header    Reverse-Proxy nginx;
       }
    }

```

## http2的配置
* 经过一个空接口压测,http2压测继续比http1.1的吞吐量上升.没有了http头堵塞.但tcp头堵塞还在
```text
      upstream test-local {
      server 127.0.0.1:8443;
      # 配置连接数量,超时时间.线上根据实际情况配置
      keepalive 50;
      keepalive_requests 20;
    }
    http配置
    server {
        listen       80;
        server_name  {URLDOMIAN}; # 没有可以忽略
        access_log {PATH}/local.log;
        location / {
            proxy_pass  https://test-local;
            proxy_set_header Connection "keep-alive";
            proxy_set_header    Host    $host;
            proxy_set_header    X-Real-IP   $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto $scheme;
            proxy_set_header    Reverse-Proxy nginx;
        }

    }
    # HTTPS server 需要安装https证书
    server {
        # 配置一下这个就好了.学会了就很简单
        listen   443 ssl http2;
        server_name  {URLDOMIAN};
        access_log {PATH}/local.log;
       ssl_certificate      {PATH}/localhost_ca.cer;
       ssl_certificate_key  {PATH}/localhost_ca.pvk;
        # 以下参数根据自己的情况以及服务的量来制定.在后面有部分说明字段的含义
        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;
        location / {
            proxy_pass  https://test-local/;
            # 中间代理了一层,要告诉服务器,持久化链接
            proxy_set_header Connection "keep-alive";
            # 以下参数根据实际情况来配置
            proxy_set_header    Host    $host;
            proxy_set_header    X-Real-IP   $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto  $scheme;
            proxy_set_header    Reverse-Proxy nginx;
       }
    }
```

## 部分字段说明

1. 禁止不安全的 SSL 协议，使用安全协议:ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
2. 禁止已经不安全的加密算法: ssl_ciphers  HIGH:!aNULL:!MD5;  (写法百度下)
3. 缓存连接凭据:ssl_session_cache shared:SSL:20m; ssl_session_timeout 60m;
4. 缓解 BEAST 攻击:ssl_prefer_server_ciphers on;