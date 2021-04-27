id: 202006231110
title: Mysql事务开启
date: 2021-04-27 19:12:08
tags: "存储层"
---------

//查看当前事物级别：
SELECT @@tx_isolation;

//设置read uncommitted级别： 未提交读
set session transaction isolation level read uncommitted;

//设置read committed级别：  已提交读
set session transaction isolation level read committed;

//设置repeatable read级别：  可重复读
set session transaction isolation level repeatable read;

//设置serializable级别：  可串行化
set session transaction isolation level serializable;

1. 手动开启事务:
begin;
select xxx 
commit;