id: 202008200001
title: java线程池参数说明
date: 2020-06-23 11:10:08
tags: "快速访问"
---------

### java线程池
ThreadPoolExecutor
来窥探线程池核心类的构造函数，我们需要理解每一个参数的作用，才能理解线程池的工作原理。
```$xslt
  public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              ThreadFactory threadFactory,
                              RejectedExecutionHandler handler) {
        ......
    }
```

1. corePoolSize：保留在池中的线程数，即使它们空闲，除非设置了 allowCoreThreadTimeOut，不然不会关闭。
1. maximumPoolSize：队列满后池中允许的最大线程数。
1. keepAliveTime、TimeUnit：如果线程数大于核心数，多余的空闲线程的保持的最长时间会被销毁。unit 是 keepAliveTime 参数的时间单位。当设置 allowCoreThreadTimeOut(true) 时，线程池中 corePoolSize 范围内的线程空闲时间达到 keepAliveTime 也将回收。
1. workQueue：当线程数达到 corePoolSize 后，新增的任务就放到工作队列 workQueue 里，而线程池中的线程则努力地从 workQueue 里拉活来干，也就是调用 poll 方法来获取任务。
1. ThreadFactory：创建线程的工厂，比如设置是否是后台线程、线程名等。
1. RejectedExecutionHandler：拒绝策略，处理程序因为达到了线程界限和队列容量执行拒绝策略。也可以自定义拒绝策略，只要实现 RejectedExecutionHandler 即可。默认的拒绝策略：AbortPolicy 拒绝任务并抛出 RejectedExecutionException 异常；CallerRunsPolicy 提交该任务的线程执行；

* 来分析下每个参数之间的关系：
提交新任务的时候，如果线程池数 < corePoolSize，则创建新的线程池执行任务，当线程数 = corePoolSize 时，新的任务就会被放到工作队列 workQueue 中，线程池中的线程尽量从队列里取任务来执行。
如果任务很多，workQueue 满了，且 当前线程数 < maximumPoolSize 时则临时创建线程执行任务，如果总线程数量超过 maximumPoolSize，则不再创建线程，而是执行拒绝策略。DiscardPolicy 什么都不做直接丢弃任务；DiscardOldestPolicy 丢弃最旧的未处理程序;


### tomcat线程池

定制版的 ThreadPoolExecutor，继承了 java.util.concurrent.ThreadPoolExecutor。 对于线程池有两个很关键的参数：

线程个数。
队列长度。

Tomcat 必然需要限定想着两个参数不然在高并发场景下可能导致 CPU 和内存有资源耗尽的风险。继承了 与 java.util.concurrent.ThreadPoolExecutor 相同，但实现的效率更高。
其构造方法如下，跟 Java 官方的如出一辙
```$xslt
public ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, RejectedExecutionHandler handler) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, handler);
        prestartAllCoreThreads();
    }
```
在 Tomcat 中控制线程池的组件是 StandardThreadExecutor , 也是实现了生命周期接口，下面是启动线程池的代码
```$xslt
 @Override
    protected void startInternal() throws LifecycleException {
        // 自定义任务队列
        taskqueue = new TaskQueue(maxQueueSize);
        // 自定义线程工厂
        TaskThreadFactory tf = new TaskThreadFactory(namePrefix,daemon,getThreadPriority());
       // 创建定制版线程池
        executor = new ThreadPoolExecutor(getMinSpareThreads(), getMaxThreads(), maxIdleTime, TimeUnit.MILLISECONDS,taskqueue, tf);
        executor.setThreadRenewalDelay(threadRenewalDelay);
        if (prestartminSpareThreads) {
            executor.prestartAllCoreThreads();
        }
        taskqueue.setParent(executor);
        // 观察者模式，发布启动事件
        setState(LifecycleState.STARTING);
    }
```
   
其中的关键点在于：

Tomcat 有自己的定制版任务队列和线程工厂，并且可以限制任务队列的长度，它的最大长度是 maxQueueSize。
Tomcat 对线程数也有限制，设置了核心线程数（minSpareThreads）和最大线程池数（maxThreads）。

除此之外， Tomcat 在官方原有基础上重新定义了自己的线程池处理流程，原生的处理流程上文已经说过。

前 corePoolSize 个任务时，来一个任务就创建一个新线程。
还有任务提交，直接放到队列，队列满了，但是没有达到最大线程池数则创建临时线程救火。
线程总线数达到 maximumPoolSize ，直接执行拒绝策略。

