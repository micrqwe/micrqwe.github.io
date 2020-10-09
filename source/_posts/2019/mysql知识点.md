title: mysql知识点
date: 2020-06-23 11:10:08
tags: ["mysql","数据结构与算法"]
---------
# mysql知识点

## 先放出友情链接
  * [B树 b+ lsm](https://blog.csdn.net/u010853261/article/details/78217823)
  * [mysql索引讲解](http://note.youdao.com/noteshare?id=77a6a7f18aae33a73d97b37e07ebdd49)
  * [mysql全文索引处理](http://note.youdao.com/noteshare?id=0578f4dbc84225ae0cb98922cee1afc1)
  * [mysql页分裂](https://zhuanlan.zhihu.com/p/98818611)
  * [B+树可以存储多少行数据](https://www.jianshu.com/p/0aba6d552a55)
  * [mysql全篇总结](  https://juejin.im/post/6850037271233331208#heading-15)

## 事务的说明探讨
 
参考：[1](http://www.iloveqyc.com/2019/03/05/transaction-acid/)

## mysql知识点

1. mysql事务实现:MVCC概念
1. 组合索引：innodb 索引会带上当前的索引，同时加上主键Id,order 也会用索引
1. mysql order by 工作过程:[文章1](https://www.cnblogs.com/sjks/p/10894742.html) | [文章2](https://juejin.im/post/5ea9972f6fb9a04382227db5)
  ```
  上诉排序问题：sql为:select city,name,age from t where city in ('杭州','苏州') order by name limit 1000;这时候怎么办？
  1： 组合索引的排序规则是city_name 这时候city=杭州 但是name排序不对。
  2： 业务上分别拆分成2条:select city,name,age from t where city='杭州' order by name limit 1000;
  and select city,name,age from t where city='苏州' order by name limit 1000; 然后再业务代码中进行name排序取出前1000.
  也是一种方法
  ```

1. mysql explan 中type含义: [文章](https://juejin.im/post/5eb3a976e51d454d9b12538b)
1. B树 B+数区别 :[文章](https://www.jianshu.com/p/92d15df75027)
```
B树和B+树的区别

这都是由于B+树和B具有这不同的存储结构所造成的区别，以一个m阶树为例。
    1. 关键字的数量不同；B+树中分支结点有m个关键字，其叶子结点也有m个，其关键字只是起到了一个索引的作用，但是B树虽然也有m个子结点，但是其只拥有m-1个关键字。
    2. 存储的位置不同；B+树中的数据都存储在叶子结点上，也就是其所有叶子结点的数据组合起来就是完整的数据，但是B树的数据存储在每一个结点中，并不仅仅存储在叶子结点上。
    3. 分支结点的构造不同；B+树的分支结点仅仅存储着关键字信息和儿子的指针（这里的指针指的是磁盘块的偏移量），也就是说内部结点仅仅包含着索引信息。
    4. 查询不同；B树在找到具体的数值以后，则结束，而B+树则需要通过索引找到叶子结点中的数据才结束，也就是说B+树的搜索过程中走了一条从根结点到叶子结点的路径。

```
