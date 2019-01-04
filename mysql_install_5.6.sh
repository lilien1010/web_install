#!/bin/bash

user=mysql
group=mysql

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

cur_dir=$(cd "$(dirname "$0")"; pwd)

data_dir=/htdata/mysql

mkdir -p $data_dir

src_dir=/usr/local/src
bin_dir=/usr/local/mysql
yum install -y git wget
yum install -y gcc gcc-c++  make
yum install –y openssl openssl-devel ncurses ncurses-devel cmake
  
cd $src_dir 
mysql_version="5.6.41"
if [ ! -f $src_dir/mysql-$mysql_version.tar.gz ] ; then 
	wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-$mysql_version.tar.gz 
fi

if [ ! -d $src_dir/mysql-$mysql_version ] ; then
	tar	-zxvf mysql-$mysql_version.tar.gz
fi

if [ ! -e $bin_dir/bin/mysqld_safe ] ; then
	cd $src_dir/mysql-$mysql_version
	cmake . -DCMAKE_INSTALL_PREFIX=$bin_dir -DMYSQL_DATADIR=$data_dir -DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=$data_dir/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci

	make && make install
fi

if [ ! -e $bin_dir/bin/mysqld_safe ] ; then
	echo "fail to install mysql"
	exit;
fi
 
cd $data_dir
chown -R mysql $data_dir
chgrp -R mysql .

cp $bin_dir/support-files/mysql.server /etc/init.d/mysqld
#cp $cur_dir/init_sh/mysqld /etc/init.d/
cp $cur_dir/sys_config/my.cnf /etc/
chown root.root /etc/rc.d/init.d/mysqld 


cd $bin_dir 
chown -R root .  
scripts/mysql_install_db --user=mysql
$bin_dir/bin/mysqld_safe --user=mysql

$bin_dir/bin/mysqladmin -u root password '123456'  
 
chkconfig --add mysqld   
chkconfig --level 3 mysqld on
chkconfig --level 5 mysqld on 

mysql_bin_cnt=`grep -c mysql /etc/profile`
if [ $mysql_bin_cnt -gt 0 ] ; then
	echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
	source /etc/profile
fi
mysql -u root -p -e "SET PASSWORD FOR 'root'@'localhost'=PASSWORD('123456');"
