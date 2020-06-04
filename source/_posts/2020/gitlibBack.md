# gitLib定时备份代码

1. 在备份的电脑创建git账户。useradd gitlib 。生成ssh密钥放入gitlib中
2. 编写sh脚本
```
	#!/bin/sh
	# 用来定时备份test12的git代码

	# 当前shell脚本所在的目录
	TIME="date +%Y-%m-%d.%H:%M:%S"
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	# 获取gitlib上的需要备份的项目
	PROJECT=(xxx zzz yyy)
	# 遍历上面的项目，确保在一组当中
	for DATA in ${PROJECT[@]} 
	 do  
	   DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	   echo "`$TIME` ----$DATA开始进行备份 $DIR"; 
		if [ -d $DIR/$DATA ]; then   
		   cd $DIR/$DATA
		   back=`git pull`
		   cd $DIR 
		else
		   back=`git clone git@git.kingsilk.xyz:kingsilk/$DATA.git` 
		   #echo "xxx"
		fi  
	done;
```

3. 执行 chmod +x script.sh赋予执行权限
4. gitlib定时拉取代码 表示每小时执行一次备份
```
crontab -e
0 * * * *  /home/gitlib/back/gitLibBack.sh 2>&1 >>  /home/gitlib/back/gitLibBack.log
```

5. gitlab命令
```
docker run --detach \
    --hostname 10.2.2.189 \
    --publish 7043:443 --publish 7070:80 --publish 7022:22 \
    --name gitlabs \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    registry.cn-hangzhou.aliyuncs.com/acs-sample/gitlab-sameersbn:latest
```