#!/bin/sh
#chkconfig:2345 80 90
#description:auto reboot

#sleep 8 sec waiting for system ready
sleep 8

DDR_AUTOREBOOT_FLAG=/test_plan/ddr/auto_reboot
REBOOT_COUNT_FILE=${DDR_AUTOREBOOT_FLAG}/reboot_count_file
if [ ! -f ${REBOOT_COUNT_FILE} ]
then
	exit 17
fi

reboot_handle()
{
	read -t 3 BREAK_FLAG
	if [ $? -eq 0 ]
	then
	    rm ${REBOOT_COUNT_FILE}
	    sync
	    exit 0
	else
	    #continue reboot
	    reboot -f
	    fi
}
#read reboot count is 0 or not
current_reboot_count=$(cat ${REBOOT_COUNT_FILE} | awk -F  = '{print $2}')
if [ ${current_reboot_count} -gt 0 ]
then
	#substract reboot count
    let current_reboot_count-=1
	#rewrite reboot count
	echo "reboot_count=${current_reboot_count}" > ${REBOOT_COUNT_FILE}
	#continue reboot
	reboot_handle
elif [  ${current_reboot_count} -eq 0 ]
then
	rm ${REBOOT_COUNT_FILE}
fi

