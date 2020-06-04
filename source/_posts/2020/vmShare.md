## 事实上，虚拟机上自带的VMware-tools就可以实现，但是VMware tools需要自己安装，下面介绍一下安装方法：

1. 安装VMware-tools

1. 点击VMware工具栏''VM”——“install VMware tools..."，这时桌面会出现光盘形状的VMware Tools，而且会自动跳出目录，里面包含两个文件，"manifest.txt"与"VMwareTools-8.4.5-324285.tar.gz"。(server版本的用命令进入(下文))

1. cd /media/VMware Tools               进入安装文件目录

1. cp VMwareTools-8.4.5-324285.tar.gz /tmp        将VMware Tools压缩包拷贝到临时文件夹/tmp下(当前目录是没有权限的)

1. cd /tmp                                                               进入临时文件夹

1. tar -zxvf VMwareTools-8.4.5-324285.tar.gz        解压该压缩文件

1. cd vmware-tools-distrib                                     进入该文件夹

1. ./vmware-install.pl                                             安装vmware-tools

1. 一路Enter，VMware-tools就安装成功了。

## 在vm的设置里面共享
1. 点击 VM——setting——options——shared Folders，选择Always enabled，点击下面Add添加windows中的共享文件夹，我选择的是F盘，然后保存修改。

1. 重新启动ubuntu，你就可以在目录/mnt/hgfsz下发现名为"F"的文件夹了，双击就会发现时windows下的F盘的内容，你可以在ununtu下在里面进行读写操作了。