# nginx日常使用
 1. 使用

### 在上传图片时候，使用电脑浏览器未有错误，手机客户端浏览器会抛错。nginx缓存大小
 ```
   astcgi_buffers 32 8k;
   client_body_buffer_size 1024k;
   client_max_body_size 10m;
   nginx http.conf  http中
 ```

### nginx proxy_pass

1. 问题：no resolver defined to resolve xxx.xxx
  * 原因是Nginx0.6.18以后的版本中启用了一个resolver指令，在使用变量来构造某个server地址的时候一定要用resolver指令来制定DNS服务器的地址。在nginx的配置文件中的http{}部分添加一行resolver 8.8.8.8;即可
   
1. 引申问题 由于resolver加入 8.8.8.8那么域名都会解析到广域网中的ip。 如果需要将域名解析至特定的ip。可以自己搭建一个dns服务器。

* windows中搭建方法： 自行搜索，暂无看到好的解决方案。windows server可以支持
* linux 中搭建方法
```
brew install  dnsmasq
vim /usr/local/etc/dnsmasq.conf  该路径下没有在etc中
vim /etc/dnsmasq.conf

>>把以下注释打开
domain-needed
bogus-priv
cache-size=51200
listen-address=127.0.0.1
resolv-file=/etc/resolv.conf

>> 启动
 /etc/init.d/dnsmasq start  注：默认nobady用户。提示无权限修改上面conf中usre配置。填写对应用户

>> 在nginx配置中增加
location ~ /testa {
      resolver 127.0.0.1;  // 本句
      proxy_pass http://beta.test.com; ＃apache环境
} 
```

