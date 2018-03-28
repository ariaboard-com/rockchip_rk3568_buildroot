#!/bin/sh

RESULT_DIR=/data/cfg/rockchip_test/cpu
RESULT_LOG=${RESULT_DIR}/cpu_hotplut.log

#cpu info check
CPU_COUNT=0
echo "**************************************"
echo "the current cpu status:"
while [ ${CPU_COUNT} -lt 4  ]
do
    on_off_check=`cat /sys/devices/system/cpu/cpu${CPU_COUNT}/online`
    echo "cpu${CPU_COUNT}: ${on_off_check}"
    let CPU_COUNT+=1
done
echo "**************************************"


mkdir -p ${RESULT_DIR}
echo "**********************CPU HOTPLUG TEST****************************"  > ${RESULT_LOG}
echo "######## cpu hotplug #######"
sleep 2

:<<!
# interaction test 

echo "######## cpu hotplug #######"
echo "you want operation which cpu"
echo "cpu0  cpu1  cpu2  cpu3"
echo "###########################"

echo "please input which cpu: eg : 1"

read -t 30 CPU_NUMBER

cpu_value_all_handle()
{
	cpu_t1=`cat /sys/devices/system/cpu/cpu$1/online`
	cpu_t2=`cat /sys/devices/system/cpu/cpu$2/online`
	cpu_t3=`cat /sys/devices/system/cpu/cpu$3/online`
	
	let cpu_t1+=cpu_t2
	let cpu_t1+=cpu_t3
	if [ ${cpu_t1} -eq 0 ]
	then
		echo "cpu$1:0 cpu$2:0 cpu$3:0" >> ${RESULT_LOG}
		echo "you can't set cpu$4:0"   >> ${RESULT_LOG}
		sync
		cat ${RESULT_LOG}
		exit 0
	fi
}

case ${CPU_NUMBER} in
	0)
		cpu_value_all_handle 1 2 3 0
		;;
	1)
		cpu_value_all_handle 0 2 3 1
		;;
	2)
		cpu_value_all_handle 0 1 3 2
		;;
	3)
		cpu_value_all_handle 0 1 2 3
		;;
	*)
		;;
esac

echo "**********************"
echo "off   :   0"
echo "on    :   1"
echo "**********************"
echo "please input off or on: eg : 0"
read -t 30  CPU_ON_OFF

check_value()
{
    local_value=`cat /sys/devices/system/cpu/cpu$1`
	
}

#error check
on_off_value=`cat /sys/devices/system/cpu/cpu${CPU_NUMBER}/online`
echo "on value: ${on_off_value}"
if [ ${on_off_value} -eq  ${CPU_ON_OFF} ]
then
	echo "reset cpu${CPU_NUMBER} failure."
	echo "cpu${CPU_NUMBER} is ${on_off_value}, please reset your value."
    echo  "cpu_hotplug=failure" > ${RESULT_LOG}
else
	echo ${CPU_ON_OFF} > /sys/devices/system/cpu/cpu${CPU_NUMBER}/online
	if [ $? -ne 0 ]
	then
    	echo "cpu_hotplug=failure" >> ${RESULT_LOG}
	else
    	echo "cpu_hotplug=success" >> ${RESULT_LOG}
	fi
fi
!

ERR=0
ALL_ERR=0
#error check 
error_check()
{
	if [ $1 -ne 0 ]
	then
		echo "$2_$3=failure" >> ${RESULT_LOG}
		let ALL_ERR+=1
	else
		echo "$2_$3=success" >> ${RESULT_LOG}
	fi
}

option_work()
{
	OPTION_NAME=NONE
	case $2 in
		1)
			OPTION_NAME=OPEN		
		;;
		0)
			OPTION_NAME=OFF
		;;
	esac
	
	#error check
	on_off_value=`cat /sys/devices/system/cpu/cpu$1/online`
	if [ ${on_off_value} -eq  $2 ]
	then
		echo "cpu$1_${OPTION_NAME}=failure (cpu$1 value is $2 now. don't to set $2 to cpu$1.)" >> ${RESULT_LOG}
		let ${ERR}+=1
	else
		echo $2 > /sys/devices/system/cpu/cpu$1/online
		if [ $? -ne 0 ]
		then
			echo "cpu$1_${OPTION_NAME}=failure" >> ${RESULT_LOG}
			let ${ERR}+=1
		fi
	fi	
}

# off cpu
option_cpu()
{
	echo "cpu:    $1"
	echo "option: $2"
	case $2 in
		"on")
			option_work $1 1 
			;;
		"off")
			option_work $1 0
			;;
		*)
			echo "not fount this option."
		;;
	esac
}

one_cpu_pressure_option()
{
	cpu_arr="0 1 2 3"
	for data in ${cpu_arr}
	do
		option_cpu ${data} off
		option_cpu ${data} on
	done
}

#case 1: one cpu
one_cpu_pressure()
{
	count=0
	test_count=100
	ERR=0
	echo "one cpu pressure 100 count: ing"
	sleep 2
	while [  ${count} -lt ${test_count} ]
	do
		one_cpu_pressure_option
		let count+=1
	done
	
	error_check ${ERR} one_cpu_pressure  ${test_count}
}

two_cpu_pressure_option()
{
	option_cpu $1 off
	option_cpu $2 off
	
	option_cpu $1 on
	option_cpu $2 on
}

#case 2: two cpu
two_cpu_pressure()
{
	count=0
	test_count=100
	ERR=0
	echo "two cpu pressure 100 count: ing"
	sleep 2	
	while [ ${count} -lt ${test_count} ]
	do
		two_cpu_pressure_option 0 1
		two_cpu_pressure_option 0 2
		two_cpu_pressure_option 0 3
	
		two_cpu_pressure_option 1 2
		two_cpu_pressure_option 1 3
	
		two_cpu_pressure_option 2 3
		let count+=1
	done
	
	error_check ${ERR} two_cpu_pressure  ${test_count}
}

three_cpu_pressure_option()
{
	option_cpu $1 off
	option_cpu $2 off
	option_cpu $3 off
	
	option_cpu $1 on
	option_cpu $2 on
	option_cpu $3 on
}

#case 3: three cpu
three_cpu_pressure()
{
	count=0
	test_count=100
	ERR=0
	echo "one cpu pressure 100 count: ing"
	sleep 2	
	while [ ${count} -lt ${test_count} ]
	do
		three_cpu_pressure_option 0 1 2
		three_cpu_pressure_option 0 1 3
		
		three_cpu_pressure_option 1 2 3
		let count+=1
	done
	
	error_check ${ERR} three_cpu_pressure  ${test_count}
}

pressure_on_off_cpu()
{
	#case 1: one cpu
	one_cpu_pressure
	#case 2: two cpu
	two_cpu_pressure
	#case 3: three cpu
	three_cpu_pressure

	#error check
	if [ ${ALL_ERR} -ne 0 ]
	then
		echo "cpu_hotplug=failure" >> ${RESULT_LOG}
	fi
	
	cat ${RESULT_LOG}
	
}

pressure_on_off_cpu

