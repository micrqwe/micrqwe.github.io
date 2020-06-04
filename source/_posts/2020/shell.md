# 记录自己的一些使用shell脚本的数据

1. 获取进程的pid号：ps -ef | grep tomcat/ | grep -v grep | awk '{print $2}'
```
这个脚本首先用ps -ef | grep tomcat-tuiguang/ 获得了进程信息中包含 tomcat-tuiguang/ 的进程信息，这样出来的结果中会包含grep本身，所以我们需要用 | grep -v grep 来排除grep本身，然后通过 awk '{print $2}'来打印出要找的进程。
上述例子中只是将进程id号打印出来，当然也可以修改为将tomcat进程kill掉，如下脚本：
ps -ef | grep tomcat-tuiguang/ | grep -v grep | awk '{print $2}'  | sed -e "s/^/kill -9 /g" | sh -
```

1. 获取脚本的全路径: DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
1. 获取当前系统时间: IME="date +%Y-%m-%d.%H:%M:%S"