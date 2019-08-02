#!/bin/sh

delay=10
total=${1:-10000}
fudev=/dev/sda
CNT=/data/cfg/rockchip_test/reboot_cnt

if [ ! -e "/data/cfg/rockchip_test" ]; then
	echo "no /data/cfg/rockchip_test"
	mkdir /data/cfg/rockchip_test
fi

if [ ! -e "/data/cfg/rockchip_test/auto_reboot.sh" ]; then
	cp /rockchip_test/auto_reboot/auto_reboot.sh /data/cfg/rockchip_test
fi

if [ ! -e "/etc/init.d/S99_auto_reboot" ]; then
	echo "create S99_auto_reboot"
	touch /etc/init.d/S99_auto_reboot
	chmod 755 /etc/init.d/S99_auto_reboot
	cat >> /etc/init.d/S99_auto_reboot <<EOF
	case "\$1" in
	  start)
		source /rockchip_test/auto_reboot/auto_reboot.sh $total&
		;;
	  stop)
		printf "stop finished\n"
		;;
	  *)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
	esac
	exit 0
EOF
fi

while true
do

#if [ ! -e "$fudev" ]; then
#    echo "Please insert a U disk to start test!"
#    exit 0
#fi

if [ -e $CNT ]
then
    cnt=`cat $CNT`
else
    echo reset Reboot count.
    echo 0 > $CNT
fi

echo  Reboot after $delay seconds.

let "cnt=$cnt+1"

if [ $cnt -ge $total ]
then
    echo AutoReboot Finisned.
    echo "off" > $CNT
    echo "do cleaning ..."
    rm -rf /data/cfg/rockchip_test/auto_reboot.sh
    rm -f $CNT
    rm /etc/init.d/S99_auto_reboot
    exit 0
fi

echo $cnt > $CNT
echo "current cnt = $cnt, total cnt = $total"
echo "You can stop reboot by: echo off > /data/cfg/rockchip_test/reboot_cnt"
sleep $delay
cnt=`cat $CNT`
if [ $cnt != "off" ]; then
    if [ -e /sys/fs/pstore/ ]; then
        echo "check console-ramoops-o message"
        grep -q "Restarting system" /sys/fs/pstore/console-ramoops-0
        if [ $? -ne 0 -a $cnt -ge 2 ]; then
           echo "no found 'Restarting system' log in last time kernel message"
           echo "consider kernel crash in last time reboot test"
           echo "quit reboot test"
	   exit 1
        else
	   reboot
        fi
    else
	   reboot
    fi
else
    echo "Auto reboot is off"
    rm -rf /data/cfg/rockchip_test/auto_reboot.sh
    rm /etc/init.d/S99_auto_reboot
    rm -f $CNT
fi
exit 0
done
