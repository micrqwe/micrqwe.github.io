title: mysql事务理解
date: 2020-10-10 11:10:08
tags: ["存储层"]
---------
# mysql知识点


## 事务的说明探讨
 
参考：[1](http://www.iloveqyc.com/2019/03/05/transaction-acid/)

## mysql知识点

1. 事务四大特征：原子性，一致性，隔离性和持久性(ACID)
```$xslt
这 4 条特性，是事务管理的基石，一定要透彻理解。此外还要明确，这四个家伙当中，谁才是最终目标？
理解：原子性是基础，隔离性是手段，持久性是目的，最终目标就是一致性。数据不一致了，就相当于数据错位了。所以说，这三个小弟都是跟着“一致性”这个老大混，为他全心全意服务。
```

2. mysql隔离级别：是为了处理事务中隔离性的工具
```$xslt
SQL标准定义的四个隔离级别为：
    READ UNCOMMITTED
    READ COMMITTED
    REPEATABLE READ
    SERIALIZABLE
```
![mysql事务对应](/imgs/20201010113403.png)