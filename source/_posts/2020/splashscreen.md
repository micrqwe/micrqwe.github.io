# 配置说明

1. 自动隐藏启动页面AutoHideSplashScreen（默认为：true)
```
<preference name="AutoHideSplashScreen" value="true" />
```

2. 显示启动页面的时间长度SplashScreenDelay(默认为：3000)
```
<preference name="SplashScreenDelay" value="3000" />
若想禁用启动页面，可设置为：<preference name="SplashScreenDelay" value="0"/>
如果是iOS平台上想禁止启动页面，还需要添加<preference name="FadeSplashScreenDuration" value="0"/>
```

3. 启动页面淡入淡出的效果
```
是否显示淡入淡出效果FadeSplashScreen(默认为：true)
<preference name="FadeSplashScreen" value="false"/>
淡入淡出效果的执行时间长度FadeSplashScreenDuration(默认为：500)
<preference name="FadeSplashScreenDuration" value="750"/>
注意：FadeSplashScreenDuration时间是包含在SplashScreenDelay的时间里的。
```

4. 启动页面是否允许旋转（默认为：true）
```
<preference name="ShowSplashScreenSpinner" value="false"/>
插件还可以通过js代码调用，提供有以下两个方法：
navigator.splashscreen.hide();//隐藏启动页面
navigator.splashscreen.show();//显示启动页面
```

5. 在Android平台下的特殊设置
```
<preference name="SplashMaintainAspectRatio" value="true|false" />
<preference name="SplashShowOnlyFirstTime" value="true|false" />
SplashMaintainAspectRatio：选填项，默认为false。当设置为true时，则不会拉伸图片来填充屏幕，会以图片原始比例显示图片。
SplashShowOnlyFirstTime：选填项，默认为true。当设置为false时，APP通过navigator.app.exitApp()代码退出app后，在下次打开APP时，还会显示启动页面。若为true时，就不会出现。
```



