# 苹果推送证书设置

## 为你的 App 创建 App ID

iOS 中每个 App 都需要对应一个 App ID，同一个公司可能会使用类似于 com.example.* 这样通用的 App ID，但是如果要在 App 中加入消息推送功能，那么是不能使用通用 ID 的，需要为之单独创建一个。

首先登陆 iOS Dev Center ，然后进入 Member Center，然后选择 Certificates，Identifiers & profiles，如下图：
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1400-7679-2865/adx_member_center__1_.png)
然后点击下图红框中的任意条目，进入证书界面，如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1359-30361-2982/adx_member_center.png)
在进入证书界面后，在左边的Identifiers选择中选定App IDs，点右上角加号创建Appid，如下图：
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1400-30361-2822/adx_create_appid.png)
在创建 App ID 的过程中，需要勾选 Push 服务，如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1400-13361-1537/adx_select_push.png)
进入提交页面，push服务处于configurable状态，如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1401-30374-0318/adx_push_configurable.png)
点击submit后到确认页面，如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1401-7679-9469/adx_push_done.png)
点击done后到初始页面，然后再次选择自己创建的appid，如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1402-30374-1278/adx_push_choose_appid.png)
在下图中选择edit按钮，配置推送的环境，如图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1402-13361-3035/adx_edit_push_mode.png)
然后配置好对应的推送环境，个人版和企业版的开发环境都是选择创建Development SSL Certificate类型的。个人版和企业版的发布环境。发布环境分以下三种：1. in-house必须是企业开发账户（企业内）（299美金） 2.ad-hoc个人账户或公司Company账户（99美金），但只用于内部测试（总共100个设备）.3.上线Appstore只能是个人账户或公司Company账户（99美金））如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1402-30374-4662/adx_done_push_mode.png)
如果你是为已有的 App 增加消息推送功能，那么打开原有的 App ID，开启 Push Notification 选项即可。流程跟上面的一样。

## 创建及下载证书

点击 Create Certificate按钮后会出现“About Creating a Certificate Signing Request (CSR)”，如下图：
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1404-30389-2022/adx_select_csr.png)
到了这里，需要停下制作 CSR 文件，制作过程比较简单，下面是制作的过程。打开 Mac 系统软件'钥匙串访问'，选择 '证书助理' 及 '从证书颁发机构请求证书'，制作 CSR 文件，如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1404-30361-5197/adx_open_keychain.png)
生成证书后，返回到 “About Creating a Certificate Signing Request (CSR)” 的界面，点击 continue，然后在 “Choose File” 选择生成的CSR文件，最后点击 Generate，生成证书。如下图:
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1405-7679-6626/adx_generate_cert.png)
在证书制作已经完成。下载并双击用“钥匙串访问” 程序打开后，在左边一栏，上面选择登录，下面选择证书，然后选择刚刚打开的证书，切记不要展开它，直接右击导出p12，如下图：
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1405-30374-6755/adx_open_cer.png)
将文件保存为 .p12 格式，输入密码，如图所示：
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1407-30389-7240/adx_save_p12.png)
最后进入终端，到证书目录下，运行以下命令将p12文件转换为pem证书文件：
```
openssl pkcs12 -in MyApnsCert.p12 -out MyApnsCert.pem -nodes
```
提示需要输入密码，输入刚才导出 p12 时的密码即可。

## 生成app
Provisioning Profile的创建 点击下图的+按钮开始创建profile
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1408-30361-5950/adx_provisioning_profile.png)
选择profile的环境
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1409-30361-6637/adx_provisioning_profile_ev.png)
选择创建profile的appid和开发者证书，并选择设备，最后生成profile
![](https://csdn-code.oss.aliyuncs.com/php-upload-images/20161013-1409-30374-8853/adx_provisioning_profile_device.png)
最后下载profile配置到xcode中进行开发测试

## iOS推送简介
```
在 iOS 设备上（模拟器无法使用推送），系统收到通知后这样处理：

在屏幕上弹出一些选项，或者在屏幕顶部显示横幅（banner）如下图左
App 的角标数值发生变化，具体表现为 App icon 右上角的小红点及数字，如邮件中的红点
伴随推送消息的提示声音
当应用处于前台运行时，系统是不会在屏幕上显示通知，但是仍会调用相应的 API。

只有真机可以使用推送功能。
```

## 推送证书验证

1.  通知的两种推送环境

```
在使用 iOS 远程推送功能时，有两种不同的环境。开发环境（Development）以及生产环境（Production）。
App 当前使用的推送环境与 Xcode - Build Settings - Code Signing - Provisioning Profile 文件的模式一致。
```


1. 证书与证书校验

```
与 APNs 之间是加密的连接，因此需要使用证书来加密连接。每个的推送环境有自己单独的推送证书，即开发证书和生产证书。

在将证书最终转为 pem 格式后，可通过与 APNs 连接来测试证书是否有效。

开发环境：

openssl s_client -connect gateway.sandbox.push.apple.com:2195 -cert MyApnsDev.pem

生产环境：

openssl s_client -connect gateway.push.apple.com:2195 -cert MyApnsPro.pem

当输入完命令回车后，终端首先会输出很多相关信息。

当连接建立失败时，会直接 close 掉。

当连接建立成功时，终端会停止输出，并等待你输入，你可以随便输入一些字符后摁回车，然后连接才会关闭。


```