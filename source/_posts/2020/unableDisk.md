# 双系统下ubuntu无法查看windows硬盘
```
  ## 错误提示
   Error mounting /dev/sdb4 at /media/xxx/xx: Command-line`mount -t "ntfs" -o"uhelper=udisks2,nodev,nosuid,uid=1000,gid=1000,dmask=0077,fmask=0177""/dev/sdb4" "/media/eden/文檔"' exited with non-zero exit status14: The disk contains an unclean file system (0, 0).
```
## 解决办法
```
１、打开终端，输入sudo fdisk -l 可列出所有的分区情况，找到自己windows硬盘的分区；
  设备 启动      起点          终点     块数   Id  系统
/dev/sda1   *          63   163846934    81923436    7  HPFS/NTFS/exFAT
分区 1 未起始于物理扇区边界。
/dev/sda2       163846996   859797503   347975254    f  W95 扩展 (LBA)
分区 2 未起始于物理扇区边界。
/dev/sda5       163846998   404500634   120326818+   7  HPFS/NTFS/exFAT

2、得知分区为：/dev/sdb4，创建挂载目录：

sudo mkdir /media/xxx/yyy          (xxx为用户名，yyy为挂载的硬盘的名字)
３、挂载硬盘：

mount -t ntfs-3g  /dev/sdb4  /media/xxx/yyy/ -o force

４、还是不行，网上一搜，用以下命令，大功告成：

sudo ntfsfix /dev/sdb6
```