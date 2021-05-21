id: 202006231110
title: springmvc启动初始化过程
date: 2021-05-21 09:40:08
tags: "java开发"
categories: spring
---------

# springmvc

## web.xml 配置解释

1. 放在全局中,格式如下
    ```aidl
       <!--全局提前初始化的使用 -->
        <context-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:spring-mvc.xml</param-value>
        </context-param>
    ```
1. 同spring的dispatchServlet放在一起
    ```aidl
        <!--configure the setting of springmvcDispatcherServlet and configure the mapping -->
        <!--        如果把下面注释掉，会默认使用servlet-name的值拼上serlvet。找WEB-INF下的类。-->
        <servlet>
            <servlet-name>spring-mvc</servlet-name>
            <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
                <init-param>
                   <param-name>contextConfigLocation</param-name>
                   <param-value>classpath:spring-mvc.xml</param-value>
               </init-param>
            <load-on-startup>1</load-on-startup>
        </servlet>
    ```
* spring-mvc下的servlet中init-param可以省略掉。如果省略掉会默认使用：servlet-name的value值拼上servlet.xml。如上文则是:(spring-mvc-servlet.xml).查找路径需在WEB-INF下。和web.xml一致
    ```aidl
        类名：XmlWebApplicationContext
        加载文件方法：
        protected void loadBeanDefinitions(XmlBeanDefinitionReader reader) throws IOException {
            String[] configLocations = getConfigLocations();
            if (configLocations != null) {
                for (String configLocation : configLocations) {
                    reader.loadBeanDefinitions(configLocation);
                }
            }
        }
    ```
## 说明

* 问题一：放context-param和init-param区别?
    1. Context-param（上下文参数），在这个元素中可以定义多个<param-name><param-value>组成的键值对，但是要注意这里定义的键值对作用于是application，而且在有些应用中会提前定义自己的键值对，所以可以通过这种方式配置某些技术，同时这里也可以自定义一些参数，然后在业务逻辑中使用。获取键值对的方式如下
        ```aidl
        ServletContextEvent .getServletContext().getInitParameter("urlrewrite");
        ```
    1. <init-param>的作用范围则是当前对应的Servlet，只有对应的Servlet才能够调用到，有些提前定义的Servlet中也会判断是否有某些配置的键值对，如果有则根据配置的键值对处理逻辑，没有则根据默认的逻辑处理，同时也可以自定义键值对在后期自定义的Servlet当中使用。获取键值对的方式如下
         ```aidl
           this.getInitParameter("param1")
        ```
    备注： 注意以上两者获取键值对的方式的区别，第一个必须获取ServletContext之后才能够获取，因为第一个的键值对属于整个应用，而第二个则是通过this获取，因为这里获取的键值对仅仅属于当前的Servlet。
  hexo new page categories1. 启动一个WEB项目的时候,容器(如:Tomcat)会去读它的配置文件web.xml.读两个节点:<listener></listener>和 <context-param></context-param>
1. 紧接着,容器创建一个ServletContext(上下文),这个WEB项目所有部分都将共享这个上下文.
1. 容器将<context-param></context-param>转化为键值对,并交给ServletContext.
1. 容器创建<listener></listener>中的类实例,即创建监听.
1. 在监听中会有contextInitialized(ServletContextEvent args)初始化方法,在这个方法中获得ServletContext =ServletContextEvent.getServletContext();
context-param的值 =ServletContext.getInitParameter("context-param的键");
1. 得到这个context-param的值之后,你就可以做一些操作了.注意,这个时候你的WEB项目还没有完全启动完成.这个动作会比所有的Servlet都要早.
换句话说,这个时候,你对<context-param>中的键值做的操作,将在你的WEB项目完全启动之前被执行.
1. 举例.你可能想在项目启动之前就打开数据库.那么这里就可以在<context-param>中设置数据库的连接方式,在监听类中初始化数据库的连接.
1. 这个监听是自己写的一个类,除了初始化方法,它还有销毁方法.用于关闭应用前释放资源.比如说数据库连接的关闭.
    ```aidl
    如:
    <!-- 加载spring的配置文件 -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
       <param-value>/WEB-INF/applicationContext.xml,/WEB-INF/action-servlet.xml,/WEB-
    
    INF/jason-servlet.xml</param-value>
    </context-param>
    <listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
    ```



