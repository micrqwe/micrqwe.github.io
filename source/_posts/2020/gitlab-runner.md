# gitlab-runner是和gitlab紧密结合的构建工具，本篇文章使用docker进行构建(docker自己参考百度)

1. jenkins是很流行的可以和很多其他工具结合的一个构建工具。
2. gitlab-runner看名字就知道只和gitlab结合。

## docker pull镜像速度很慢

1. 参考 [文档](https://code.csdn.net/micrqwe/document/file/docker.md "文档")

## 关于gitlab-ci
1. 网上一搜很多关于安装gitlab-ci和gitlab-runner。
2. 这里我说下，新版gitlab从8.0以上起，就已经集成了gitlab-ci。不需要额外安装。只需要安装gitlab-runner

## docker安装gitlab，最新的版本

1. docker pull sameersbn/gitlab:latest (官方镜像)
1. 运行gitlab，443 22端口经常会冲突。这里我替换掉了，个人看情况使用
```
docker run --detach \
    --hostname ipxxx.xxx.xx \
    --publish 7043:443 --publish 7070:80 --publish 7022:22 \
    --name gitlabs \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    sameersbn:latest
```

1. 更详细参考gitlab配置[github](https://github.com/sameersbn/docker-gitlab "github")

## docker安装gitlab-runner

1. docker pull gitlab/gitlab-runner
2. 运行gitlab-runner
```
 docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```

1. 详细参考[docker-gitlab-runner](https://docs.gitlab.com/runner/install/docker.html "docker-gitlab-runner")

## 配置Gitlab Runner

1. 进入gitlab-runner容器里面
1. 要在gitlab中添加一个runner，只需要执行:gitlab-runner register  进行注册管道
```
	gitlab-runner register

	Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
	## 输入你的gitlab地址 在gitlab项目的设置中查看pipelines中的url。不是项目的url
	Please enter the gitlab-ci token for this runner
	## gitlab的token(在gitlab的Admin Area中) 或者仓库的token(仓库->设置->Runner)
	Please enter the gitlab-ci description for this runner
	## Runner描述信息
	Please enter the gitlab-ci tags for this runner (comma separated):
	## Runner的标签 可以指定仓库 只使用固定标签的Runner构建
	Whether to run untagged builds [true/false]:
	[false]:  ## 这里我选择true，意思是是否在打了tag的运行。false是在tag上运行，true提交了就可以使用该管道编译
	Whether to lock Runner to current project [true/false]:
	[false]:  ## 是否锁住管道，暂时没弄明白 false 吧
	Please enter the executor: parallels, shell, ssh, virtualbox, docker+machine, docker-ssh+machine, docker, docker-ssh, kubernetes:
	docker  ## 这里我们选择shell 先来个简单的
	Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

1. 上面的图形说明
![运行的记录](https://csdn-code.oss.aliyuncs.com/php-upload-images/20170606-1104-22563-4156/QQ%25E6%2588%25AA%25E5%259B%25BE20170606110343.jpg "运行的记录")
![url和token的配置](https://csdn-code.oss.aliyuncs.com/php-upload-images/20170606-1105-24298-0173/QQ%25E6%2588%25AA%25E5%259B%25BE20170606110427.jpg "url和token的配置")

## gitlab-runner配置好了。在要项目的根路径添加.gitlab-ci.yml 才会运行

1. 简单的运行
```
before_script:
    - echo "before_script"
# 定义 stages
stages:
  - build
  - test
# 定义 job
job1:
  stage: test
  script:
    - echo "I am job1"
    - echo "I am in test stage"
# 定义 job
job2:
  stage: build
  script:
    - echo "I am job2"
    - echo "I am in build stage"
```

2. 项目推上去就可以看到编译的结果打印输入上面的echo

## 这里我多写的只是如何使用，可以参考概念说明，2者结合能够真正掌握它的意思
## [gitlab-runner的概念说明](https://scarletsky.github.io/2016/07/29/use-gitlab-ci-for-continuous-integration/ "gitlab-runner的概念说明")