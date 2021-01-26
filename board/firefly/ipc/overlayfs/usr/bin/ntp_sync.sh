NTP_SERVER="pool.ntp.org"

ntpdate $NTP_SERVER
if [ $? -eq 0 ];then
	hwclock -w
fi
