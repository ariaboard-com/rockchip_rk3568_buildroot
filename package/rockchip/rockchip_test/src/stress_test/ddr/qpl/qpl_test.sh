#!/bin/sh

DDR_DIR=/test_plan/ddr/qpl
chmod 777 ${DDR_DIR}/test.wav
${DDR_DIR}/ddr_test_arm 0xa000000 l &

for i in `seq 100000`  
do  
    echo "play time" $i 
    aplay ${DDR_DIR}/test.wav
    ps > ${DDR_DIR}/log.txt
	cat ${DDR_DIR}/log.txt | grep -ri "${DDR_DIR}/ddr_test_arm"
	if [ $? -ne 0 ]
	then 
		echo "reboot ddr_test_arm"  >> ${DDR_DIR}/error_log.txt
		${DDR_DIR}/ddr_test_arm 0xa000000 l &
	fi
done

while true
do
	sleep 5
    	ps > ${DDR_DIR}/log.txt
	cat ${DDR_DIR}/log.txt | grep -ri "${DDR_DIR}/ddr_test_arm"
	if [ $? -ne 0 ]
	then 
		echo "reboot ddr_test_arm"  >> ${DDR_DIR}/error_log.txt
		${DDR_DIR}/ddr_test_arm 0xa000000 l &
	fi	
done

