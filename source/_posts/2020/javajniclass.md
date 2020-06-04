# Java调用JNI

## 调用过程
1. 首先需要java的方法需要native 做修饰。
1. 通过javac和javah生成.h文件。
1. 通过c++编程生成dll文件
1. 加载生成的DLL库文件.(后面代码详细讲解)

## 先看看java代码(分是否package)。这里是没有package的

```
import java.util.Map;
public class NativeOfficeConverter {
    /**
     * 将
     * @param path 需要转换的文件路径
     * @param outDir 输出的文件目录
     * @return  转换后的文件目录
     * key有3个: code  path imgPath
     * code不等于200 转换失败。等于200 path转换后的目录，等于传入的outDir。imgPath等同于path。可自定义
     */
    public native Map<String,String> docToHtmlConvert(String path,String outDir);
}
```
1. javac  -encoding UTF-8 NativeOfficeConverter.java
1. javah NativeOfficeConverter  // 别加class后缀。 .h文件就生成了

## 有package的

1. javah com.test.NativeOfficeConverter  
```
 这个命令需要在同com平级的目录上执行，同时.h文件会生成在当前目录。javah中有一个-d可以指定。看help
```

## 生成dll库

1. 放入到java系统中
```
	// 加载生成的DLL库文件
	static {
               // 2选1 load加载的是全路径。loadLibrary需要dll文件放入到系统环境变量中。预先已经加载
		System.loadLibrary("LibJniTest");
                System.load("LibJniTest");
	}
```