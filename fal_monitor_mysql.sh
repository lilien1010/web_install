#!/bin/bash

cur_dir=$(cd "$(dirname "$0")"; pwd)

check_dir=/home/work/

mkdir -p $check_dir

cp -r ${cur_dir}/mymon $check_dir

echo '* * * * * /home/work/mymon/mymon  -c /home/work/mymon/etc/mon.cfg >> /home/work/mymon/crontab.log' > /etc/cron.d/mymon 
