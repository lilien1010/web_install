#!/bin/bash

yum install -y libtool
yum install -y gcc make gcc-c++ openssl openssl-devel
src_dir=/usr/local/src
work_dir=/usr/local/redis
cur_dir=$(cd "$(dirname "$0")"; pwd)
#
cd /usr/local/src
red_version=3.2.0
if [ ! -e $src_dir/redis-$red_version.tar.gz  ]; then 
	cd /usr/local/src
	wget http://download.redis.io/releases/redis-$red_version.tar.gz
fi 


if [ ! -d $src_dir/redis-$red_version ] ; then
		tar -zxvf redis-$red_version.tar.gz
fi 
	
cd  redis-$red_version

make && make install
if [ ! -d $work_dir ] ; then
	mkdir -p /usr/local/redis
fi
cp ./src/redis-server $work_dir
cp ./src/redis-cli $work_dir
cp ./src/redis-sentinel $work_dir
cp ./src/redis-check-aof $work_dir
cp ./src/redis-benchmark $work_dir
cp ./src/redis-sentinel $work_dir

echo "export PATH=\$PATH:$work_dir" >> /etc/profile
source /etc/profile
mkdir -p /var/log/redis
cp $cur_dir/sys_config/redis.conf $work_dir
cp $cur_dir/init_sh/redis /etc/init.d/ 
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
chkconfig --add redis
chkconfig --level 3 redis on
chkconfig --level 5 redis on 

