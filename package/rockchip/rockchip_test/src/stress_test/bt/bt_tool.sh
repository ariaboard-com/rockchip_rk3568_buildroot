#!/bin/sh
killall sampleapp
killall bsa_server
bsa_dir="/etc/bsa/config"

HW_PLATFORM=$(cat /proc/device-tree/amlogic-dt-id | awk -F "_" '{print $2}')
if [ "${HW_PLATFORM}" == "s400" ];then
hcd_file="/etc/wifi/6255/BCM4345C0.hcd"
elif [ "${HW_PLATFORM}" == "s420" ];then
hcd_file="/etc/wifi/4356/bcm4356a2.hcd"
fi
echo "hcd_file = $hcd_file"

cd /etc/bsa/config
echo 0 > /sys/class/rfkill/rfkill0/state
sleep 1
echo 1 > /sys/class/rfkill/rfkill0/state
sleep 1
bsa_server -r 13 -d /dev/ttyS1 -p $hcd_file -all=0 -b ${bsa_dir}/btsnoop.log &
sleep 2

insmod /usr/lib/bthid.ko
sed -i s/#desktop-buffer-mode=backsystem/desktop-buffer-mode=backsystem/g /etc/directfbrc
export QT_QPA_PLATFORM=directfb:fb=/dev/fb0
if [ $1 = "debug" ];then
sampleapp > ${bsa_dir}/bt.log
else
sampleapp > /dev/null
fi

lsmod | grep bthid > /dev/null
if [ $? -eq 0 ];then
rmmod bthid
fi
cd -
