# es join
## 概念

1. es父子文档在6.x后已经变更了说明。去掉了type:parent  改为join概念
2. [es官网文档链接地址](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/parent-join.html)
3. 特别申明，join中注意**routing**字段。routing参数是强制的，就会抛出错误。
```
IndexRequest request = new IndexRequest(INDEX, TYPE,i)
                .source(map)
                .routing("2");
```
4. 在嵌套的文档中，实际情况是所有内部的对象集中在同一个分块中的Lucene文档，这对于对象便捷地连接根文档而言，是非常有好处的。父子文档则是完全不同的ES文档，所以只能分别搜索它们，效率更低。对于文档的索引、更新和删除而言，父子的方式就显得出类拔萃了。这是因为父辈和子辈文档都是独立的ES文档，各自管理。举例来说，如果一个分组有很多活动，要增加一个新活动，那么就是增加一篇新的活动文档。如果使用嵌套类型的方式，ES不得不重新索引分组文档，来囊括新的活动和全部已有活动，这个过程就会更慢。