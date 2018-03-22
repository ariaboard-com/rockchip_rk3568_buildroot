#!/bin/sh

DDR_AUTOREBOOT=/test_plan/ddr/auto_reboot
AUTO_REBOOT_FILE=${DDR_AUTOREBOOT}/auto_reboot_file.sh
REBOOT_COUNT_FILE=${DDR_AUTOREBOOT}/reboot_count_file
echo "please input reboot count!  eg: 1000"
echo "reboot count:"
#input reboot count
read reboot_count

reboot_handle()
{
		cp ${AUTO_REBOOT_FILE} /etc/init.d/S95autoreboot
		sync
}

expr ${reboot_count} + 0 1>/dev/null   2>&1
if [ $? -eq 0 ]; then
		echo   "setting reboot count success!"
		echo "reboot_count=${reboot_count}" >  ${REBOOT_COUNT_FILE}
		reboot_handle
else
		echo   "${reboot_count}   is   not   a   number!"
		exit  12
fi

#subtract reboot count
current_reboot_count=$(cat ${REBOOT_COUNT_FILE} | awk -F  = '{print $2}')
let current_reboot_count-=1

#first reboot subtract reboot_count
echo "reboot_count=${current_reboot_count}" >  ${REBOOT_COUNT_FILE}

#reboot
reboot -f
