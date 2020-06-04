# 使用bower的项目初始化

## npm和bower的作用
1. npm是主要用来安装各种运行类工具的
2. bower用来下载类库的

## 初始化项目
1. 安装nodeJs，不会请看首页进行安装
2. 新建项目进行安装bower: sudo npm install bower -g,(更好的管理可以先:npm init初始化项目) 。请参考 npm --help
3. 安装完成，输入:bower init ;初始化项目。进行完成
4. 例子，安装vue: bower install vue 。这个样下载好了vue.js。 会在当前目录下生成bower_components文件夹，作为下载的文件
5. 为项目配置上gulp : npm install gulp   --> 学习：[参考网址](http://www.gulpjs.com.cn)

## gulp使用
```
简单输出一行字，按照上面参考网址中的例子，在任务中输出一句话
		先进行 const gutil = require('gulp-util');  然后在任务中输入:gutil.log('hello word');
		var gulp = require('gulp');
		const gutil = require('gulp-util');
		gulp.task('default', function() {
			gutil.log('hello word'');
		});
在这里会抛错，找不到gulp-util。这里就要执行:npm install gulp-util,而不是bower，bower是管理js类库的
命令行输入gulp 就能看到打印的语句了
```

## npm安装之后出现命令无法运行(windows下比如gulp)

```
1. 安装路径默认是C盘，当前没有加到path命令导致无法运行。在安装之后都会有安装的目录提示
2. 自定义安装目录：
npm config set cache "D:\nodejs\node_cache"
npm config set prefix "D:\nodejs\node_global"
3. 将global路径放到path中去。可以运行安装的应用了
```