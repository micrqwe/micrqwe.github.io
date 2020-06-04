由于官方的 Nginx 缺乏一些常用特性。比如：

1. 对于负载均衡，nginx 不支持 sticky session 方式。如果使用 ip hash, 也可能会负载不均衡。
1. 不支持对后台服务的health check。

因此，服务器上决定使用 [Tengine](http://tengine.taobao.org/) 来取代 Nginx 官方版。

## 安装

1. 安装依赖

    ```sh
    yum install openssl openssl-devel
    # 或者
    sudo apt-get install openssl libssl-dev
    sudo apt-get install build-essential
    sudo apt-get install linux-kernel-headers
    sudo apt-get install gcc libpcre3 libpcre3-dev zlib1g-dev 
    ```

1. 下载、编译并安装
    
    ```sh
    mkdir /usr/local/tengine
    
    cd /tmp
    wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
    tar zxvf tengine-2.1.0.tar.gz
    chown -R root:root tengine-2.1.0
    cd tengine-2.1.0
    ./configure --prefix=/usr/local/tengine/tengine-2.1.0 --user=nginx
    make
    make install
    ```

1. 修改配置

    ```sh
    cd /usr/local/tengine/tengine-2.1.0
    mkdir conf/conf.d
    vi conf/nginx.conf
    # 1. 启用 "log_format main ..."
    # 2. 在 "http {...}" 的 最后一行 加入 "include conf.d/*.conf;"
    # 3. 在最开始，设置 `user www`, 以非root 用户运行
    # 4. 修改 worker_process 为 CPU 核心数量

    useradd www
    chown -R www:www logs
    ```

### centos 7

1. 新建 systemd 所需的 service 文件： `vi /usr/lib/systemd/system/tengine.service` :

    ```
    [Unit]
    Description=Tengine Server
    After=network.target

    [Service]
    Type=forking
    ExecStartPre=/usr/local/tengine/tengine-2.1.0/sbin/nginx -t
    ExecStart=/usr/local/tengine/tengine-2.1.0/sbin/nginx
    ExecReload=/bin/kill -s HUP $MAINPID
    ExecStop=/bin/kill -s QUIT $MAINPID
    WorkingDirectory=/usr/local/tengine/tengine-2.1.0/
    PIDFile=/usr/local/tengine/tengine-2.1.0/logs/nginx.pid
    Restart=always
    User=root
    LimitNOFILE=65535
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target
    ```

1.  启用、启动

    ```    
    systemctl enable tengine
    systemctl start tengine
    systemctl status tengine
    ```

### centos 6

1. 下载 init.d 脚本。从 [这里](http://wiki.nginx.org/InitScripts) 为 CentOS 下载 `Red Hat /etc/init.d/nginx`, 并保存到 `/etc/init.d/nginx`

1.  修改  `/etc/init.d/nginx` ,

    ```sh
    nginx="/usr/local/tengine-2.1.0/sbin/nginx"
    NGINX_CONF_FILE="/usr/local/tengine-2.1.0/conf/nginx.conf"
    ```	

### ubuntu

参考[这里](http://wiki.nginx.org/Upstart)

1. make

    ```
    sudo apt-get install libpcre3 libpcre3-dev
    sudo apt-get install openssl libssl-dev
    ```


1. `vi /etc/init/tengine.conf`
    ```

## mac
```
---------------------------- 需要PCRE依赖，没报错跳过
装nginx的时候报错：./configure: error: the HTTP rewrite module requires the PCRE library.
[##]、访问ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre
下载完成之后，使用CD命令进入到相应的下载文件夹，执行命令：
sudo tar xvfz pcre-8.12.tar.gz  解压文件
解压完成之后，执行命令
cd pcre-8.12
sudo ./configure --prefix=/usr/local --enable-utf8 
sudo make 
sudo make install 
---------------------------- 需要openssl依赖，没报错跳过
================= openssl 不需要安装，tengin中使用的时源码包，下面介绍的只是如果安装的方法
安装/替换:openssl
如果你是32位系统的mac，那么输入 
./config  --prefix=/usr/local/openssl 
如果你是64位系统的mac，那么输入 
./Configure darwin64-x86_64-cc  --prefix=/usr/local/openssl 
sudo make 
sudo make install
================
---------------------------
```

### mac开发编译tengine
```
./configure --with-openssl=/usr/local  --prefix=/usr/local/openssl  --with-pcre=/usr/pcre
注：上面制定的路径都是未编译的文件夹，直接解压缩的。
xxxxxxxxxxxxxxx 64位电脑注意，过程中有5秒时间要求输入以下，也可以不输
./Configure darwin64-x86_64-cc,  该解决方法可能不行，还是会出现下面的问题
(注)：出现ld: symbol(s) not found for architecture x86_64 。 这是由于64位电脑编译openssl错误导致的
解决方法：手动修改:vi objs/Makefile 
./config --prefix=/Users/xxx/Downloads/openssl-1.0.1e/.openssl no-shared  no-threads
改成
./Configure darwin64-x86_64-cc --prefix=/Users/xxx/Downloads/openssl-1.0.1e/.openssl no-shared  no-threads
注：改了上面的问题还是会出现，这时候删除openssl文件，重新解压，在重新重第一不开始
```

# tengine
```
	description "tengine http daemon"
     
    start on (filesystem and net-device-up IFACE=lo)
    stop on runlevel [!2345]
     
    env DAEMON=/usr/local/tengine/tengine-2.1.0/sbin/nginx
    env PID=/usr/local/tengine/tengine-2.1.0/logs/nginx.pid
     
    expect fork
    respawn
    respawn limit 10 5
    #oom never
     
    pre-start script
            $DAEMON -t
            if [ $? -ne 0 ] 
                    then exit $?
            fi
    end script
    exec $DAEMON
```

1. 启动
 
    ```
    sudo service tengine status
    sudo service tengine start
    ```
    
# tengine使用演示配置

 
1.复杂配置

  ```
  server {
  listen *:80;
  server_name {{域名}};
  root /404;

  client_max_body_size 20m;
  ignore_invalid_headers off;

  access_log  logs/{{成功日志}}.access.log main;
  error_log   logs/{{错误日志}}.error.log;
#GZIP配置    
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
   gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain text/css application/javascript text/javascript application/x-javascript text/xml application/xml application/xml+rss application/json;
    gzip_vary off;
   gzip_disable "MSIE [1-6]\.";

  location ~ /local/test/(\d+) {   # 这个必须在前面
  set $p $1; 

  proxy_pass              http://localhost:$p;
  proxy_set_header        Host            $host;
  proxy_set_header        X-Real-IP       $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto $scheme;
  }   

  location ~ /local/test/ {
  set $p 9999;
  if ( $arg__ddnsPort ~ "^(\d*)$" ) { 
  set $p $1; 
  }

  proxy_pass              http://localhost:$1;
  proxy_set_header        Host            $host;
  proxy_set_header        X-Real-IP       $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto $scheme;
  }   
  }
  ```
     
 2.简单配置`没有变量`
  
  
  ```简单
  server {
  listen *:16000;
  server_name {{域名}};
  root html;
  index  index.html index.htm;

  access_log  logs/{{成功日志}}.access.log main;
  error_log   logs/{{错误日志}}.error.log;

  `//alias会直接使用定义的路径.root会在定义的路径后面加上location`
  location /local/test/ { 
  (alias/root)    /home/zll/work/git-repo/kingsilk/qh-wap-front/target/dist/;
  }   

  location /local/test/16000/ { 
  alias    /home/zll/work/git-repo/kingsilk/qh-wap-front/target/dist/;
  }
  location /local/test/16000/api/ { 
  proxy_pass              http://localhost:16030;

  proxy_set_header        Host            $host;   # ???  $http_host;
  proxy_set_header        X-Real-IP       $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto $scheme;
  }   
  }
  ```