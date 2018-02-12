#!/bin/bash

yum -y install  kernel-devel ncurses-devel libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel  pcre-devel libtool-libs freetype-devel gd zlib-devel file bison patch mlocate flex diffutils   readline-devel glibc-devel glib2-devel bzip2-devel gettext-devel libcap-devel libmcrypt-devel
yum -y install wget autoconf unzip
cur_dir=$(cd "$(dirname "$0")"; pwd)
user=www
group=www

#create group if not exists
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $group
fi

#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -g $group $user
fi


cd /usr/local/src
src_dir=/usr/local/src
if [ ! -f /usr/local/php/bin/phpize ]; then
	if [ ! -f $src_dir/libmcrypt-2.5.8.tar.gz ]; then 
		cd /usr/local/src
		echo "no php";
		wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz 
	 
	fi 
	if [ ! -d $src_dir/libmcrypt-2.5.8 ]; then
		cd /usr/local/src
		echo "no php"; 
		tar -zxvf libmcrypt-2.5.8.tar.gz;
		./configure
		make && make install
	fi 

	PHP_PATH=/usr/local/src/php-5.5.36
	if [ ! -f $src_dir/php-5.5.36.tar.gz ]; then 
		cd /usr/local/src
		echo "no php";
		wget http://hk2.php.net/distributions/php-5.5.36.tar.gz
	fi 


	if [ ! -d $PHP_PATH ]; then
		cd /usr/local/src
		echo "no php"; 
		tar -zxvf php-5.5.36.tar.gz 
	fi 

	cd $PHP_PATH
	./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc  --with-mysql --enable-tokenizer --enable-fileinfo --with-pdo --with-pdo-mysql  --with-mysqli  --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-zlib-dir --with-bz2 --with-zlib --with-gd --enable-gd-native-ttf --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-discard-path --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl   --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --with-openssl --with-mhash --enable-sockets   --with-xmlrpc --enable-zip --enable-pcntl

	if [ ! -f $PHP_PATH/Makefile ]; then 
		echo "no Makefile ; configure Error"; 
		exit;
	fi 

	make && make install
	
	if [ ! -f /usr/local/php/bin/phpize ]; then
		echo 'make install php failed';
		exit;
	fi
fi
cd /usr/local/src

MEM_PATH=/usr/local/src/memcache-3.0.8
if [ ! -d $MEM_PATH ]; then
	cd /usr/local/src
	echo "no memcache"; 
	wget http://pecl.php.net/get/memcache-3.0.8.tgz
	tar -zxvf memcache-3.0.8.tgz
fi


REDIS_PATH=/usr/local/src/phpredis.zip
if [ ! -e $REDIS_PATH ]; then
	cd /usr/local/src
	echo "no phpredis"; 
	wget https://github.com/nicolasff/phpredis/zipball/master -O phpredis.zip
	unzip phpredis.zip -d ./phpredis
	SUBDIR=`ls /usr/local/src/phpredis/`
	cd /usr/local/src/phpredis/$SUBDIR
	/usr/local/php/bin/phpize
	./configure  --with-php-config=/usr/local/php/bin/php-config --with-zlib-dir
	make &&  make install 
fi

cd $MEM_PATH
/usr/local/php/bin/phpize
./configure --enable-memcache --with-php-config=/usr/local/php/bin/php-config --with-zlib-dir
make &&  make install

#APC_PATH=/usr/local/src/APC-3.1.13
#if [ ! -d $APC_PATH ]; then
#	cd /usr/local/src
#	echo "no memcache"; 
#	wget http://pecl.php.net/get/APC-3.1.13.tgz
#	tar -zxvf APC-3.1.13.tgz
#fi
 
#cd $APC_PATH
#/usr/local/php/bin/phpize
#./configure -enable-api -enable-apc-mmap -with-php-config=/usr/local/php/bin/php-config
#make &&  make install
bin_cnt=`grep -c "/php/bin" /etc/profile`
if [ $bin_cnt -eq 0 ]; then
	echo 'export PATH=$PATH:/usr/local/php/bin/' >> /etc/profile
fi
source /etc/profile

pecl install swoole

cp $cur_dir/init_sh/php-fpm /etc/init.d/
cp $cur_dir/sys_config/php.ini /usr/local/php/etc/
cp $cur_dir/sys_config/php-fpm.conf /usr/local/php/etc/ 
