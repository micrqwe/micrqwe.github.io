# 自己新建https证书，以及使用其他人的https
1. 自己新建证书：输入如下命令：keytool -genkey -alias ssodemo -keyalg RSA -keysize 1024 -keypass zhoubang -validity 365 -keystore E:\zhoubang.keystore -storepass 123456中间的内容参数自己替换
```
各参数含义：
-genkeypair 生成密钥
-keyalg 指定密钥算法，这时指定RSA,
-keysize 指定密钥长度，默认是1024位,这里指定2048，长一点，我让你破解不了（哈哈...）,
-siglag 指定数字签名算法，这里指定为SHA1withRSA算法
-validity 指定证书有效期，这里指定36500天，也就是100年，我想我的应用用不到那么长时间
-alias 指定别名，这里是ssodemo 
-keystore 指定密钥库存储位置，这里存在d盘
-dname 指定用户信息，不用一个一个回答它的问题了；
【注意】：第一个让你输入的“您的名字与姓氏是什么”，请必须输入在C:\Windows\System32\drivers\etc\hosts文件中加入的服务端的域名。
我这里也就是server.zhoubang85.com，为何这么做？
首先cas只能通过域名来访问，不能通过ip访问，同时上方是生成证书，所以要求比较严格，所以如果不这么做的话，及时最终按照教程配置完成，cas也可以正常访问,访问一个客户端应用虽然能进入cas验证首页，但是，当输入信息正确后，cas在回调转入你想访问的客户端应用的时候，会出现No subject alternative names present错误异常信息，这个错误也就是在上面输入的第一个问题答案不是域名导致、或者与hosts文件配置的不一致导致。
```

1. 导出数字证书:在cmd下输入如下命令：keytool -exportcert -alias cas.server.com -keystore d:/tomcat.keystore  -file d:/tomcat.cer -rfc
```
导出数字证书，即根据刚才生成的tomcat.keystore文件生成一个tomcat.cer文件，在生成的过程中输入的密码也是123456
```

1. 配置tomcat的https证书
```
配置cas服务器tomcat
将tomcat中server.xml中的连接器配置改为：
<Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol"
               maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS"  keystoreFile="tomcat.keystore"
               keystorePass="123456"/>
            同时将生成的tomcat.keystore复制到tomcat的主目录下，即与conf目录在同一个目录下;
启动tomcat，然后访问https://cas.server.com:8443/cas 可以访问的只是有警告，因为浏览器没有进行证书认证。
我们可以将生成的tomcat.cer导入到浏览器中，不导入也可以；如果要导入的，各个浏览器不导也步骤大体相似，以IE浏览器为例：
点击 工具->Internet选项->内容->证书->受信任的根证书颁发机构->导入->下一步->浏览->选择d:/tomcat.cer->下一步,一路确认下去，直到证书导入成功。
如果导入在受信任的根证书颁发机构 中可以找到名字为cas.server.com的证书. 
至此cas服务器商配置完毕.
```

1. 证书导入java中的cacerts证书库：keytool -import -alias cacerts -keystore {java路径\jre\lib\security\cacerts} -file {证书路径.cer} -trustcacerts 
```
此时命令行会提示你输入cacerts证书库的密码，
　　　　你敲入changeit就行了，这是java中cacerts证书库的默认密码，
　　　　你自已也可以修改的。 
```

1. 以后更新时，先删除原来的证书，然后导入新的证书
              keytool -list -keystore cacerts
              keytool -delete -alias akazam_email -keystore cacerts
              keytool -import -alias akazam_email -file akazam_email.cer -keystore cacerts -trustcacerts

1. 使用网站上的证书时候
```
进入某个https://www.xxx.com开头的网站,把要导入的证书下载过来，
　　　　在该网页上右键 >> 属性 >> 点击"证书" >>
　　　　再点击上面的"详细信息"切换栏 >>
　　　　再点击右下角那个"复制到文件"的按钮
　　　　就会弹出一个证书导出的向导对话框，按提示一步一步完成就行了。
　　　　例如：保存为abc.cer,放在C盘下 
```