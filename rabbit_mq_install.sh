#!/bin/bash

src_dir=/usr/local/src
cur_dir=$(cd "$(dirname "$0")"; pwd)

#yum -y install git wget
#yum -y install gcc gcc-c++  make automake autoconf 
yum -y install libxslt xmlto
yum -y install libtool autoconf


cd $src_dir
wget wget http://www.erlang.org/download/otp_src_17.3.tar.gz
tar xvf otp_src_17.3.tar.gz
cd otp_src_17.3
./configure --prefix=/usr/local/erlang --enable-hipe --enable-threads --enable-smp-support --enable-kernel-poll
make && make install

	
cd $src_dir
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.0/rabbitmq-server-3.5.0.tar.gz


tar xvzf rabbitmq-server-3.5.0.tar.gz
cd rabbitmq-server-3.5.0
make TARGET_DIR=/usr/local/rabbitmq SBIN_DIR=/usr/local/rabbitmq/sbin MAN_DIR=/usr/local/rabbitmq/man  DOC_INSTALL_DIR=/usr/local/rabbitmq/doc
make TARGET_DIR=/usr/local/rabbitmq SBIN_DIR=/usr/local/rabbitmq/sbin MAN_DIR=/usr/local/rabbitmq/man  DOC_INSTALL_DIR=/usr/local/rabbitmq/doc install 

cd $src_dir 
wget http://hthead.hellotalk.com.s3.amazonaws.com/rabbitmq-c-0.5.2.tar.gz
tar -zxvf rabbitmq-c-0.5.2.tar.gz
cd rabbitmq-c-0.5.2
autoreconf -i && ./configure && make && sudo make install

echo "input yes to install php rabbitmq"
read  num
if [[ $num == "yes" ]]; then
 
 echo "start install php rabbitmq module.........."
cd $src_dir  
wget http://pecl.php.net/get/amqp-1.4.0.tgz
tar zxvf amqp-1.4.0.tgz
cd amqp-1.4.0 
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-amqp && make && sudo make install

else
 echo "skip install php rabbitmq module"
fi

mkdir -p /etc/rabbitmq/

echo "input yes to set up raabitmq config for hellotalk push"
read  num
if [[ $num == "yes" ]]; then
 
 echo "start set up raabitmq config .........."
 
/usr/local/rabbitmq/sbin/rabbitmqctl add_vhost pushHost 
/usr/local/rabbitmq/sbin/rabbitmqctl  add_user lilien 123456
/usr/local/rabbitmq/sbin/rabbitmqctl  set_user_tags lilien  administrator
/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p pushHost  lilien  ".*" ".*" ".*"

/usr/local/rabbitmq/sbin/rabbitmqctl   add_user pushServer 123456
 
/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p / pushServer ".*" ".*" ".*"
/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p / pushServer "push-*" ".*" ".*"
/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p / pushServer "push-*" "push-*" "push-*"

/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p pushHost  pushServer ".*" ".*" ".*"
/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p pushHost  pushServer "push-*" ".*" ".*"
/usr/local/rabbitmq/sbin/rabbitmqctl  set_permissions -p pushHost  pushServer "push-*" "push-*" "push-*"


/usr/local/rabbitmq/sbin/rabbitmq-plugins enable rabbitmq_management
else
 echo "skip install php rabbitmq module"
fi


bin_cnt=`grep -c "rabbitmq" /etc/profile`
if [ $bin_cnt -eq 0 ]; then
	echo 'export PATH=/usr/local/erlang/bin/:/usr/local/rabbitmq/sbin/:$PATH' >> /etc/profile
fi

echo "input 'rabbitmq-server start' to run"
