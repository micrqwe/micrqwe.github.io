# 代码添加注释
1. 文档参考处[groovy doc文档](http://doc.kingsilk.xyz/dist/groovy/2.4.3/documentation/#_groovydoc_comment)
2. 以下自己见解
```
/**
 * 在此处添加对整个类的大致说明
 * 添加@符后面会直接添加到文档的说明处 
 * @version 1.0
 */
class Person {
    /** 在这里添加对属性的注释 */
    String name

    /**
     * 对方法的说明，此行开始到@param处一直是方法的说明
     * 
     * @param otherPerson ;对参数名的解释，请加(;)符号分割，
     * @return  简单的renturn介绍，到后面都是return的介绍
     * @return 这里也算return的介绍，但是会换行。也可以不加，建议加
     * @throws 方法抛出的异常
     */
    String greet(String otherPerson) {
       // 在方法体内注册 使用 //；使用/** xxx */会是注释和下一个方法无法绑定，
      "Hello ${otherPerson}"
    }
}
```

1. disruptor