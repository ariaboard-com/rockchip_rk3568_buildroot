#!/bin/sh
local_flag=0
local test_flag
if [  $? == 0 ]
then
	local_flag=1
fi

if [ ${local_flag} == 1 ]
then
	local random=$(date +%S%s%S)

	local governor=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	local freq_max=/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	local freq_tbl=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
	local freq_cur=/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
	local uuid_random=0
else
	random=$(date +%S%s%S)

	governor=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	freq_max=/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	freq_tbl=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
	freq_cur=/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
	uuid_random=0
fi
 
if [ -e ${governor} ]; then   
		echo "  "	 
		echo "  "	 
		echo "==========Auto Freq Test Start. ===================="
		echo " Change governor to Performance"
		echo performance  > ${governor}    
		sleep 1
		echo "Governor is now:" `cat ${governor}`
		echo "Freq Table:" `cat ${freq_tbl}`
else    
		echo "$governor Not Exist, Please Check A"
		exit 0
fi

freq_nr=`cat ${freq_tbl}  | awk '{print NF}'`
echo "all cpu freq count: ${freq_nr}"

if [ ${local_flag} == 1 ]
then
	local freq_idx=1
	local cnt=1
	local uuid_value
	local temp_value
	local uuid_random_temp
	local temp
else
	freq_idx=1
	cnt=1
fi
	
while true
do
		uuid_value=$(cat /proc/sys/kernel/random/uuid)       
        temp_value=$(echo ${uuid_value} | grep -o '[0-9]\+')
        uuid_random_temp=$(echo ${temp_value} | sed s/[[:space:]]//g)
		temp=$(echo ${uuid_random_temp:0:6})
		uuid_random=${cnt}${temp}
		
		echo "uuid_random : ${uuid_random}"
		let freq_idx=uuid_random%freq_nr
		let freq_idx+=1
		echo "freq_idx is : ${freq_idx}"
		let cnt+=1

		case  "$freq_idx"  in    
			1 ) target_freq=`cat ${freq_tbl}  | awk '{print $1}'`  ;; 
			2 ) target_freq=`cat ${freq_tbl}  | awk '{print $2}'`  ;;
			3 ) target_freq=`cat ${freq_tbl}  | awk '{print $3}'`  ;; 
			4 ) target_freq=`cat ${freq_tbl}  | awk '{print $4}'`  ;;
			5) target_freq=`cat ${freq_tbl}  | awk '{print $5}'`  ;;
			6 ) target_freq=`cat ${freq_tbl}  | awk '{print $6}'`  ;;
			7 ) target_freq=`cat ${freq_tbl}  | awk '{print $7}'`  ;;
			8 ) target_freq=`cat ${freq_tbl}  | awk '{print $8}'`  ;;
			9 ) target_freq=`cat ${freq_tbl}  | awk '{print $9}'`  ;;
			10 ) target_freq=`cat ${freq_tbl}  | awk '{print $10}'`  ;;
			11) target_freq=`cat ${freq_tbl}  | awk '{print $10}'`  ;;
			12) target_freq=`cat ${freq_tbl}  | awk '{print $10}'`  ;;
			13) target_freq=`cat ${freq_tbl}  | awk '{print $10}'`  ;;
			14) target_freq=`cat ${freq_tbl}  | awk '{print $10}'`  ;;
			15) target_freq=`cat ${freq_tbl}  | awk '{print $10}'`  ;;
			* ) echo "Freq_Index OverFlow" ;;
		esac		
		
		cur_freq=`cat ${freq_cur}`
		if [ ${cur_freq} != ${target_freq} ]; then
			echo "echo ${target_freq} >  ${freq_max}"
			echo ${target_freq} > ${freq_max}
			sleep 1 


			cur_freq=`cat ${freq_cur}`
			echo "    cat $freq_cur"
			echo "    $cur_freq"
			

			if [ ${cur_freq} != ${target_freq} ]; then
				echo "==============================Auto Freq Error! CurFreq != TargetFreq=============================="
			exit 0
			fi
		else
			echo "TargetFreq==CurFreq, Do Nothing. "
		fi
				
done
