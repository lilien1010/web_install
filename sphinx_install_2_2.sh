#!/bin/bash

yum install libtool
yum install gcc make gcc-c++ openssl openssl-devel
src_dir=/usr/local/src
rc_dir=/usr/local/src
cur_dir=$(cd "$(dirname "$0")"; pwd)
#http://sphinxsearch.com/downloads/sphinx-2.2.11-release.tar.gz/thankyou.htm
cd /usr/local/src
VERSION=2.2.11
if [ ! -e $src_dir/sphinx-$VERSION-release.tar.gz  ]; then 
	cd /usr/local/src
	wget http://sphinxsearch.com/files/sphinx-$VERSION-release.tar.gz
	tar -zxvf sphinx-$VERSION-release.tar.gz
fi 

cd  sphinx-$VERSION-release
./configure -prefix=/usr/local/sphinx
make && make install

if [ ! -f /usr/local/sphinx/etc/sphinx.conf ]; then 
 cp $cur_dir/sys_config/sphinx.conf /usr/local/sphinx/etc/
fi 

if [ ! -f /etc/init.d/sphinx ]; then 
	cp $cur_dir/init_sh/sphinx /etc/init.d/
fi

