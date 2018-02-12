#!/bin/bash

yum install libtool
yum install gcc make gcc-c++ openssl openssl-devel
src_dir=/usr/local/src
rc_dir=/usr/local/src
cur_dir=$(cd "$(dirname "$0")"; pwd)
#
cd /usr/local/src

if [ ! -e $src_dir/sphinx-2.1.7-release.tar.gz  ]; then 
	cd /usr/local/src
	wget http://sphinxsearch.com/files/sphinx-2.1.7-release.tar.gz
	tar -zxvf sphinx-2.1.7-release.tar.gz
fi 

cd  sphinx-2.1.7-release
./configure -prefix=/usr/local/sphinx
make && make install

cp $cur_dir/sys_config/sphinx.conf /usr/local/sphinx/etc/
cp $cur_dir/init_sh/sphinx /etc/init.d/ 


