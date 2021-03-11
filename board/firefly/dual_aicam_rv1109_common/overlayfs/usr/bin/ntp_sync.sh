#!/bin/sh
NTP_SERVER="pool.ntp.org"

for i in $(seq 1 10)
do
	ntpdate $NTP_SERVER 2>/dev/null
	if [ $? -eq 0 ];then
		hwclock -w
	fi
	sleep 1
done
