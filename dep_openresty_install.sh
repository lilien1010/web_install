#!/bin/bash

src_dir=/usr/local/src
cur_dir=$(cd "$(dirname "$0")"; pwd)


cd $src_dir
git clone https://github.com/lilien1010/lpack.git
cd lpack
gcc lpack.c -fPIC -shared -o lpack.so -Wall -I/usr/local/openresty/luajit/include/luajit-2.1 -L/usr/local/openresty/luajit/lib/  -lluajit-5.1

cp lpack.so -i /usr/local/openresty/luajit/lib/lua/5.1/pack.so

cd $src_dir
git clone  https://github.com/lilien1010/lua-zlib.git
cd  lua-zlib
make linux
cp zlib.so  -i /usr/local/openresty/luajit/lib/lua/5.1/

cd $src_dir
git clone https://github.com/lilien1010/pbc.git
cd pbc
make
cd binding/lua
make
cp protobuf.so  -i /usr/local/openresty/luajit/lib/lua/5.1/

yum install libtool -y
aclocal

cd $src_dir
git clone --recursive https://github.com/maxmind/libmaxminddb
cd libmaxminddb
./bootstrap
./configure
make
make check
sudo make install
sudo ldconfig
ln -s /usr/local/lib/libmaxminddb.so.0 /lib64/

cd /home/git/webapi/lua/lib/maxmind
gcc maxminddb.c -fPIC -shared -o maxminddb.so -Wall -I/usr/local/include -I/usr/local/openresty/luajit/include/luajit-2.1 -L/usr/local/openresty/luajit/lib/ -L/usr/local/lib  -lluajit-5.1 -lmaxminddb
mv  -i maxminddb.so ../

cd /home/git/webapi/lua/lib/libteacrypto
gcc xteacrypt.c -fPIC -shared -o xteacrypt.so -Wall -I/usr/local/openresty/luajit/include/luajit-2.1 -L/usr/local/openresty/luajit/lib/  -lluajit-5.1  
mv  -i xteacrypt.so ../


echo '同时要修改nginx 配置里面的 cpath'
echo  'lua_package_path "/home/git/webapi/lua/?.lua;/home/git/webapi/lua/lib/gprotobuf/?.lua;;"';
echo 'lua_package_cpath "/home/git/webapi/lua/?.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so;;"';


