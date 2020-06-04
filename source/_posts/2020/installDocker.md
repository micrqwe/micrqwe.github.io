# centos安装docker

## centos内核低于3.8处理，通过yum安装

* 第一步，先看目前的内核版本 uname -r
* 第二步，导入public key:  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
* 第三步，安装ELRepo: rpm -Uvh http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm  
* 第四步，安装内核
```
在yum的ELRepo源中，有mainline（4.6）、long-term（3.10）这2个内核版本，考虑到long-term更稳定，会长期更新，所以选择这个版本。
查看ELRepo源中内核：http://elrepo.org/linux/kernel/el6/x86_64/RPMS/
安装命令：  yum --enablerepo=elrepo-kernel install kernel-lt -y
```

* 第五步，编辑grub.conf，修改Grub引导顺序
```
vim /etc/grub.conf  确认刚安装好的内核在哪个位置，然后设置default值（从0开始），一般新安装的内核在第一个位置，所以设置default=0。
```

* 第六步，重启，查看内核版本号

参考资料：
http://elrepo.org/tiki/tiki-index.php