Tomcat 线程池扩展了原生的 ThreadPoolExecutor，通过重写 execute 方法实现了自己的任务处理逻辑：

前 corePoolSize 个任务时，来一个任务就创建一个新线程。
还有任务提交，直接放到队列，队列满了，但是没有达到最大线程池数则创建临时线程救火。
线程总线数达到 maximumPoolSize ，继续尝试把任务放到队列中。如果队列也满了，插入任务失败，才执行拒绝策略。

最大的差别在于 Tomcat 在线程总数达到最大数时，不是立即执行拒绝策略，而是再尝试向任务队列添加任务，添加失败后再执行拒绝策略。
代码如下所示:
```$xslt
    public void execute(Runnable command, long timeout, TimeUnit unit) {
       // 记录提交任务数 +1
        submittedCount.incrementAndGet();
        try {
            // 调用 java 原生线程池来执行任务，当原生抛出拒绝策略
            super.execute(command);
        } catch (RejectedExecutionException rx) {
          //总线程数达到 maximumPoolSize，Java 原生会执行拒绝策略
            if (super.getQueue() instanceof TaskQueue) {
                final TaskQueue queue = (TaskQueue)super.getQueue();
                try {
                    // 尝试把任务放入队列中
                    if (!queue.force(command, timeout, unit)) {
                        submittedCount.decrementAndGet();
                      // 队列还是满的，插入失败则执行拒绝策略
                        throw new RejectedExecutionException("Queue capacity is full.");
                    }
                } catch (InterruptedException x) {
                    submittedCount.decrementAndGet();
                    throw new RejectedExecutionException(x);
                }
            } else {
              // 提交任务书 -1
                submittedCount.decrementAndGet();
                throw rx;
            }

        }
    }
```
Tomcat 线程池是用 submittedCount 来维护已经提交到了线程池，这跟 Tomcat 的定制版的任务队列有关。Tomcat 的任务队列 TaskQueue 扩展了 Java 中的 LinkedBlockingQueue，我们知道 LinkedBlockingQueue 默认情况下长度是没有限制的，除非给它一个 capacity。因此 Tomcat 给了它一个 capacity，TaskQueue 的构造函数中有个整型的参数 capacity，TaskQueue 将 capacity 传给父类 LinkedBlockingQueue 的构造函数，防止无限添加任务导致内存溢出。而且默认是无限制，就会导致当前线程数达到核心线程数之后，再来任务的话线程池会把任务添加到任务队列，并且总是会成功，这样永远不会有机会创建新线程了。
为了解决这个问题，TaskQueue 重写了 LinkedBlockingQueue 的 offer 方法，在合适的时机返回 false，返回 false 表示任务添加失败，这时线程池会创建新的线程。
```$xslt
public class TaskQueue extends LinkedBlockingQueue<Runnable> {

  ...
   @Override
  // 线程池调用任务队列的方法时，当前线程数肯定已经大于核心线程数了
  public boolean offer(Runnable o) {

      // 如果线程数已经到了最大值，不能创建新线程了，只能把任务添加到任务队列。
      if (parent.getPoolSize() == parent.getMaximumPoolSize())
          return super.offer(o);

      // 执行到这里，表明当前线程数大于核心线程数，并且小于最大线程数。
      // 表明是可以创建新线程的，那到底要不要创建呢？分两种情况：

      //1. 如果已提交的任务数小于当前线程数，表示还有空闲线程，无需创建新线程
      if (parent.getSubmittedCount()<=(parent.getPoolSize()))
          return super.offer(o);

      //2. 如果已提交的任务数大于当前线程数，线程不够用了，返回 false 去创建新线程
      if (parent.getPoolSize()<parent.getMaximumPoolSize())
          return false;

      // 默认情况下总是把任务添加到任务队列
      return super.offer(o);
  }

}
```

只有当前线程数大于核心线程数、小于最大线程数，并且已提交的任务个数大于当前线程数时，也就是说线程不够用了，但是线程数又没达到极限，才会去创建新的线程。这就是为什么 Tomcat 需要维护已提交任务数这个变量，它的目的就是在任务队列的长度无限制的情况下，让线程池有机会创建新的线程。可以通过设置 maxQueueSize 参数来限制任务队列的长度。

