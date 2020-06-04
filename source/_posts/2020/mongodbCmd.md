# mongodb常用操作

1. 添加用户名
```
db.createUser( {
    user: "test",
    pwd: "test",
    roles: [ { role: "dbOwner", db: "test" } ]
});
```

2. 删除数据库
```
db.dropDatabase()
这将删除选定的数据库。如果还没有选择任何数据库，然后它会删除默认的 ' test' 数据库
```

3. 删除用户
```
db.system.users.remove({user:"java1"});
```

4. 克隆数据库
```
db.copyDatabase(fromdb, todb, fromhost, username, password)  // username是fromdb的数据库名
```

5. 更新数据
```
	1).update()命令

	db.collection.update( criteria, objNew, upsert, multi )
	db.collection.update( {id:"11"}, {$set:{id:"22"}}, {multi:true} ) // 将所有id=11的更新成id=22
	criteria : update的查询条件，类似sql update查询内where后面的
	objNew   : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
	upsert   : 这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
	multi    : mongodb默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。

	db.test0.update( { "count" : { $gt : 1 } } , { $set : { "test2" : "OK"} } ); 只更新了第一条记录
	db.test0.update( { "count" : { $gt : 3 } } , { $set : { "test2" : "OK"} },false,true ); 全更新了
```

6. 管道概念，[参考官方网址](https://docs.mongodb.com/manual/aggregation/ "参考官方网址")
```
查询一个条件后进行一个条件
db.oldUser.aggregate({$project:{address:1,gender: 1}},{$skip:1},{$limit:1});
上面语句意思是，返回数据只包含address和gender字段，略过第一条数据，只返回一条数据。如果limit和skip反过来，则是返回一条数据，同时略过，则返回为空。管道按照顺序来
db.oldUser.aggregate({$match:{ $or:[ {origin:"淘宝",$or:[{address:"上海"},{_id:"111"},{address:"杭州"}]},{origin:"淘宝",_id:"111"}]  } });
// 查询字段 (来自淘宝同时地址要是上海或者id是xxx或者是杭州)或者(来自淘宝同时id是xxx) 
db.oldUser.aggregate({$match:{ $or:[{origin:"淘宝"]}}，{$match:{ $or:[{address:"天猫"]}});
// and查询，既要是来自淘宝，同时地址还是天猫的
```

7. 查询字段为空

```
db.getCollection('maodoudou').find({scroe:{$in:[null], $exists: true}}) // 查询该字段存在，值为null
db.getCollection('maodoudou').find({scroe:{$in:[null], $exists: false}}) // 查询该字段值为null，不管字段是否存不存在，没有字段也视为null
db.getCollection('adc').find({$or:[{_id:"110000"},{_id:"110101"}]}) // mongodb or查询
db.getCollection('adc').find({$and:[{_id:"110000"},{name:"北京市"}]}) // and查询

db.hotelBillsOrder.aggregate({$unwind: "$orderItems"},{$group:{_id:null,count:{$sum:"$orderItems.day"}}})
```