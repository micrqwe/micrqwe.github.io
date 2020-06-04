# 用到的工作上一些语法

1. DECODE语句，"DECODE"(expr, [search, result]*, default) ，全局简介：
```
举例说明：
现定义一table名为output，其中定义两个column分别为monthid（var型）和sale（number型），若sale值=1000时翻译为	D，=2000时翻译为C，=3000时翻译为B，=4000时翻译为A，如是其他值则翻译为Other；
SQL如下：
Select monthid , decode (sale,1000,'D',2000,'C',3000,'B',4000,'A',’Other’) sale from output
特殊情况：
若只与一个值进行比较
Select monthid ,decode（sale， NULL，‘---’，sale） sale from output
```

2. round() 四舍五入使用，SELECT ROUND(column_name,decimals) FROM table_name
```
参数	描述
column_name    必需。要舍入的字段。
decimals       非必需，默认0，返回int。规定要返回的小数位数
```

3. sql结合以上2点防止生成百分比防止除数是0
```
decode(xx, 0, 0, to_char(round(ddd / xxx * 100, 2), 'fm990.99'))
```