#!/bin/bash

yum install -y libtool geoip
src_dir=/usr/local/src
cur_dir=$(cd "$(dirname "$0")"; pwd)
#
cd /usr/local/src

if [ ! -e $src_dir/GeoIP.tar.gz  ]; then 
	cd /usr/local/src
	wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz 
	tar -zxvf GeoIP.tar.gz 
fi 

cd GeoIP-1.4.8/ 
./configure  
aclocal
make && make install
ln -s /usr/local/lib/libGeoIP.so* /lib64/

if [ ! -e $src_dir/luarocks-2.2.1.tar.gz ]; then 
	cd /usr/local/src
	wget http://luarocks.org/releases/luarocks-2.2.1.tar.gz;
	tar zxpf luarocks-2.2.1.tar.gz;
fi  
cd $src_dir
cd luarocks-2.2.1;

./configure --prefix=/usr/local/luarocks --with-lua=/usr --with-lua-lib=/usr/local/luajit/lib --rocks-tree=/usr/local --with-lua-include=/usr/local/luajit/include/luajit-2.0;
  
sudo make bootstrap;

echo "export PATH=\$PATH:/usr/local/luarocks/bin" >>  /etc/profile

echo 'export LUA_PATH="./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib64/lua/5.1/?.lua;/usr/lib64/lua/5.1/?/init.lua;/usr/local/share/lua/5.1/?.lua;"'>>  /etc/profile

echo 'export LUA_CPATH="./?.so;/usr/lib64/lua/5.1/?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib64/lua/5.1/loadall.so"' >>  /etc/profile
cp -r  /usr/local/luarocks/share/lua  /usr/local/share
source /etc/profile
luarocks install lua-cjson;
luarocks install sockets
luarocks install lua-geoip

cp  $cur_dir/lib_so/lua/* /usr/local/lib/lua/5.1/
cp -r $cur_dir/lib_so/lua/geoip /usr/local/lib/lua/5.1/
