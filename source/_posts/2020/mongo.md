# mongodb使用总结

### 【grom】非内嵌类使用many-to-one or one-to-one等问题

```groovy
   若非内嵌类，则不能使用类似belongsTo = [xx:XX] 或者 hasOne = [xx:XX] 或者 XX xx等的关联方式，需要指定使用String xxId
```
### 【grom】非内嵌类使用one-to-many等问题

```groovy
若非内嵌类，则不能使用类似List<XX> xxs的关联方式，否则虽不会报错，
但是却不能正常保存（保存的都为null）；然而可以使用hasMany = [xxs: XX]的方式
```

### 【grom】数组查询

```groovy
   假设Cart中有List<String> strIds；则可以针对数组进行各式查询：
   * 精确查询 -- （包括数组的顺序） -- 查询出strIds为["a0","a1","a2"]的数据
     def cartList = Cart.createCriteria().list {
            eq("strIds", ["a0","a1","a2"])
     }
   * 模糊查询 -- 数组包含即可 -- 查询出所有strIds中包含a8的数据
     def cartList = Cart.createCriteria().list {
            eq("strIds", "a8")
     }
   * 下标查询 -- 查询出所有strIds中下标8的值为a8的数据
     def cartList = Cart.createCriteria().list {
            eq("strIds.8", "a8")
     }
```

# mongo CRUD 

### 导出
 ```
   导出使用mongodump命令。mongodump --help查看命令的帮助。可以批量导出数据库表
   * [地址](http://docs.mongodb.org/manual/reference/program/mongodump/)
 ```

### 导入
```
  导入备份 mongorestore命令。该命令可以导入一个文件夹下所有集合。mongoimport只能导入单个json
```
* [地址](http://docs.mongodb.org/manual/reference/program/mongorestore/)

### 添加用户
 ```
   	use test
      db.createUser(
         {
           user:"user123",
           pwd:"12345678",
           roles:[ "readWrite", { role:"changeOwnPasswordCustomDataRole", db:"admin" } ]
         }
      )
```
    * [地址](http://docs.mongodb.org/manual/tutorial/change-own-password-and-custom-data/)


### 修改用户

```
use test
 db.updateUser(
    "user123",
    {
      pwd: "KNlZmiaNUp0B",
      customData: { title: "Senior Manager" }
    }
   )
```

* [地址](http://docs.mongodb.org/manual/tutorial/change-own-password-and-custom-data/)

1. db.getCollection('order').find({"logistics":{ $in: [null],$exists:true}}) // 数值为null 字段也在
2. mongo客户端 [robomongo](https://robomongo.org/ "robomongo")
3. 建立唯一索引db.getCollection('xxx').ensureIndex({id:1},{unique:true})