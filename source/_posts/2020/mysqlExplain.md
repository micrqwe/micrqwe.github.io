---
title: mysql-extra字段说明
date: 2020-06-05 16:36:31
tags: ["mysql"]
---

# extra字段说明

## 执行explain中字段extra的含义。执行效率从上到下依次递减
using index ：使用覆盖索引的时候就会出现

using where：在查找使用索引的情况下，需要回表去查询所需的数据

using index condition：查找使用了索引，但是需要回表查询数据

using index & using where：查找使用了索引，但是需要的数据都在索引列中能找到，所以不需要回表查询数据
using filesort 是通过相应的排序算法,将取得的数据在内存中进行排序:。

MySQL需要将数据在内存中进行排序，所使用的内存区域也就是我们通过sort_buffer_size 系统变量所设置的排序区。
这个排序区是每个Thread 独享的，所以说可能在同一时刻在MySQL 中可能存在多个 sort buffer 内存区域。
在MySQL中filesort 的实现算法实际上是有两种：
双路排序：是首先根据相应的条件取出相应的排序字段和可以直接定位行数据的行指针信息，然后在sort buffer 中进行排序。
单路排序：是一次性取出满足条件行的所有字段，然后在sort buffer中进行排序。
