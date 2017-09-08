#!/bin/bash
# ------------------------------------------
# Filename:yjianyouhua.sh 
# Revision: 1.0
# Date: 20170810
# Author: 
# Email:
# Website:
# Description:一键优化脚本 
# ------------------------------------------
#"***********************脚本内容如下*********************"
#定义变量
platform=`uname -i`


#判断当前用户是否为root
if [[ "$(whoami)" != "root" ]];then
	echo "Please run this script as root ." 
	exit 1
fi
#判断当前主机是否为64位
if [ $platform != "x86_64" ];then 
	echo "This script is only for 64bit system!"
	exit 1
fi
echo "This platform is ok !"
#创建目录
mkdir -p /app /date 
#备份并添加国内YUM源
mkdir -p /etc/yum.repos.d/old && mv -a /etc/yum.repos.d/* /etc/yum.repos.d/old/
if [ ! -f /etc/yum.repos.d/cobbler-config.repo ];then
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
        rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
fi

sed -i "s/enabled=0/enabled=1/g"   /etc/yum.repos.d/cobbler-config.repo

#清空并重建缓存
yum clean all
yum makecache
#升级并安装必要软件
yum -y update
yum -y upgrade
yum -y install gcc gcc-c++ ntp lrzsz tree telnet dos2unix sysstat sysstat iptraf  ncurses-devel openssl-devel zlib-devel OpenIPMI-tools nmap screen pstree 


#更新系统时间
echo "* 4 * * * /usr/sbin/ntpdate 202.120.2.101 > /dev/null 2>&1" >> /var/spool/cron/root
systemctl restart crond


#设置系统默认语言支持
localectl set-locale LANG=en_US.utf8


#添加系统用户


#sudo权限管理


#设置文件保护
#cat >> /etc/security/limits.conf << EOF
#*           soft   nofile       65535
#*           hard   nofile       65535
#EOF

#关闭SElinux
 sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config


#限制root用户远程SSH连接
#cp /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +"%F %T"`
#sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
#sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
#sed -i 's%#PermitRootLogin yes%PermitRootLogin no%g' /etc/ssh/sshd_config
#sed -i 's%#PermitEmptyPasswords no%PermitEmptyPasswords no%g' /etc/ssh/sshd_config
#sed -i 's%#Port 22%Port 52020%g' /etc/ssh/sshd_config
#systemctl restart sshd
#systemctl enable sshd 



#调整内核参数
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_fin_timeout = 30
vm.swappiness=10
vm.max_map_count = 262144
#关闭ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
#决定检查过期多久邻居条目
net.ipv4.neigh.default.gc_stale_time=120
#使用arp_announce / arp_ignore解决ARP映射问题
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.lo.arp_announce=2
# 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1
# 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1
#关闭路由转发
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
#开启反向路径过滤
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
#处理无源路由的包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
#关闭sysrq功能
kernel.sysrq = 0
#core文件名中添加pid作为扩展名
kernel.core_uses_pid = 1
# 开启SYN洪水攻击保护
net.ipv4.tcp_syncookies = 1
#修改消息队列长度
kernel.msgmnb = 65536
kernel.msgmax = 65536
#设置最大内存共享段大小bytes
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
#timewait的数量，默认180000
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096        87380   4194304
net.ipv4.tcp_wmem = 4096        16384   4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
#每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目
net.core.netdev_max_backlog = 262144
#限制仅仅是为了防止简单的DoS 攻击
net.ipv4.tcp_max_orphans = 3276800
#未收到客户端确认信息的连接请求的最大值
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
#内核放弃建立连接之前发送SYNACK 包的数量
net.ipv4.tcp_synack_retries = 1
#内核放弃建立连接之前发送SYN 包的数量
net.ipv4.tcp_syn_retries = 1
#启用timewait 快速回收
net.ipv4.tcp_tw_recycle = 1
#开启重用。允许将TIME-WAIT sockets 重新用于新的TCP 连接
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
#当keepalive 起用的时候，TCP 发送keepalive 消息的频度。缺省是2 小时
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 15
#允许系统打开的端口范围
net.ipv4.ip_local_port_range = 1024    65000
#修改防火墙表大小，默认65536
net.netfilter.nf_conntrack_max=655350
net.netfilter.nf_conntrack_tcp_timeout_established=1200
# 确保无人能修改路由表
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
EOF
#从指定文件加载系统参数
/sbin/sysctl -p 



#禁用防火墙
#systemctl   stop firwalld     
#systemctl   disable  firwalld 


#设置主机名
#hostnamectl   set-hostname   admin  


#禁用ipv6
#cat > /etc/modprobe.d/ipv6.conf << EOF
#alias net-pf-10 off
#options ipv6 disable=1
#EOF
#echo "NETWORKING_IPV6=off" >> /etc/sysconfig/network

#定制登录提示符
#modify PS1
echo 'export PS1="[ \033[01;33m\u\033[0;36m@\033[01;34m\h \033[01;31m\w\033[0m ]\033[0m \n#"' >> /etc/profile
echo "the platform is ok"


#定制vim配置
#modify vimrc
cat >> /root/.vimrc << EOF
syntax enable
syntax on
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch
set incsearch
set ignorecase
set nocompatible
set wildmenu
set paste
set nowrap
set expandtab
set tabstop=2
set shiftwidth=4
set softtabstop=4
set gcr=a:block-blinkon0
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white 
EOF





#重启生效
reboot



	







