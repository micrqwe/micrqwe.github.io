# xcode找不到
```
1. 直接appStore上下载不会有问题
2. 自己额外下载会有可能变更安装目录，造成找不到xcodebuild
3. 解决原因:sudo xcode-select -s (/Applications/Xcode.app/Contents/Developer|你的安装地址 )
```