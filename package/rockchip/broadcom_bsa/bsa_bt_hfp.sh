#!/bin/sh

hcd_file="BTFIRMWARE_PATH"
echo "hcd_file = $hcd_file"

mkdir -p /userdata/bsa/config/
cd /userdata/bsa/config/
echo 0 > /sys/class/rfkill/rfkill0/state
sleep 1
echo 1 > /sys/class/rfkill/rfkill0/state
sleep 1
bsa_server -d /dev/ttyS4 -p $hcd_file -r 13 -b /userdata/btsnoop.cfa > /userdata/bsa/bsa_log.txt &
sleep 1
app_manager
