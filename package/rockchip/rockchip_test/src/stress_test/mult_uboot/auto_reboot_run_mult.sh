#!/bin/sh
#chkconfig:2345 80 90
#description:auto ddr window test
#sleep 8 sec waiting for system ready

case "$1" in
    start)
        sleep 1
        
        REBOOT_MULT_CONTROL=/test_plan/mult_uboot/mult_reboot_control.sh
        REBOOT_FLAG_FILE=/test_plan/mult_uboot/reboot_flag
        if [ -f ${REBOOT_FLAG_FILE}  ]
        then
            sh ${REBOOT_MULT_CONTROL}
        fi
        ;;
esac
