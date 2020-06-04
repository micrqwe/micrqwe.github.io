# Git常用命令

## 分支合并和rebase

```
git merge <branch> # 将branch分支合并到当前分支

git merge origin/master --no-ff # 不要Fast-Foward合并，这样可以生成merge提交

git rebase master <branch> # 将master rebase到branch，相当于： git co <branch> && git rebase master && git co master && git merge <branch>

git cherry-pick <commit id> # 合并单个commit到当前的分支当中
```

##  Git补丁管理(方便在多台机器上开发同步时用)
 
```
git diff > ../sync.patch # 生成补丁

git apply ../sync.patch # 打补丁

git apply --check ../sync.patch #测试补丁能否成功
```

##  Git暂存管理
 
```
git stash # 暂存

git stash list # 列所有stash

git stash apply # 恢复暂存的内容

git stash drop # 删除暂存区
```

## Git远程分支管理

```
git pull # 抓取远程仓库所有分支更新并合并到本地

git pull --no-ff # 抓取远程仓库所有分支更新并合并到本地，不要快进合并

git fetch origin # 抓取远程仓库更新

git merge origin/master # 将远程主分支合并到本地当前分支

git co --track origin/branch # 跟踪某个远程分支创建相应的本地分支

git co -b <local_branch> origin/<remote_branch> # 基于远程分支创建本地分支，功能同上

git push # push所有分支

git push origin master # 将本地主分支推到远程主分支

git push -u origin master # 将本地主分支推到远程(如无远程主分支则创建，用于初始化远程仓库)

git push origin <local_branch> # 创建远程分支， origin是远程仓库名

git push origin <local_branch>:<remote_branch> # 创建远程分支

git push origin :<remote_branch> #先删除本地分支(git br -d <branch>)，然后再push删除远程分支
```

##  Git远程仓库管理

```
GitHub

git remote -v # 查看远程服务器地址和仓库名称

git remote show origin # 查看远程服务器仓库状态

git remote add origin git@ github:robbin/robbin_site.git # 添加远程仓库地址

git remote set-url origin git@ github.com:robbin/robbin_site.git # 设置远程仓库地址(用于修改远程仓库地址) git remote rm <repository> # 删除远程仓库
```

## 创建远程仓库

```
git clone --bare robbin_site robbin_site.git # 用带版本的项目创建纯版本仓库

scp -r my_project.git git@ git.csdn.net:~ # 将纯仓库上传到服务器上

mkdir robbin_site.git && cd robbin_site.git && git --bare init # 在服务器创建纯仓库

git remote add origin git@ github.com:robbin/robbin_site.git # 设置远程仓库地址

git push -u origin master # 客户端首次提交

git push -u origin develop # 首次将本地develop分支提交到远程develop分支，并且track

git remote set-head origin master # 设置远程仓库的HEAD指向master分支

也可以命令设置跟踪远程库和本地库

git branch --set-upstream master origin/master

git branch --set-upstream develop origin/develop
```

## windows中git工具sourceTree的使用
1. 在电脑中先要安装git windows版本 [点此下载](https://git-scm.com/download/ "下载")
2. sourceTree可以百度去其他下载站下载，官网有被强同时安装的时候要输入google账户，下载站的关闭后在打开后就不需要了
3. 安装完后要在windows中生成ssh key。鼠标右键桌面点击git base here，弹出命令框
4. 命令框中键入命令：ssh-keygen -t rsa -C "email@email.com"，在你的用户目录就会生成 .ssh文件夹
5. 打开id_rsa.pub文件，在你需要上传的git上添加ssh key
6. sourceTree打开->工具->选项->ssh客户端配置，选择ssh链接。sourceTree的ssh配置完成。接下来可以克隆新建仓库了

## git远程分支的操作
```
git branch <branch>  //创建新的分支
git checkout <branch> //就可以进入新的分支
git push origin <branch> // 将新的分支推上远程
git push origin :<branch> // 删除远程分支
git branch -d <branch>  // 删除本地分支
 ** git pull 提示拉哪个分支代码
 ** git pull origin <branch>  // 可以使用这个命令，也可以使用下一行代码直接固定 
 **git branch --set-upstream-to=origin/<branch>
删除未提交的文件
# 删除 untracked files
git clean -f
# 连 untracked 的目录也一起删掉
git clean -fd
# 连 gitignore 的untrack 文件/目录也一起删掉 （慎用，一般这个是用来删掉编译出来的 .o之类的文件用的）
git clean -xfd
# 在用上述 git clean 前，墙裂建议加上 -n 参数来先看看会删掉哪些文件，防止重要文件被误删
git clean -nxfd
git clean -nf
git clean -nfd
```

## git中文路径名或者文件名被转义
```
git config --global core.quotepath false  // 将转义设为关闭
```

## git添加tag标签
```
git tag -a v2.0.0 -m "商城更改重大版本"
git push origin --tag  // 将本地的tag标签进行全部推送
```

## git添加的分支要对应远程
```
git branch --set-upstream-to=origin/2.0.x 2.0.x
```

## gitk出现错误
```
Error in startup script: unknown color name "lime"
    (processing "-fore" option)
    invoked from within
"$ctext tag conf m2 -fore [lindex $mergecolors 2]"
    (procedure "makewindow" line 347)
    invoked from within
"makewindow"
    (file "/usr/local/bin/gitk" line 12434)
方法1:brew cask install tcl  (未测试)
方法2:cp /usr/local/bin/gitk /usr/local/bin/gitk.bkp
          vi /usr/local/bin/gitk
		  :%s/lime/"#99FF00"/g
```