# mongodb的安装
1. 复制mongo.conf 进行配置文件
```
	# mongod.conf

	# for documentation of all options, see:
	#   http://docs.mongodb.org/manual/reference/configuration-options/
	net:
		port: 27010
		bindIp: 127.0.0.1

	processManagement:
		pidFilePath: /data0/mongod/mongod1.pid
		fork: true

	storage:
		dbPath: /data0/mongod/data/shard1
		directoryPerDB: true

	systemLog:
		destination: file
		path : /data0/mongod/log/shard1/mongodb.log
		logAppend: true

	replication:
		replSetName: rs0 
		oplogSizeMB: 1000
	# security:
	#    authorization: enabled

	单机不需要replication参数
```

2. 运行 我的mongodb
```
	bin/mongod -f xxx/mongod.conf 启动服务
	bin/mongod -shutdown -f xxx/mongod.conf 停止服务
	mongod 密码验证，刚开始。注释上面security：
	进入mongodb  /use admin库
	创建超级用户db.createUser({
							user: "admin",
							pwd: "admin",
							roles:
							[{
							role: "userAdminAnyDatabase",
							db: "admin"
							}]})
	在开启上面配置文件的 security。这时候mongodb将使用密码访问
```

3. mongodb开机启动
```
		[Unit]
		Description=MongoDB Server
		After=network.target

		[Service]
		User=mongod
		Group=mongod
		Type=forking

		PIDFile=/data0/mongod/mongod1.pid
		ExecStartPre=
		ExecStart=/usr/local/mongodb1/bin/mongod -f /usr/local/mongodb1/mongod.conf
		ExecReload=/usr/local/mongodb1/bin/kill -s HUP $MAINPID
		ExecStop=/usr/local/mongodb1/bin/kill -s QUIT $MAINPID
		WorkingDirectory=/data0/mongod
		Restart=always

		LimitFSIZE=infinity
		LimitCPU=infinity
		LimitAS=infinity
		LimitNOFILE=64000
		LimitRSS=infinity
		LimitNPROC=64000

		PrivateTmp=true

		[Install]
		WantedBy=multi-user.target
```

## mongodb集群服务
1.  mongodb配置一组relica sets。 仲裁节点(偶数台需要，奇数台不需要，作用是偶数台电脑，照成投票平均，仲裁节点可以增加票数)
2. **注：请先登陆到admin数据库在进行操作，否则后续操作会出错** (重点)
```
	ntpdate ntp.api.bz  集群时，首先执行命令 同步时钟（重要）
	mongod1.conf。可以多复制几个，使用一个mongod同时运行。
	mongo -port xx  // 链接到其中一台mongodb服务器上去
	configx = {_id:"rs0",version:1,members:[{_id:0,host:'127.0.0.1:27010',priority :2},{_id:1,host:'127.0.0.1:27020',priority:1},{_id:2,host:'127.0.0.1:27030',priority:1}]}  // 添加各个节点上去
	rs.initiate(configx)   // 初始化一个 replica sets
	rs.conf()      // 查看获取的配置
	 rs.reconfig(configx,{force:true})  // reconfig() 用来重新执行文档，force:true 是否覆盖以前
	rs.status()  // 查看状态。
	备注:从库只读 需要 rs.slaveOk();可以设置为只读 不可以写
```

2. mongod sharding configServer配置
```
	configServer的配置和mongod1.conf要多加如下面一句话。只需要dbpath和logpath换下就行

	**sharding:**
 		 **clusterRole: configsvr**

	configServer也需要dbpath

	另外#replication:replSetName：xxx  尽量别和replica set中的重名。否则mongos添加shard时通过Id会有可能找成configServer。非一台电脑可以不换，只需要不冲突就行,

	 configx = {_id:"configrs0",configsvr: true,members:[{_id:0,host:'127.0.0.1:27010',priority :2},{_id:1,host:'127.0.0.1:27020',priority:1},{_id:2,host:'127.0.0.1:27030',priority:1}]}  // 添加各个节点上去
```

3. mongod sharding mongos路由的配置
```
	net:
		port: 20000
		bindIp: test13.kingsilk.xyz

	processManagement:
		pidFilePath: /data0/mongod/mongos.pid
		#fork: true

	systemLog:
		destination: file
		path : /data0/mongod/log/mongos/mongodb.log
		logAppend: true

	sharding:
		configDB: xxxxxxxx:27000,xxxxxx:28000,xxxxxxx:29000
	mongos.conf  配置文件
	启动：mongos -f mongos.conf
```

4. 集群后的配置
```
	  键入：mongo -host xx -port xx   mongos的地址
	  sh.addShard("rs0/xxx:27010,txx:27020,xxx27030"); // 刚才输入的一组replica set。如果rs0和configServer中的replicationName一样。则可能会添加失败.修改Id 别冲突
```

## mongodb密码登录 一些快速创建密码账户，可以略过不用看

```

db.createUser(
  {
    user: "admin",
    pwd: "admin",
    roles:
    [
      {
        role: "userAdminAnyDatabase",
        db: "admin"
      }
    ]
  }
)
db.createUser(
  {
    user: "repl",
    pwd: "replication",
    roles: [
       { role: "readWrite", db: "admin" }
    ]
  }
)

db.createUser(
  {
    user:"root",
    pwd:"root",
    roles:["root"]
  }
)
```

##  集群的密码配置(先看完上面的)
1. linux 命令行：openssl rand -base64 741 > mongodb-keyfile
2. linux 命令行： chmod 600 mongodb-keyfile
3. https://docs.mongodb.org/manual/tutorial/configure-ssl/ mongos认证
4. mongos.conf的配置
```
	net:
		port: 20000
		bindIp: 127.0.0.1

	processManagement:
		pidFilePath: /data0/mongod/mongos.pid
		#fork: true

	#storage:
	#    dbPath: /data0/mongod/data/mongos
	#    directoryPerDB: true

	systemLog:
		destination: file
		path : /data0/mongod/log/mongos/mongodb.log
		logAppend: true

	sharding:
		configDB: configServer1:27000,configServer2:28000,configServer3:29000
	#replication:
	#    replSetName: rs0
	#    oplogSizeMB: 1000
	security:
	#    authorization: enabled
		keyFile: mongodb-keyfile
	安全需要先注释，进入admin添加用户后在打开，和mongodb一样，这里不重复了
	运行:mongos -f mongos.conf
```

5. 将所有的mongod.conf和config.conf 添加上 
```
	 security:
		authorization: enabled
		keyFile: mongodb-keyfile
```

6. mongos.conf只需要添加keyFile,不需要authorization。添加这个之前现在mongos无密码登陆创建用户先
7. 进入mongos到admin
```
	sh.addShard("rs0/xxxxxxxx:27010,xxxxxxxxxxx:27030,xxxxxxxxxxxxxx:27030");
	需要在admin中添加。副本集也要在admin中添加，否则无法添加
	#指定uba分片生效
	db.runCommand( { enablesharding :"uba"});
	#指定数据库里需要分片的集合和片键
	db.runCommand( { shardcollection : "uba.table1",key : {id: 1} } )
```
