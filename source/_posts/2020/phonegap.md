# 安装phonegap过程
## 安装node.js
```
  前往https://nodejs.org/en/下载最新安装包，并将目录放置path中
```
## 安装phonegap
```
  sudo npm install -g phonegap
```

## cordova
```
  sudo npm install -g cordova 
  cordova是phonegap提交给apache开源代码的品牌，cordova是核心代码。phoengap如上层框架
```
## 创建app
```
 phonegap create myapp
 或者
 cordova create myapp
 cd myapp
 cordova platform add browser/cordova platform add android  将项目加到哪个平台中去
 cordova run android  运行该项目
 cordova build -release发布生产版本
 注：android需要添加path，
   sudo vi /etc/profild.d/xxx.sh  当前环境变量名。
   exprot ANDROID_HOME=/xxxxx/xxxx/sdk
   exprot PATH=$ANDROID_HOME/platform-tools:$PATH
   exprot PATH=$ANDROID_HOME/tools:$PATH
```
## cordova常用命令

 1. cd myapp   进入工作目录
 2. cordova serve 或者phonegap serve 直接运行html代码
 3. cordova build  编译代码
 4. cordova plugin ls 当前使用的插件
 5.  cordova rm *  移除插件
 6. cordova plugin add cordova-plugin-device 添加可以获取设备信息的插件
 7. http://cordova.apache.org/plugins/  插件查找网站
 8.  http://docs.phonegap.com/zh/edge/guide_cli_index.md.html#%E5%91%BD%E4%BB%A4%E8%A1%8C%E7%95%8C%E9%9D%A2  参考中文网
 9. http://cordova.apache.org/docs/zh/6.0.0/config_ref/index.html   最新的cordova中文文档
 10. http://cordova.apache.org/docs/en/latest/guide/overview/  官方文档

## app的在线更新code-push使用
```
 使用code-push 微软提供插件,
 安装命令：cordova plugin add cordova-plugin-code-push
 安装后要使用code-push命令，需要另外安装：npm install -g code-push-cli，github地址:https://github.com/Microsoft/code-push/tree/master/cli
 安装好code-push就要进行注册登陆，可以是使用github和microsoft账号，登陆会给出一个key进行登陆，使用命令:code-push register 
 code-push app add (you app name)添加一个app
 code-push deployment ls (you app name) -k 查看你的app的key
 code-push release myapp <path_to_your_app>/platforms/android/assets/www 0.0.1 --deploymentName Production/Staging 将自己的代码推上去( Production/Staging 2选1)
  在app的config.xml添加一下内容
  <platform name="android">
        <preference name="CodePushDeploymentKey" value="你的app的key" />
    </platform>
    <platform name="ios">
        <preference name="CodePushDeploymentKey" value="你的app的key" />
    </platform>
 
 InstallMode
    IMMEDIATE: 立即更新app.
    ON_NEXT_RESTART: 更新是下载，但没有立即安装。新的内容将在下一次应用程序启动时可用.
    ON_NEXT_RESUME: 的更新下载，但不立即安装。新的内容将在下一次申请恢复或重新启动，无论事件发生的第一.
```
## wechat微信插件使用
```
$scope.shares = function () {
// 发送到朋友圈
                        Wechat.share({
                            text: "豆豆你好",
                            scene: Wechat.Scene.TIMELINE   // share to Timeline
                        }, function () {
                            alert("Success");
                        }, function (reason) {
                            alert("Failed: " + reason);
                        });
}
```
## Cordova使用crosswalk更换内置的浏览器

 crosswalk[官方文档](https://crosswalk-project.org/documentation/cordova.html "官方文档")
```
  1. cordova plugin add cordova-plugin-crosswalk-webview
  2. cordova build android
```

## 使用百度云进行推送消息
1. 参考资料[百度云推送](https://github.com/EtherZhou/baidupush "百度云推送")