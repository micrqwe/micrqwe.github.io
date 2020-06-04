# jenkins安装

1. docker pull xxx

## jenkins配置gitlibhooks

1. Jenkins插件安装
```
		Jenkins其实没有什么需要特别配置的，由于这次任务中需要利用Jenkins与git，gitlab协作，所以需要安装一些插件。在主面板上点击Manage Jenkins -> Manage Plugins。

		由于公司使用代理连接外网，首先需要为Jenkins插件安装配置proxy。点击Advanced标签即进入proxy设置页面。

		Aailable标签下就是可以安装的插件。

		要让Jenkins可以自动build git repo中的代码，需要安装GIT Client Plugin和GIT Plugin。

		要想Jenkins可以收到Gitlab发来的hook从而自动build，需要安装 Gitlab Hook Plugin。

		要让Jenkins可以在build完成之后根据TAP（test anything protocol）文件生成graph，需要安装 TAP Plugin。
```

2. 安装gitlib-hooks[地址](https://wiki.jenkins-ci.org/display/JENKINS/Gitlab+Hook+Plugin)
3. 安装gitlib-hooks报错

     jenkins在安装Git hook plugins提示失败:

    OS : CentOS 6.5 64位
    Jenkins : 1.638
     JDK : 1.8.0_66
    Ruby-runtime : 0.13
    问题 : gitlab hook plugin无法安装的原因是因为ruby-runtime无法安装.

		```
		java.io.IOException: Failed to dynamically deploy this plugin
		at hudson.model.UpdateCenter$InstallationJob._run(UpdateCenter.java:1308)
		at hudson.model.UpdateCenter$DownloadJob.run(UpdateCenter.java:1107)
		at java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
		at java.util.concurrent.FutureTask.run(Unknown Source)
		at hudson.remoting.AtmostOneThreadExecutor$Worker.run(AtmostOneThreadExecutor.java:104)
		at java.lang.Thead.run(Unknown Source)
		```

4. 解决办法:

    看上去是在下载过程中文件出现了问题. 首先关闭Jenkins.找到jenkins主目录下面的插件目录,我的目录在/home/web/.jenkins/plugins, 删除相关文件gitlab-hook.jpi和ruby-runtime.jpi

    重启jenkins, 试着重新安装.还是无法安装成功,报错信息,应该是下载文件的网络问题:手动下载相关的文件,现在[地址](https://updates.jenkins-ci.org/download/plugins "地址")在这里, 找到相关的插件,然后选择版本.下载到本地

    进入jenkins的系统设置->插件管理->高级->上传插件,把下载到本地文件的插件上传到jenkins的服务器进行安装.

5. ruby文件比较大，直接上传可能会抛错，可以直接下载，放到${host}/jenkins/plugins中，然后重启

6. 还是报错:

		```
		java.io.IOException: Failed to dynamically deploy this plugin
		at hudson.model.UpdateCenter$InstallationJob._run(UpdateCenter.java:1328)
		at hudson.model.UpdateCenter$DownloadJob.run(UpdateCenter.java:1126)
		at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
		at java.util.concurrent.FutureTask.run(FutureTask.java:266)
		at hudson.remoting.AtmostOneThreadExecutor$Worker.run(AtmostOneThreadExecutor.java:110)
		at java.lang.Thread.run(Thread.java:745)
		Caused by: java.io.IOException: Failed to install ruby-runtime plugin
		at hudson.PluginManager.dynamicLoad(PluginManager.java:487)
		at hudson.model.UpdateCenter$InstallationJob._run(UpdateCenter.java:1324)
		... 5 more
		Caused by: java.io.IOException: Failed to initialize
		at hudson.ClassicPluginStrategy.load(ClassicPluginStrategy.java:441)
		at hudson.PluginManager.dynamicLoad(PluginManager.java:478)
		... 6 more
		Caused by: java.lang.ClassCircularityError: org/jruby/RubyClass
		at java.lang.Class.forName0(Native Method)
		at java.lang.Class.forName(Class.java:348)
		at org.jenkinsci.bytecode.ClassWriter.loadClass(ClassWriter.java:97)
		at org.jenkinsci.bytecode.ClassWriter.getCommonSuperClass(ClassWriter.java:64)
		at org.kohsuke.asm5.ClassWriter.getMergedType(ClassWriter.java:1654)
		at org.kohsuke.asm5.Frame.merge(Frame.java:1426)
		at org.kohsuke.asm5.Frame.merge(Frame.java:1374)
		at org.kohsuke.asm5.MethodWriter.visitMaxs(MethodWriter.java:1475)
		at org.kohsuke.asm5.tree.MethodNode.accept(MethodNode.java:833)
		at org.kohsuke.asm5.commons.JSRInlinerAdapter.visitEnd(JSRInlinerAdapter.java:187)
		at org.jenkinsci.bytecode.Transformer$1$1.visitEnd(Transformer.java:107)
		at org.kohsuke.asm5.MethodVisitor.visitEnd(MethodVisitor.java:877)
		at org.kohsuke.asm5.ClassReader.readMethod(ClassReader.java:1021)
		at org.kohsuke.asm5.ClassReader.accept(ClassReader.java:693)
		at org.kohsuke.asm5.ClassReader.accept(ClassReader.java:506)
		at org.jenkinsci.bytecode.Transformer.transform(Transformer.java:113)
		at hudson.ClassicPluginStrategy$AntClassLoader2.defineClassFromData(ClassicPluginStrategy.java:800)
		at jenkins.util.AntClassLoader.getClassFromStream(AntClassLoader.java:1310)
		at jenkins.util.AntClassLoader.findClassInComponents(AntClassLoader.java:1366)
		at jenkins.util.AntClassLoader.findClass(AntClassLoader.java:1326)
		at jenkins.util.AntClassLoader.loadClass(AntClassLoader.java:1079)
		at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
		at org.jenkinsci.jruby.RubyClassConverter.<init>(RubyClassConverter.java:12)
		at org.jenkinsci.jruby.JRubyXStream.register(JRubyXStream.java:25)
		at ruby.RubyRuntimePlugin.initRubyXStreams(RubyRuntimePlugin.java:44)
		at ruby.RubyRuntimePlugin.start(RubyRuntimePlugin.java:28)
		at hudson.ClassicPluginStrategy.startPlugin(ClassicPluginStrategy.java:449)
		at hudson.ClassicPluginStrategy.load(ClassicPluginStrategy.java:438)
		... 7 more

		网上继续寻找问题,在Jenkins的官网找到一个issue, 描述的就是这个问题. Phellipe Ribeiro最后给出了一个在CentOS的临时解决方案:

		编辑Jenkins的配置文件 /etc/sysconfig/jenkins 的JENKINS_JAVA_OPTIONS

		修改后 : JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Dhudson.ClassicPluginStrategy.noBytecodeTransformer=true"

		```

7. 如果安装没有问题，或者已经修好了，可以重新gitlib-hooks插件
8. 在gitLab项目中添加web hook(Project Settings --> WebHooks)
   ![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161028-1058-31385-4992/1611041-59d2206aa8b32ea8.png)
   [原文参考地址](https://github.com/elvanja/jenkins-gitlab-hook-plugin#notify-commit-hook "原文参考地址")

		```
		gitlab的web hook有很多种，可以满足不同的需求，因为我们的需求是push代码的时候触发，所以选的是Push events.

		Url的作用:这个地方填的url是gitlab发请求用的。其实它的原理就是当开发人员在git上的操作触发这个hook时，gitlab就向这个url发一个post请求。请求中带着一堆参数比如提交者是谁，提交的分支是哪个，commit号是多少等等。接受这个请求的那端可以利用这些信息去处理后续的一些事情，比如部署测试通知等等。

		此处，由于我们在jenkins上安装了gitlab hook插件，所以我们只需要按照它的使用方法在url里填上以下链接即可：

		http://your-jenkins-server/gitlab/notify_commit
		```

9. 在jenkins里需要自动触发的job里的“源码管理”部分添加设置，如下图。填好git仓库url和需要检测的分支名称
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161028-1100-17587-3793/1611041-951949d1ebb55811.png)