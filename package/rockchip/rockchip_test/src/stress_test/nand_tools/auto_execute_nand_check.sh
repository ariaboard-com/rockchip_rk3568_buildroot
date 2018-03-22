#!/bin/sh /etc/rc.common
# /init.d/auto_execute_nand_check.sh
#------------------------------------------------
#### auto run Nand_test_v1_0.sh when reboot
#### author: <yuegui.he@amlogic.com>
#### creat data: 2017.03.29
#------------------------------------------------

START=50

start()
{
		#sleep 8 sec waiting for system ready
		sleep 8
        FLAG_FILE=/nand_tools/auto_execute_nand_test_tools

        if [ -f ${FLAG_FILE} ]
        then
		read -t 3 BREAK_FLAG
		if [ $? -eq 0  ]
		then
		rm ${FLAG_FILE}
		    sync
		    exit 0
		else
            	    sh /nand_tools/Nand_test_tools.sh
		fi
        fi
}

