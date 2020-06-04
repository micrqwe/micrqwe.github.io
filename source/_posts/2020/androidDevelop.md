# 无法安装软件


1. adb uninstall net.sourceforge.simcpux  / 这样可以将手机中的软件删除干净
2. 移动app支付的时候调用起微信客户端的进行sign的key全部是小写，和公众号的不一样，公众号的驼峰标示。

## 用电脑版Chrome进行调试
```
1. 准备已就绪，在chrome地址栏输入“chrome://inspect“即可进入调试页面，对应的设备下方会显示chrome打开的网页和手机上打开的App，网页下方的四个按键分别对应审查、置顶、重载和关闭对应网页，右上方的输入框可输入要打开的网页链接。
2. 打开的app运行在android4.4以上系统，同时使用的事chrome浏览器内核
3. 第一次打开网页的审查会一片空白，这是因为第一次需要翻墙链接
```


# android进行生成签名

```
keytool -genkeypair \
    -keyalg RSA \
    -keysize 1024 \
    -sigalg SHA1withRSA \
    -dname "CN=www.xxxx.net, OU=R&D, O=\"xxx xxx Tech Co., Ltd\", L=WenZhou, S=Zhejiang, C=CN" \
    -validity 3650 \
    -alias (别名) \
    -keypass  (此处是密码) \
    -keystore app.jks \
    -storepass (此处是密码)
```

# 签名
```
jarsigner -keystore app.jks \
    -storepass  (此处是上一个填写密码) \
    -storetype jks \
    -keypass AmEd3ERCxEf \
    -digestalg SHA1 \
    -sigalg SHA1withRSA \
    -tsa http://timestamp.digicert.com \
    -signedjar (加密后apk地址)android-release-signed.apk \
  (加密前apk地址)android-release-unsigned.apk \
    (上面填写的别名)
```

# 验证
```
jarsigner -verify \
    -keystore app.jks \
    -storetype jks \
    -tsa http://timestamp.digicert.com \
    -digestalg SHA1 \
    -sigalg SHA1withRSA \
    (加密后apk地址)android-release-signed.apk
```