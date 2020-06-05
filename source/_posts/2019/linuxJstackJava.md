title: 未分组
date: 2020-06-23 11:10:08
---------
# 定位正在运行的程序死循环处(linux处使用)

## 查看java的pid
1. ps -ef | grep java  或者使用 top 
  找到你的java程序的进程id, 定位 pid
2. top -Hp $pid
  查看耗cpu时间最多的几个线程, 记录下线程的id.注：这里的进程是10进制的。
3. jstack $pid > stack.log 生成dump文件。将上面线程的id换成16进制，加上0x$id 。查找dump出来的文件。就是该线程的堆栈信息
4. 统计线程数量 ps -hH $pid| wc -l
## cpu运行
 top 按1键看每个数据,z 彩色  c是， f是

1. us是用户的，运行一些数据会飙升
2. sy系统调度资源
3. ni 运行已调整优先级的用户进程的CPU时间
4. id 空闲的，
5. wa 等待
6. hi  处理硬件中断的CPU时间
7. si  处理软件中断的CPU时间

场景1：java启动100个cpu密集型任务，在24核上处理，假设平均的分在每一核心上执行， us或者sy很高，us执行，sy调度。id和wa很低

## 查看程序占用端口
  1. linux : netstat -naop  
  2. windows:  netstat -ano |findstr 62045