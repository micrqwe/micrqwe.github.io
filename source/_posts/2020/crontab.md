## 使用linux带有的crontab
1. 如果没有该命令，自行安装
2. crontab命令
```
 cron服务提供crontab命令来设定cron服务的，以下是这个命令的一些参数与说明:
    crontab -u //设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数  
　　crontab -l //列出某个用户cron服务的详细内容
　　crontab -r //删除没个用户的cron服务
　　crontab -e //编辑某个用户的cron服务
　　比如说root查看自己的cron设置:crontab -u root -l
　　再例如，root想删除fred的cron设置:crontab -u fred -r
　　在编辑cron服务时，编辑的内容有一些格式和约定，输入:crontab -u root -e
  */30   *    *    *   *   sh xx/java.sh >> var/logs/ftp_`date +"\%Y\%m\%d"`.log 2>&1
　　进入vi编辑模式，编辑的内容一定要符合下面的格式:*/1 * * * * ls >> /tmp/ls.txt
        任务调度的crond常驻命令
        crond 是linux用来定期执行程序的命令。当安装完成操作系统之后，默认便会启动此  

       任务调度命令。crond命令每分锺会定期检查是否有要执行的工作，如果有要执行的工

       作便会自动执行该工作。
```

1. 新增一条一般使用 crontab -u xx -e ；这里编辑的是该用户的定时任务
1. 编辑完后重启，将会开始运行