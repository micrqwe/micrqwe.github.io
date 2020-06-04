# jstorm记录
## 安装
 * 官方网站参考http://www.jstorm.io/
 * github https://github.com/alibaba/jstorm
```
官网已经有详细介绍了，这里就不重复
```

## 简介

JStorm集群包含两类节点：主控节点（Nimbus）和工作节点（Supervisor）。其分别对应的角色如下：
1. 主控节点（Nimbus）上运行Nimbus Daemon。Nimbus负责接收Client提交的Topology，分发代码，分配任务给工作节点，监控集群中运行任务的状态等工作。Nimbus作用类似于Hadoop中JobTracker。
2. 工作节点（Supervisor）上运行Supervisor Daemon。Supervisor通过subscribe Zookeeper相关数据监听Nimbus分配过来任务，据此启动或停止Worker工作进程。每个Worker工作进程执行一个Topology任务的子集；单个Topology的任务由分布在多个工作节点上的Worker工作进程协同处理。
```
Nimbus和Supervisor节点之间的协调工作通过Zookeeper实现。此外，Nimbus和Supervisor本身均为无状态进程，支持Fail Fast；JStorm集群节点的
状态信息或存储在Zookeeper，或持久化到本地，这意味着即使Nimbus/Supervisor宕机，重启后即可继续工作。这个设计使得JStorm集群具有非常好的
稳定性。
```

## 概念

* Storm组件和Hadoop组件对比

|   |jstorm|hadoop |
|---|------|-------|
| 角色  |   Nimbus   |   JobTracker    |
|   |  Supervisor    |    TaskTracker   |
|   |   Worker   |   Child    |
|应用名称  |   Topology|   Job |
|  编程接口 |    	Spout/Bolt|    	Mapper/Reducer|

接下来解释几个重要的概念：

1. topology
```
    jstorm所执行的任务，其实就是一个topology，一个topology可以包含多个spout，多个bolt，多级bolt
```

2. spout
```
   流的来源
```

3. bolt
```
    可以说是流的去处（这里可以进行业务处理）
```
