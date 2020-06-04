# 自定义classloder

## 自定义之前需要熟悉的双亲委派机制

1. 双亲委派是为了保证jvm同时只存在一个Object对象。都由父类加载。父类无法找到才由子类进行查找
1. 但在web容器中：如tomcat 不能使用这种。每个war包由自己的jar包。这时候就要进行容器隔离。
1. 所有classloader都有父类加载器。但不是父类。由方法parent指定。
1. 顶级的Boostrap ClassLoader：这个是由c++实现的，所以在方法区并没有Class对象的实例存在。用于加载JAVA_HOME/bin目录下的jar包
1. 扩展类加载器（Extension ClassLoader）：它负责用于加载JAVA_HOME/lib/ext目录中的，或者被java.ext.dirs系统变量指定所指定的路径中所有类库，开发者可以直接使用扩展类加载器。java.ext.dirs系统变量所指定的路径的可以通过程序来查看。System.getProperty("java.ext.dirs")
1. 应用程序类加载器（Application ClassLoader）：负责加载用户类路径上指定的类库。开发者可以直接使用这个类加载器。ps：在没有指定自定义类加载器的情况下，这就是程序的默认加载器。
1. 自定义类加载器（User ClassLoader）：

```
loadClass()和findClass()方法区别:
  自定义时候覆盖loadClass()方法可以保证同一个类存在多份。自行实现类加载
  findClass()方法还是先由先由父类进行加载，查看是否加载多。没有加载在交由子类。 
场景一：tomcat容器隔离。这时候需要覆盖loadClass()。同一个war包会有同样一个jar包，可以版本不同，能够同时存在.findClass()则无法处理。再一次加载后查看缓存已经存在直接进行加载。
场景二:tomcat中servlet-api.jar以及公共jar包。这个需要在jvm中只有一份。就需要只覆盖findClass()。
 tomcat有不同的clasloader加载不同的场景
```

## 自定义classloader
1. [代码链接](https://code.aliyun.com/287507016/mywork/tree/master/java/src/main/java/com/test/classloader)