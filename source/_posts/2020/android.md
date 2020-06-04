# android开源镜像和加速运行虚拟机

## 东软学院镜像
1. [android东软](http://mirrors.neusoft.edu.cn/)

## 设置 Android SDK Manager 使用国内镜像 
```
android 
    -> 主界面
    -> 点击菜单 "Tools"
    -> 点击菜单项 "Options..."，弹出窗口： "Android SDK Manager - Settings" :
        -> 设置 "HTTP Proxy Server" 为 `mirrors.neusoft.edu.cn`
        -> 设置 "HTTP Proxy port" 为 `80`
        -> 勾选中 "Force https://... sources to be fetched using http://..."
        -> 点击 "Close" 按钮
    -> 点击菜单 "Packages"
    -> 点击菜单项 "Reload"
```

## 命令行更新
```
查询更新的类目：android list sdk --extended --proxy-host mirrors.neusoft.edu.cn --proxy-port 80 -s
更新制定的：android update sdk --no-ui --filter 2 --proxy-host mirrors.neusoft.edu.cn --proxy-port 80 -s
安装 id: 2 or "android-21"Android 21 的SDK。
安装的时候提示接受license:
Do you accept the license 'android-sdk-preview-license-52d11cd2' [y/n]:
选择y同意之后继续安装。
等待安装成功。
使用国内的镜像服务器安装，服务稳定，下载速度快，不需要FQ。
注：其中id为32是extra-android-m2repository，android的Support Libraries。
```

1. 错误

```
错误
 Cannot run program "/var/lib/jenkins/tools/android-sdk/build-tools/23.0.1/aapt": error=2, No such file or directory
    at java.lang.ProcessBuilder.start(ProcessBuilder.java:1048)
    at com.android.builder.png.AaptProcess$Builder.start(AaptProcess.java:163)
    at com.android.builder.png.QueuedCruncher$1.creation(QueuedCruncher.java:106)
    at com.android.builder.tasks.WorkQueue.run(WorkQueue.java:203)
    at java.lang.Thread.run(Thread.java:745)
Caused by: java.io.IOException: error=2, No such file or directory
    at java.lang.UNIXProcess.forkAndExec(Native Method)
    at java.lang.UNIXProcess.<init>(UNIXProcess.java:248)
    at java.lang.ProcessImpl.start(ProcessImpl.java:134)
    at java.lang.ProcessBuilder.start(ProcessBuilder.java:1029)
    ... 4 more
Thread(png-cruncher_2) has a null payload

因为aapt是32的位，不能在64位的系统上面运行，需要安装32位的支持。CentOS:

    sudo yum install libz.so.1

Ubuntu:

    sudo yum apt-get install lib32z1

```

##  （可选），选中 所需的各种 API版本 并下载安装
   ```
    -> 点击菜单 "Tools"
    -> 点击菜单项 "Manage AVDs"，弹出窗口: "Android Virtual Device (AVD) Manager" :
        -> 点击 "Create" 按钮
        -> AVD Name         : 随意输入，比如 "test1"
        -> Device           : 比如 "Nexus One (3.7", 480 x 800: hdpi)" 
        -> Taget            : 比如 "Android 4.4.2 - API Level 19"
        -> CPU/ABI          : 通常为 "Intel Atom (x86)"
        -> Keyboard         : 勾选中 "Hardware keyboard present"
        -> Skin             : 选中 "Skin with dynamic hardware controls"
        -> Front Camera     : "None"
        -> Back Camera      : "None"
        -> Memory Options   : RAM : 1024M, VM Heap: 32M
        -> Internal Sotrage : 2048M
        -> SD Card          : 2048M 
        -> Emulation Options: 选中 "Use Host GPU"
```


## Ubuntu 下面模拟器加速: 安装 kvm

```
sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
sudo adduser `whoami` kvm
sudo adduser `whoami` libvirtd

# 检验是否安装成功
sudo virsh -c qemu:///system list

# 列出所有的 avd
android list avd

# 选择一个并启动（使用 kvm）
# 注意：下面命令中的 "test1" 是 avd 的名称
emulator -avd test1 -qemu -m 2047 -enable-kvm
```


## nodejs换数据源
```
 npm config set registry https://registry.npm.taobao.org
```

## 也可以使用snpm(smart-npm)
```
npm install --global smart-npm --registry=https://registry.npm.taobao.org/
Linux 用户可以在 ~/.bashrc 文件中加一行
alias npm=smart-npm
Mac 用户可以在 ~/.bash_profile 文件中加一行
alias npm=smart-npm
    Window 用户需要先定位到 npm.cmd 和 smart-npm.cmd 两个文件，然后用 smart-npm.cmd 替换 npm.cmd（注意备份原来的 npm.cmd），同时注意修改下 smart-npm.cmd 文件里的路径，否则运行 npm 会报找不到文件错误（如果不明白，建议不要替换，直接使用 snpm 或 smart-npm）
可以使用命令 where smart-npm 来定位到 smart-npm.cmd 文件所在的位置。如：在我的系统上执行 where smart-npm 的结果是：
C:\Users\Mora>where smart-npm
C:\Program Files\nodejs\smart-npm
C:\Program Files\nodejs\smart-npm.cmd
同理可以定位到 npm.cmd 的位置
卸载
npm uninstall --global smart-npm
```

## mac无法识别android手机
```
插上手机打开终端，输入：system_profiler SPUSBDataType，将输出结果记住。
拔下手机，重复以上动作。
在终端里输入echo "0x2207" > ~/.android/adb_usb.ini   红色为你的设备VendorID
adb kill-server
```