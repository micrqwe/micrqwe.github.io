id: 202006231110
title: Mysql8初始化新建库
date: 2021-05-10 17:30:08
tags: "存储层"
---------

# mysql8

## 安装mysql8

* 安装完成后，之前的MariaDB就会被覆盖掉
1. wget -i -c https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
1. yum -y install mysql80-community-release-el7-3.noarch.rpm
1. yum -y install mysql-community-server

## 启动mysql

1. 启动MySQL服务：systemctl start  mysqld.service
1. 查看MySQL服务：systemctl status  mysqld.service
* 查看MySQL是不是开机自启，可以执行命令查看开机自启列表
```aidl
systemctl list-unit-files|grep enabled
```

## 进入mysql

1. 此时如果要进入MySQL得找出root用户的密码，输入命令：grep "password" /var/log/mysqld.log
```aidl
2021-05-10T08:10:47.232877Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: [这里是密码]
```
1. MySql需要重新设置密码才能操作数据库。：ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
```aidl
注意：先登录进去：mysql -u root -p
设置密码的时候需要遵守MySQL密码设置规范，如果不符合规范是不能修改成功的。
如下图，我将密码设置为123456，它提示我 密码不符合规范
```

## 登录后远程连接备注

需要重新创建用户的:
```aidl
设置允许远程连接。

如果直接使用命令：GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456'; 会提示一个语法错误，有人说是mysql8的分配权限不能带密码隐士创建账号了，要先创建账号再设置权限。也有的说8.0.11之后移除了grant 添加用户的功能。

创建新用户 admin

创建用户：CREATE USER 'admin'@'%' IDENTIFIED BY '123456';

允许远程连接：GRANT ALL ON *.* TO 'admin'@'%';
```
不创建用户:
```text
mysql8下试验通过的:
use mysql

update mysql.user set host = '%'  where user = 'root';

FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;
```

## 创建数据库

* http://c.biancheng.net/view/2413.html
1.  CREATE DATABASE [数据库表] 语句创建数据库
1. SHOW CREATE DATABASE [数据库表] 查询创建的库

## 导出导出数据库

1. mysqldump -u root -pmima [数据库表] > dbname.sql
   ```text
   1. 格式:mysqldump -u 用户名 -p 数据库名 表名> 导出的文件名 
   2. 导出所有库:mysqldump -u root -proot --all-databases >/tmp/all.sql 
   3. 导出几个:mysqldump -u root -proot --databases db1 db2 >/tmp/user.sql
   4. 导出一个数据库：mysqldump -u root -proot  --skip-add-drop-table nacos_config >d:/nacos_config_db.sql
   5. 只导出结构:加上 -d 
   6. --skip-add-drop-table 导出的sql创建表之前都会drop 表.加上该参数会不加drop的sql
   ```
1. 导入数据库
   ```text
    1. 常用source 命令
    2. 进入mysql数据库控制台:mysql -u root -p
    3. mysql>use 数据库
    4. 然后使用source命令，后面参数为脚本文件(如这里用到的.sql):mysql>source d:/dbname.sql 
   ```
  