id: 202006231110
title: linux限制目录大小
date: 2021-09-07 13:12:08
tags: "笔记"
---------

# 概念解读
 1. linux没有磁盘分区,新建镜像处理

## 方法如下
1. dd if=/dev/zero of=/root/disk1.img bs=1M count=10      //          1M*10=10M    zero 是dev下的文件，创建镜像
   ```text
    这里进行创建镜像,需要大小根据自己的需求制定,bs是区块,一个区块大小.count是10个块.
    ```
1. losetup /dev/loop1 /root/disk1.img                                //           挂载硬盘为/dev/loop1
   ```text
    这里要自己查找一下可用的回环设备./dev/loop为linux的回环设备,losetup /dev/loop0~x.一个个试一下为空的就可以用.也可以直接fdisk -l查看哪个没有
    ```
1. mkfs.ext3 /dev/loop1                                                    //              格式化文件系统
   ```text
       格式化系统
    ```
1. mkdir /test1                                                                  //                创建文件
1. mount  /dev/loop1 /test1                                   //                挂载硬盘，/test1目录的容量为20M
    ```text
    挂载设备
    ```

## 卸载方法如下

1. umount test1
   ```text
    卸载设备
    ```
2. losetup -d /dev/loop1
    ```text
    删除挂载镜像
    ```
