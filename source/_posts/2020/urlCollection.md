# 转载比较好的篇幅
* 问题点:
  * 1. 2台计算机发送超大文件的实现
  * 2. 路由和转发的区别
  * 3. 自定义通信协议注意点有哪些

* 计算机网络基础知识
  * [tcp/ip协议群简介](https://juejin.im/post/5a069b6d51882509e5432656)
    ```
      对我们开发一个高可用的网络是一个基础
    ```

  * [java内存介绍篇](https://juejin.im/post/5b4aed466fb9a04fcb5b5377)
    ```
        文章补充:虽然后面说明了android的。但同属一个概念。
    ```
  * tcp发送和接收数据的原理概念(多篇文章组合观看): [1](https://blog.csdn.net/a879365197/article/details/72802364) [2](https://cloud.tencent.com/developer/article/1459844) [3](https://blog.csdn.net/luozenghui529480823/article/details/13000955)
```
   文章补充说明：
   带着问题点去看：当2台计算机发送一个超大文件，那么发送中的数据存储在哪里,发送方存储在路由器中还是内存中，接收端收到部分数据是在内存
中还是硬盘中？接收至一半的数据突然中断,何时会被删除?计算机写入一个可以非常快，发送端是一次发送还是如何发送?发送慢是发送端网络慢，还是
路由慢 还是接收端慢
   重点词:1.窗口 2.收到确认
   重点信息:tcp发送信息有一个窗口维持。同时发送的数据需要确认后才会发送下一个序号数据。
   部分理解回答： 发送和接收端都有一个缓冲区。发送端每次发送发送的数据需要接收端回复确认才继续发送下一个序号数据
```
  * 自定义通信协议基础: [1](https://blog.csdn.net/YEYUANGEN/article/details/6782646) [2](https://blog.csdn.net/xuexiaodong009/article/details/10323135)  

1. [elasticsearch中文记录](http://cwiki.apachecn.org/pages/viewpage.action?pageId=10030674)
2. [华为云学院](https://ilearningx.huawei.com/dashboard)
