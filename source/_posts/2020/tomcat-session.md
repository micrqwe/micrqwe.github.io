# session存储

## 集群中有4种存储session的方式
1.  Session Sticky 。 每次请求都到一台机子中去
2. Session Replication 每个容器对session进行同步复制
3. Session数据集中存储 使用redis
4. Cookie Based 数据放到cookie中传输

## tomcat中配置Session Replication

1. tomcat复制2份 端口勿冲突,不需要做任何修改，在这一行的下面加入如下代码：
```
  -- tomcat中有这么一行代码，打开注释即可
    <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"  
                    channelSendOptions="8">  
      
             <Manager className="org.apache.catalina.ha.session.DeltaManager"  
                      expireSessionsOnShutdown="false"  
                      notifyListenersOnReplication="true"/>  
      
             <Channel className="org.apache.catalina.tribes.group.GroupChannel">  
               <Membership className="org.apache.catalina.tribes.membership.McastService"  
                           address="228.0.0.4"  
                           port="45564"  
                           frequency="500"  
                           dropTime="3000"/>  
               <Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver"  
                         address="auto"  
                         port="4000"  
                         autoBind="100"  
                         selectorTimeout="5000"  
                         maxThreads="6"/>  
      
               <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">  
               <Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>  
               </Sender>  
               <Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>  
               <Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>  
             </Channel>  
      
             <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"  
                    filter=""/>  
             <Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve"/>  
      
             <Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer"  
                       tempDir="/tmp/war-temp/"  
                       deployDir="/tmp/war-deploy/"  
                       watchDir="/tmp/war-listen/"  
                       watchEnabled="false"/>  
      
             <ClusterListener className="org.apache.catalina.ha.session.JvmRouteSessionIDBinderListener"/>  
             <ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener"/>  
           </Cluster>  
```