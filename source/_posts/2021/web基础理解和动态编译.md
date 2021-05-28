id: 202006231110
title: web基础学习和动态编译
date: 2021-05-28 18:40:08
tags: "java开发"
categories: spring
---------

# springmvc中进行测试用例

## 过程记录

* 项目使用了gradle,为springmvc的结构.当前进行调试测试用例,
    1. gradle使用tomcat运行,类打包了到了build的目录,同时idea设置的自动编译目录为out目录.这里就出现一个问题,热部署时候类不在一起,不过发现类会在2个目录存在,估计为同时会产生编译
        ```aidl
           maven项目的为target目录.同时idea也会设置成这个.猜想maven自行设置的
        ```
    1. springmvc项目进行test用例时候运行,找不到WEB-INF下的资源.这就回到编译目录来看,运行的测试环境使用的是选择的是idea,不是gradle.所以WEB-INF不在范围内.
       ```
        gradle中有单独参数设置webapp目录project.webAppDirName
       ```
    1. springboot的maven项目如何结合servlet.
        ```text
            1. Application中添加@ServletComponentScan
            2. 定义一个类贴上注解:@WebServlet(name = "MyServlet",urlPatterns = "/myServlet").这时候可以使用普通的servlet
            3. 普通servlet堆栈信息很简单,这时候如果要用filter需要使用原生的注解,可以百度,这里不在赘述
        ```
    
* 动态编译
    1. idea有自带动态编译的功能,在tomcat或者springboot类的on aciont中选择:update class and resources
        ```
           1. 这里需要注意你的如果是gradle项目,注意你选择对你的项目编译采用的gradle还是idea.
           2. gradle默认的编译目录不一致,有可能会导致热部署失效,注意检查一下.
        ```
    1. 使用三方工具arthas.优秀的一款工具,具体使用可以参照说明文档.