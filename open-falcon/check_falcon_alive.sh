#!/bin/sh

LOCAL_IP=`/sbin/ifconfig |grep -v '127.0.0.1' |awk '/inet/{print $2}' | awk -F: '{print $2}'`

MOBILE=13158852006
ALARM=/var/checkserver/sms.php

P1="falcon-agent"

check_alive()
{
	TARGET=$1
	CNT=$2
	result=`ps -ewf|grep "$TARGET"|grep -wv grep|grep -wv vi | grep -wv tail | grep -wv check_alive | grep -v "\.sh" | grep -v "/alarm " | wc -l `
	#echo "$TARGET: $result"
	if [ "$result" -ne "$CNT"  ]
	then
	    echo "$TARGET: $result != $CNT"
		cd /home/work/open-falcon/agent
		./control restart
		NOW_TIME=`date`
		echo "Fatal: $TARGET down $result $NOW_TIME" >> down.log
		$ALARM -c"Process[$TARGET] down time[$NOW_TIME] ip[$LOCAL_IP]" -t"$MOBILE"
	fi
}


check_alive $P1 1
