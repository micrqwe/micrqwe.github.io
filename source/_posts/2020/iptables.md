# 删除iptables的规则

## 第一种办法
1. iptables -t nat -L -n --line-numbers (|grep [端口/ip]) 查看当前有几条规则
1. iptables -t nat -D PREROUTING 1 删除序列号为1的规则

## 第二种办法（第一种我试过有时候没用）
1. iptables-save >/tmp/somefile
1. vim /tmp/somefile         找到对应的nat规则
1. iptables-restore < /tmp/somefile