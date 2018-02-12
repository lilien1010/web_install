#!/bin/bash

cur_dir=$(cd "$(dirname "$0")"; pwd)

check_dir=/home/work/

mkdir -p $check_dir

cp -r ${cur_dir}/falcon-monit-scripts $check_dir

echo '* * * * * /usr/bin/python /home/work/falcon-monit-scripts/redis/redis-monitor.py' > /etc/cron.d/fal_mon_redis
