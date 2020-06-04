# 安装
 ```
  安装到自己定义目录中，记住目录
  #自启动添加 vim /etc/init.d/redis
 ```


## centos 

1. 准备 init.d 脚本（可以搜索 redis rpm，找到rpm包后解压获取相应的init.d脚本，然后在再其基础上修改配置项）
    ```sh
    #!/bin/sh
    # chkconfig: 2345 10 90
    # description:redis
    ##
    ## redis        init file for starting up the redis daemon
    ##
    ## chkconfig:   - 20 80
    ## description: Starts and stops the redis daemon.
    #
    ## Source function library.
    #
    REDISPORT=6379 
    EXEC=/data0/soft/redis/redis-3.0.3/src/redis-server 
    REDIS_CLI=/data0/soft/redis/redis-3.0.3/src/redis-cli 

    PIDFILE=/var/run/redis.pid 
    CONF="/data0/soft/redis/redis-3.0.3/redis.conf" 

    case "$1" in 
        start) 
            if [ -f $PIDFILE ] 
            then 
                    echo "$PIDFILE exists, process is already running or crashed" 
            else 
                    echo "Starting Redis server..." 
                    $EXEC $CONF 
            fi 
            if [ "$?"="0" ]  
            then 
                  echo "Redis is running..." 
            fi 
            ;; 
        stop) 
            if [ ! -f $PIDFILE ] 
            then 
                    echo "$PIDFILE does not exist, process is not running" 
            else 
                    PID=$(cat $PIDFILE) 
                    echo "Stopping ..." 
                    $REDIS_CLI -p $REDISPORT SHUTDOWN 
                    while [ -x ${PIDFILE} ] 
                   do 
                        echo "Waiting for Redis to shutdown ..." 
                        sleep 1 
                    done 
                    echo "Redis stopped" 
            fi 
            ;; 
       restart|force-reload) 
            ${0} stop 
            ${0} start 
            ;; 
      *) 
        echo "Usage: /etc/init.d/redis {start|stop|restart|force-reload}" >&2 
            exit 1 
    esac  
    ```
    并修改其中的配置项 `vi /etc/init.d/redis`

    ```sh
    exec="/data/software/redis/redis-2.8.14/src/redis-server"
    pidfile="/data/store/redis/redis.pid"                                                                 # 应当与redis.conf中的配置保持一致
    REDIS_CONFIG="/data/software/redis/redis-2.8.14/redis.conf"
    REDIS_USER=redis
    ```
    最后为 init.d 脚本修改权限

    ```sh
    chmod u+x /etc/init.d/redis
    chkconfig --add redis
    chkconfig --list redis
    chkconfig --level 345 redis on
    ```
1. 启动

    ```sh
    service redis start
    ```
    
#centos7 
  
  ```
	vi /usr/lib/systemd/system/redis.service
    
    systemctl enable redis

	systemctl start redis
  ```
  