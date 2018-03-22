#!/bin/sh
#chkconfig:2345 80 90
#description:auto reboot check nand test

#sleep 8 sec waiting for system ready
sleep 8
FLAG_FILE=/nand_tools/auto_execute_nand_test_tools
if [ -f ${FLAG_FILE} ]
then
	read -t 3 BREAK_FLAG
	if [ $? -eq 0 ]
	then
	    rm ${FLAG_FILE}
	    sync
		exit 0
	else
        sh /nand_tools/Nand_test_tools.sh
    fi
fi
