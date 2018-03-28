#!/bin/sh
#log handle
LOG_DIR=/test_log/cpu/
log_handle()
{
	mkdir -p ${LOG_DIR}
}

TEMP_VALUE=$(cat /sys/class/thermal/thermal_zone0/temp)
#error check
if [ $? -ne 0 ]
then
	log_handle
	echo "FAILURE: can't read thermal temp, please check your dts config."  >>  ${LOG_DIR}/thermal.log
    echo "thermal=failure" >> ${LOG_DIR}/thermal.log
    exit 1
fi

if [ ${TEMP_VALUE} -lt 0 ]
then
	log_handle
	echo "FAILURE: read thermal temp too low, temp: ${TEMP_VALUE}."  >> ${LOG_DIR}/thermal.log
    echo "thermal=failure" >> ${LOG_DIR}/thermal.log
	exit 1
fi
 
if [ ${TEMP_VALUE} -gt 100 ]
then
	log_handle	
	echo "FAILURE: read thermal temp too high, temp: ${TEMP_VALUE}."  >> ${LOG_DIR}/thermal.log
    echo "thermal=failure" >> ${LOG_DIR}/thermal.log
	exit 1
fi 

echo "SUCCESS: ${TEMP_VALUE}"
echo "thermal=success" >> ${LOG_DIR}/thermal.log
