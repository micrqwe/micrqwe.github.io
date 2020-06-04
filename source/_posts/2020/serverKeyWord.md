# ubuntu server修改键盘布局
```
方法1：

也许是以前的Ubuntu版本可以用这个命令改，现在的键盘布局被独立分开设置，于是我尝试了一下，发现正确的命令应该是：“ sudo dpkg-reconfigure keyboard-configuration ”，这个才对，使用这个命令后会出现非常人性化的伪图形界面供我们设置。


方法2：

另外，如果觉得不够“爽快”，想直接修改配置文件的同学们可以用一下这种方法：

sudo vim /etc/default/keyboard把里面XKBLAYOUT变量的值改为“us”，然后在终端（文字终端，不是虚拟终端，也就是Ctrl+Alt+F2或F3或F4.......）运行命令：setupcon。

最后为了让它立即生效，键入，sudo udevadm trigger --subsystem-match=input --action=change（sudo应该是有无都可以的），或者重启电脑即可。
```