## ssh转发使用代理
```
http://bianbian.org/technology/264.html

里有一些好用的网址，介绍ssh及其代理穿透防火墙的



http://www.inet.no/dante/

Dante -- Proxy communication solution



ssh 是有端口转发功能的。（转）
http://doc.linuxpk.com/80817.html

ssh的三个强大的端口转发命令：

QUOTE:
ssh -C -f -N -g -L listen_port:DST_Host:DST_port user@Tunnel_Host
ssh -C -f -N -g -R listen_port:DST_Host:DST_port user@Tunnel_Host
ssh -C -f -N -g -D listen_port user@Tunnel_Host
-f Fork into background after authentication.
后台认证用户/密码，通常和-N连用，不用登录到远程主机。

-p port Connect to this port. Server must be on the same port.
被登录的ssd服务器的sshd服务端口。

-L port:host:hostport
将本地机(客户机)的某个端口转发到远端指定机器的指定端口. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 同时远程主机和 host 的 hostport 端口建立连接. 可以在配置文件中指定端口的转发. 只有 root 才能转发特权端口. IPv6 地址用另一种格式说明: port/host/hostport

-R port:host:hostport
将远程主机(服务器)的某个端口转发到本地端指定机器的指定端口. 工作原理是这样的, 远程主机上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转向出去, 同时本地主机和 host 的 hostport 端口建立连接. 可以在配置文件中指定端口的转发. 只有用 root 登录远程主机才能转发特权端口. IPv6 地址用另一种格式说明: port/host/hostport

-D port
指定一个本地机器 “动态的'’ 应用程序端口转发. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 根据应用程序的协议可以判断出远程主机将和哪里连接. 目前支持 SOCKS4 协议, 将充当 SOCKS4 服务器. 只有 root 才能转发特权端口. 可以在配置文件中指定动态端口的转发.

-C Enable compression.
压缩数据传输。

-N Do not execute a shell or command.
不执行脚本或命令，通常与-f连用。

-g Allow remote hosts to connect to forwarded ports.
在-L/-R/-D参数中，允许远程主机连接到建立的转发的端口，如果不加这个参数，只允许本地主机建立连接



Linux命令行下SSH端口转发设定笔记(转)

原文:http://be-evil.org/post-167.html

在Windows下面我们可以很方便的使用putty等ssh工具来实现将服务器上的端口映射到本机端口来安全管理服务器上的软件或者服务 那么我们换到在Liunx下我们应该怎么做呢？

ssh -L 本地端口:服务器地址:服务器端口 用户名@服务器地址 -N

参数详解:

-L 端口映射参数 本地端口 - 这个任意即可，只要本机没有其他的程序占用这个端口就行

服务器地址 - 你需要映射的服务器地址（名称/ip）

服务器端口 - 远程的服务器端口

-N - 不使用Shell窗口，纯做转发的时候用，如果你在映射完成后继续在服务器上输入命令，去掉这个参数即可

例子A:我们想远程管理服务器上的MySQL,那么使用下面命令

ssh -L 3306:127.0.0.1:3306 user@emlog-vps -N
运行这个命令之后，ssh将会自动将服务器的3306映射到本机的3306端口，我们就可以使用任意MySQL客户端连接 localhost:3306即可访问到服务器上的MySQL了。

例子B:一次同时映射多个端口

ssh -L 8888:www.host.com:80-L 110:mail.host.com:110 \ 25:mail.host.com:25 user@host -N
这个命令将自动把服务器的80，110，25端口映射到本机的8888，110和25端口 以上命令在ubuntu 9.10 上测试通过...

```

## ssh对方机子非22端口
```
 windows路径:   C:\Users\Administrator\.ssh

linux路径:   /home/administrator/.ssh

如果该路径下没有config文件，则创建一个。

config中添加如下内容：

如是以域名访问的则添加如下内容：（注意修改xxx为你的远程仓库的名称）

Host xxx
HostName xxx.com
Port 3333


如是以ip访问的，则添加如下内容:（注意修改ip为你的远程仓库ip）

Host "211.111.xx.xxx"
Port 3333


注意如果 git 是 ssh 方式免密认证方式登录的话，且你的私钥文件名字不是 id_rsa 

则还需要在 config 文件中填加：

IdentityFile ~/.ssh/<你的密钥名>

config中还可以指定User，如

User "git"
```