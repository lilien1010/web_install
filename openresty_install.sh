#!/bin/bash

src_dir=/usr/local/src
cur_dir=$(cd "$(dirname "$0")"; pwd)

#yum -y install git wget
#yum -y install gcc gcc-c++  make automake autoconf 
yum -y install  pcre pcre-devel
yum -y install openssl openssl-devel

# command -v git >/dev/null 2>&1 || { yum install  git}
# command -v wget >/dev/null 2>&1 || { yum install  wget}
VERSION=1.11.2.2
cd $src_dir

if [ ! -f $src_dir/openresty-$VERSION.tar.gz ]; then 
	wget https://openresty.org/download/openresty-$VERSION.tar.gz
	tar -xvf openresty-$VERSION.tar.gz
fi 
	

cd openresty-$VERSION/
./configure --with-pcre-jit \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-stream \
--without-luajit-lua52

gmake
sudo gmake install

bin_cnt=`grep -c "openresty" /etc/profile`
if [ $bin_cnt -eq 0 ]; then
	echo 'export PATH=/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH' >> /etc/profile
fi
source /etc/profile

cp $cur_dir/init_sh/openresty /etc/init.d/
chkconfig openresty on;
