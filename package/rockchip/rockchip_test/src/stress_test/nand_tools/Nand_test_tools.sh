#!/bin/sh
WORK_DIR=$(pwd)
#echo $WORK_DIR
Platform=A111
#ERROR_LOG_FILE=/nand_tools/error_log.txt
ERROR_LOG_NAND=/test_log/nand
ERROR_LOG_FILE=/test_log/nand/error_log_0.txt

mkdir -p ${ERROR_LOG_NAND}

error_log_file_handle()
{
	#read log count
	LOG_COUNT_FILE=${ERROR_LOG_NAND}/log_count
	if [ ! -f  ${LOG_COUNT_FILE} ]
	then
		echo 0 > ${LOG_COUNT_FILE}
	fi

	LOG_COUNT=$(cat ${LOG_COUNT_FILE})
	ERROR_LOG_FILE=${ERROR_LOG_NAND}/error_log_${LOG_COUNT}.txt
	STATBILIEY_FILE_HANDLE=/nand_tools/stability_all_count
	if [ ! -f ${STATBILIEY_FILE_HANDLE} ]
	then
		let LOG_COUNT+=1
		echo ${LOG_COUNT} > ${LOG_COUNT_FILE}
		ERROR_LOG_FILE=${ERROR_LOG_NAND}/error_log_${LOG_COUNT}.txt
	fi	
}

error_log_file_handle

###################################################export env(begain)########################################################
export_error_env(){
		export FUNCTION_ERR=0
		export PRESSURE_ERR=0
		export STABILITY_ERR=0
		export BOOTLOADER_ERR=0
		export ENV_ERR=0
		export KEY_ERR=0
		export DTB_ERR=0
		export SYSTEM_ERR=0
		export LINUX_VERSION=$(cat /proc/version | grep -E "Linux version" | awk -F " " '{print $3}' | awk -F "-" '{print $1}')
}
###################################################export env(end)########################################################


#####################################################error handle(begain)#############################################
# Error count
ERR=0
error_print()
{
	echo "NAND TEST VERSION: Nand_test_tools_v1.0           " >> ${ERROR_LOG_FILE}
	echo "            " >> ${ERROR_LOG_FILE}
	echo "---------------------------------" >> ${ERROR_LOG_FILE}
	cat ${ERROR_LOG_FILE}
}
#####################################################error handle(end)#################################################

#input param and 

#./$(WORK_DIR)/

#identify which platform
#echo "your platform is A111"
####################################################mount usb deviece(begain)##########################################
sda_mount()
{
		local USB_DEVICE=/dev/$1
		local count=$2
		#first check $1
		#check /dev/$1 exist or not
		local i=1
		ls ${USB_DEVICE}
		while [ $? -ne 0 ];do
			echo "please insert your usb storage device"
			sleep 1
			if [ $i -gt ${count} ]
			then
				i=1
				return $i
			fi
			let i+=1
			ls ${USB_DEVICE}
		done

		#exit 1

		#mkdir usb mount point
		umount /usb_mount
		rm -rf /usb_mount
		mkdir /usb_mount
		local g=1
		mount ${USB_DEVICE} /usb_mount		
		
		#sure mount usb device is ok
		while [ $? != 0 ]; do
			echo "mount usb storage device : failure!!!"
			sleep 1
			if [ $g -gt ${count} ]
			then
				g=2
				return $g 
			fi
			let g+=1
			mount ${USB_DEVICE} /usb_mount
		done
		return 0
}
usb_storage_mount()
{
	sda_mount sda 2
	if [ $? -ne 0 ]
	then 
		sda_mount sda1  2
		if [ $? -ne 0 ]
		then
			echo "you can't insert your storage device"	
			return  100
		fi
	fi
	echo "mount usb storage device : successfull!"
	return 0
}
####################################################mount usb deviece(end)#############################################

#####################################################function test(begain)##############################################
# Error count
ReadWrite_Mtd_partition()
{
	echo "mtdblock*: $1"
	echo "partition name: $2"
	
	sync
	#read
	dd if=/dev/$1 of=/usb_mount/${1}_read
	sync
	#write
	dd if=/usb_mount/${1}_read of=/dev/$1
	#sync
	sync
	#read
	dd if=/dev/$1 of=/usb_mount/${1}_write
	sync
	# usleep 0.010s for data sync to nand
	usleep 10000
	
	diff  /usb_mount/${1}_read  /usb_mount/${1}_write
	if [ $? != 0 ]
	then
		let ERR+=1
		echo "$2 parttion (read file and write file) is different: $2 partition  error!!!" >> ${ERROR_LOG_FILE} 
	else
		echo "$2 partition : successfull!"
	fi			
}

ReadWrite_flashByMTD()
{
	#mount usb storage device
	usb_storage_mount

	#can't dd partition arr
	#disable_partition_arr=["bootloader"]
	local DISABLE_PARTITION="bootloader" 
	#statistics mtd partition  
	local MTD_PARTITION_COUNTS=$(cat /proc/mtd  | grep -o 'mtd' | wc -l)
	local int=0
	echo ${MTD_PARTITION_COUNTS} ${int}
	#while (( ${int} < ${MTD_PARTITION_COUNTS} ))
	while [ ${int} -lt ${MTD_PARTITION_COUNTS} ]
	do
		echo "operation /dev/mtdblock${int}"
		local MTDBLOCK="mtdblock${int}"
		local PARTITION_NAME=$(cat /proc/mtd  | grep -E "mtd${int}" | sed -r 's/.*\"(.+)\".*/\1/')
		if [ "${DISABLE_PARTITION}"x ==  "${PARTITION_NAME}"x ]
		then
			echo "bootloader can't read and write"
		else 
			ReadWrite_Mtd_partition  ${MTDBLOCK}  ${PARTITION_NAME}
		fi
		
		let  int+=1
	done
}

# write string to ubi system
WriteString_ToUbisystem()
{
	echo "$1"
	echo "mtdblock$2"
	echo $1 > /ubi_mount/ubi_test.txt
	sync
	local STRING=$(cat /ubi_mount/ubi_test.txt)
	if [ ${STRING} -ne $1 ]
	then
		echo "mtdblock$2 write and read error!" >>  ${ERROR_LOG_FILE}
	else 
		echo "mtdblock$2 write and read: successfull!"
	fi
	
	#dete /ubi_mount/ubi_test.txt
	rm /ubi_mount/ubi_test.txt
}

#ubi count
ubi_count=1

Readwrite_ubisystem()
{
	echo "mount mtdblock$1"
	echo "partition name: $2"
	
	
	##########################ubiattach flow(begain)###################################
	#contact /mtdblock$1 with $1
	ubiattach  /dev/ubi_ctrl -m $1
	if [ $? -ne 0 ]
	then 
		echo "partition :${2}" >> ${ERROR_LOG_FILE}
		echo "ubiattach /dev/ubi_ctrl -m $1: failure!!!" >> ${ERROR_LOG_FILE}
		return $1
	fi
	
	#dev number
	local MAJOR=$(cat  sys/class/ubi/ubi${ubi_count}/dev | awk -F ":" '{print $1}')
	#mknod 
	mknod /dev/ubi${ubi_count}_0 c ${MAJOR} 1
	if [ $? -ne 0 ]
	then
		echo "partition :${2}" >> ${ERROR_LOG_FILE}
		echo "mknode /dev/ubi${ubi_count}_0 c ${MAJOR} 1: failure!!!" >> ${ERROR_LOG_FILE}
		ubidetach /dev/ubi_ctrl -m $1
		#error code
		return ${1}+6
	fi
	#mkvol
	ubimkvol  /dev/ubi${ubi_count} -s 3MiB -N ${2}_ubi_vol
	if [ $? -ne 0 ]
	then
		echo "partition :${2}" >> ${ERROR_LOG_FILE}
		echo "ubimkvol  /dev/ubi${ubi_count} -s 3MiB -N ${2}_ubi_vol : failure!!!" >> ${ERROR_LOG_FILE}
		ubidetach /dev/ubi_ctrl -m $1
		return ${1}+12
	fi
	
	#mount ubi system
	mount -t ubifs /dev/ubi${ubi_count}_0 /ubi_mount
	if [ $? -ne 0 ]
	then
		echo "partition :${2}" >> ${ERROR_LOG_FILE}
		echo "mount -t ubifs /dev/ubi${ubi_count}_0 /ubi_mount : failure!!! " >> ${ERROR_LOG_FILE}
		ubirmvol /dev/ubi${ubi_count} -N ${2}_ubi_vol
		ubidetach /dev/ubi_ctrl -m $1
		return ${1}+18
	fi
	##########################ubiattach flow(end)########################################
	
	
	#operation ubisystem 
	WriteString_ToUbisystem ${ubi_count} $1
	
	
	##########################ubidetach flow(begain)#####################################
	umount /ubi_mount
	ubirmvol /dev/ubi${ubi_count} -N ${2}_ubi_vol
	ubidetach  /dev/ubi_ctrl -m $1
	##########################ubidetach flow(end)########################################
	
	
	#let ubi_count+=1
}

ReadWrite_userpartition()
{
#exclude partition
local partition_arr=['bootloader','boot','upgrade']

# mount test dir
#umount /ubi_mount
rm -rf /ubi_mount
mkdir /ubi_mount

#statistics mtd partition  
local MTD_PARTITION_COUNTS=$(cat /proc/mtd  | grep -o 'mtd' | wc -l)
local int=0
echo ${MTD_PARTITION_COUNTS} ${int}
#while (( ${int} < ${MTD_PARTITION_COUNTS} ))
while [ ${int} -lt ${MTD_PARTITION_COUNTS} ]
do
	local PARTITION_NAME=$(cat /proc/mtd  | grep -E "mtd${int}" | sed -r 's/.*\"(.+)\".*/\1/')
	echo "${partition_arr}" | grep -q  ${PARTITION_NAME}	
	if [ $? -ne 0 ]
	then
		echo "to here"
		Readwrite_ubisystem ${int} ${PARTITION_NAME}
	fi
	#ReadWrite_Mtd_partition  ${MTDBLOCK}  ${PARTITION_NAME}
	let  int+=1
done
}

operation_nandkey()
{
		#
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo  "key name : $1"
		echo  "key value: $2"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		#write key	
		echo $1 > /sys/class/aml_keys/aml_keys/key_name
		echo "******************************************1"
		echo $2 > /sys/class/aml_keys/aml_keys/key_write
		echo "******************************************2"
		sync
		#read key
		echo $1 > /sys/class/aml_keys/aml_keys/key_name
		local KEY_VALUE=$(cat /sys/class/aml_keys/aml_keys/key_read)
		if [ ${KEY_VALUE} -ne $2 ]
		then
			echo "read and write nandkey $1 failure!!!" >> ${ERROR_LOG_FILE}
		else
			echo "read and write nandkey $1 successfull"
		fi
}

ReadWrite_nandkey()
{
		#set key arr
		set usid mac hdcp secure_boot_set mac_bt mac_wifi
		echo "key list: $*"
		#init nandkey
		echo  auto3 > /sys/class/aml_keys/aml_keys/version
	
		#key value
		local KEY_NAME=""
		local KEY_VALUE="123456789"
		local KEY_NUMBER=$#
		local int=1

		echo "readwrite key"	
		for i in $@
		do
			echo $i
			operation_nandkey $i  ${KEY_VALUE} 
		done
		#dele key arr
		set x;shift
}

ReadWrite_env()
{
		# get fw_setenv
		#ln -s /bin/fw_printenv /fw_setenv
		# write env 
		local ENV_TEST_VALUE="7654321"
		/fw_setenv env_test ${ENV_TEST_VALUE}
	
		sync	
		#read env
		local READ_VALUE=$(fw_printenv env_test | awk -F = '{print $2}')
	
		#compare env value
		if [ ${ENV_TEST_VALUE} -ne ${READ_VALUE} ]
		then	
			echo  "env write value: ${ENV_TEST_VALUE}" >>  ${ERROR_LOG_FILE}
			echo  "env read value : ${READ_VALUE}" >>  ${ERROR_LOG_FILE}
			echo  "env partition read and write value is different: env failure!!!" >>  ${ERROR_LOG_FILE}
		else
			echo  "env read and write test successfull"
		fi
		#dele env
}

ReadWrite_env_value_increase()
{
		local env_error=0

		## create $1 size file
		dd if=$1 of=$2 bs=$3 count=1
		if [ $? -ne 0 ]
		then
			echo "dd if=$1 of=$2 bs=$3 count=1" >> ${ERROR_LOG_FILE}
		fi
		
		#$2 env value
		local ENV_TEST_VALUE=$(cat $2)
		#set env value
		/fw_setenv env_test ${ENV_TEST_VALUE}
		
		sync	
		#read env
		local READ_VALUE=$(fw_printenv env_test | awk -F = '{print $2}')
		
		#compare env value
		if [ ${ENV_TEST_VALUE} -ne ${READ_VALUE} ]
		then	
			echo  "env write value ,size $3 : failure" >>  ${ERROR_LOG_FILE}
			echo  "env partition read and write value is different: env failure!!!" >>  ${ERROR_LOG_FILE}
			let env_error+=1
		else
			echo  "env read and write test successfull"
		fi		
		
		#dele $2
		if [ $3 -ne 128 ]
		then
			rm $2		
			#dele env 
			/fw_setenv env_test		
		fi
		
		#rm $2
		if [ ${env_error} -ne 0 ]
		then
			let ENV_ERR+=1
		fi
}


####A112
Prepare_Testpartition()
{
		#remove usb_mount
		umount /usb_mount
		rm /usb_mount
		
		#create usb_mount and mount usb_mount
		mkdir  /usb_mount
		
		ubiattach /dev/ubi_ctrl -m 4
		ls /dev/ubi1_0 
		while [ $? -ne 0  ]
		do
			echo "ubiattach /dev/ubi_ctrl -m 4 : failure!"  
			ubiattach /dev/ubi_ctrl -m 4
			ls /dev/ubi1_0 		
		done
			echo "ubiattach /dev/ubi_ctrl -m 4 : successful!"
				
		mount -t ubifs /dev/ubi1_0 /usb_mount/
		while [ $? -ne 0  ]
		do
			echo "mount -t ubifs /dev/ubi1_0 /usb_mount/: failure!"   >> ${ERROR_LOG_FILE}
			mount -t ubifs /dev/ubi1_0 /usb_mount/
			return  364
		done
			echo "mount -t ubifs /dev/ubi1_0 /usb_mount/: successful!"
}

#A112_error_print()
#{
#		echo  "---------------------------------------------------------------------"  >> ${ERROR_LOG_FILE}
#		cat   ${ERROR_LOG_FILE}
#}

file_md5_compare()
{
		#echo "source bootloader img : $1"
		#echo "new bootloader img : $2"
		local source_md5=$(md5sum $1 | awk -F " " '{print $1}')
		local new_md5=$(md5sum $2 | awk -F " " '{print $1}')
		if [ "${source_md5}"x == "${new_md5}"x ]
		then
			echo "$1 $2 read and write compare: successful!!!"
		else
			echo "$1 $2 read and write different: bootloader failure!!!" >> ${ERROR_LOG_FILE}
			return 436
		fi
}
	
ReadWrite_Bootloader()
{
		local BOOTLOADER_SOURCE=/usb_mount/amlnand_bootloader_source.img
		local BOOTLOADER_NEW=/usb_mount/amlnand_bootloader_new.img
		
		#read bootloader img
		mtd_debug read /dev/mtd0 0x0 0x1ff800 ${BOOTLOADER_SOURCE}
		if [ $? -ne 0 ]
		then 
			echo "error:mtd_debug read /dev/mtd0 0x0 0x1ff800 ${BOOTLOADER_SOURCE} failure!" >> ${ERROR_LOG_FILE}
			error_print
			exit  396
		fi
		
		#nand erase 
		flash_erase /dev/mtd0 0 0
		if [ $? -ne 0 ]
		then
			echo "error:flash_erase /dev/mtd0 0 0??failure!" >>  ${ERROR_LOG_FILE}
			error_print
			exit 405
		fi
		
		#write bootloader img
		mtd_debug write /dev/mtd0 0x0 0x1ff800 ${BOOTLOADER_SOURCE}
		if [ $? -ne 0 ]
		then
			echo "error: mtd_debug write /dev/mtd0 0x0 0x1ff800 ${BOOTLOADER_SOURCE} failure!" >>  ${ERROR_LOG_FILE}
		fi
		
		#read again bootloader img
		mtd_debug read /dev/mtd0 0x0 0x1ff800 ${BOOTLOADER_NEW}
		
		#bootloader_compare ${BOOTLOADER_SOURCE} ${BOOTLOADER_NEW}		
		file_md5_compare ${BOOTLOADER_SOURCE} ${BOOTLOADER_NEW}
}

ReadWrite_Bootloader_kernel49()
{
		local BOOTLOADER_FIRST=/usb_mount/amlnand_bootloader_first.bin
		local BOOTLOADER_SECOND=/usb_mount/amlnand_bootloader_second.bin
		local BOOTLOADER_NODE=/dev/mtd0
		local bootloader_error=0
		
		#read bootloader
		dd if=${BOOTLOADER_NODE} of=${BOOTLOADER_FIRST} bs=2048
		#flash bootloader
		flash_erase /dev/mtd0 0 0
		#write bootloader
		dd if=${BOOTLOADER_FIRST} of=${BOOTLOADER_NODE} bs=2048
		#read bootloader 
		dd if=${BOOTLOADER_NODE} of=${BOOTLOADER_SECOND} bs=2048
		
		#compare bootloader file
		file_md5_compare  ${BOOTLOADER_FIRST} ${BOOTLOADER_SECOND}
		if [ $? -eq 436 ]
		then
			let bootloader_error+=1
		fi
		
		if [ ${bootloader_error} -ne 0 ]
		then
			let BOOTLOADER_ERR+=1
		fi
		
		if [ ${BOOTLOADER_ERR}  -ne 0 ]
		then
			let FUNCTION_ERR+=1
		fi		
}

ReadWrite_Bootloader_V2()
{
		local BOOTLOADER_SOURCE1=/usb_mount/amlnand_bootloader_source1.img
		local BOOTLOADER_NEW1=/usb_mount/amlnand_bootloader_new1.img
		local BOOTLOADER_SOURCE2=/usb_mount/amlnand_bootloader_source2.img
		local BOOTLOADER_NEW2=/usb_mount/amlnand_bootloader_new2.img
		local bootloader_error=0
		
		#boot0
		#read bootloader0
		dd if=/dev/bootloader of=${BOOTLOADER_SOURCE1} bs=1046528 count=1
		if [ $? -ne 0 ]
		then
			echo "read bootloader0: failure" >>  ${ERROR_LOG_FILE}
			let bootloader_error+=1
		fi
		#read bootloader1
		dd if=/dev/bootloader of=${BOOTLOADER_SOURCE2} bs=1048576 count=1 skip=1
		if [ $? -ne 0 ]
		then
			echo "read bootloader1: failure" >> ${ERROR_LOG_FILE}
			let bootloader_error+=1
		fi
		
		#erase bootloader
		flash_erase /dev/mtd0 0 8
		flash_erase /dev/mtd0 0x100000 8
		
		#write bootloader0
		dd if=${BOOTLOADER_SOURCE1} of=/dev/bootloader bs=1046528 seek=0 count=1
		if [ $? -ne 0 ]
		then
			echo "write bootloader0: failure" >>　${ERROR_LOG_FILE}
			let bootloader_error+=1
		fi
		#write bootloader1
		dd if=${BOOTLOADER_SOURCE2} of=/dev/bootloader bs=1048576 seek=1 count=1
		if [ $? -ne 0 ]
		then
			echo "write bootloader1: failure" >>　${ERROR_LOG_FILE}
			let bootloader_error+=1
		fi
		
		#read again bootloader
		#read bootloader0 again 
		dd if=/dev/bootloader of=${BOOTLOADER_NEW1} bs=1046528 count=1
		if [ $? -ne 0 ]
		then
			echo "read bootloader0 again : failure" >>  ${ERROR_LOG_FILE}
			let bootloader_error+=1
		fi
		#read bootloader1 again 
		dd if=/dev/bootloader of=${BOOTLOADER_NEW2} bs=1048576 count=1 skip=1
		if [ $? -ne 0 ]
		then
			echo "read bootloader1 again : failure" >> ${ERROR_LOG_FILE}
			let bootloader_error+=1
		fi
		
		#compare bootloader0 && bootloader1
		file_md5_compare ${BOOTLOADER_SOURCE1} ${BOOTLOADER_NEW1}
		if [ $? -eq 436 ]
		then
			let bootloader_error+=1
		fi
		file_md5_compare ${BOOTLOADER_SOURCE2} ${BOOTLOADER_NEW2}
		if [ $? -eq 436 ]
		then
			let bootloader_error+=1
		fi
		
		if [ ${bootloader_error} -ne 0 ]
		then
			let BOOTLOADER_ERR+=1
		fi
		
		if [ ${BOOTLOADER_ERR}  -ne 0 ]
		then
			let FUNCTION_ERR+=1
		fi
}

operation_unifykey()
{
		local operation_uinifykey_error=0
		
		echo 1 > /sys/class/unifykeys/lock
		
		echo "$1" >  /sys/class/unifykeys/name
		echo "$2" >  /sys/class/unifykeys/write
		local KEY_VALUE=$(cat /sys/class/unifykeys/read)
		echo "KEY_VALUE IS ${KEY_VALUE}"
		
		if [ ${KEY_VALUE} -ne $2 ]
		then
			echo "read and write key $1 failure!!!" >> ${ERROR_LOG_FILE}
			let operation_uinifykey_error+=1
		else
			echo "read and write key $1 successfull"
		fi
		
		echo 0 > /sys/class/unifykeys/lock
		
		if [ ${operation_uinifykey_error} -ne 0 ]
		then
			return 128
		fi
}

ReadWrite_unifykey()
{
		local unifykey_error=0
		#key init
		echo 1 >  /sys/class/unifykeys/attach
		#key list
		set usid mac mac_bt mac_wifi hdcp2_tx hdcp2_rx deviceid

		local KEY_VALUE="123456789"

		for i in $@
		do
			cat /sys/class/unifykeys/list | grep $i
			if [ $? -ne 0 ]
			then
				continue
			fi
			operation_unifykey $i ${KEY_VALUE}
			if [ $? -eq 128 ]
			then
				let KEY_ERR+=1
			fi
		done

		#dele key arr
		set x;shift

		if [ ${KEY_ERR} -ne 0 ]
		then
			let FUNCTION_ERR+=1
		fi
}

ReadWrite_dtb()
{
		local OLD_DTB=/usb_mount/nand_tools/meson.dtb
		local SOURCE_DTB=/usb_mount/amlnand_dtb_source
		local  dtb_error=0
		
		local SOURCE_DTB_compare=/usb_mount/amlnand_dtb_source_compare
		#NEW_DTB=/usb_mount/dtb_new
		
		#write dtb
		#dd if=${OLD_DTB} of=/dev/dtb
		#if [ $? -ne 0 ]
		#then
		#	echo "write dtb error: from ${ERROR_LOG_FILE} to /dev/dtb"  >> ${ERROR_LOG_FILE}
		#	let  dtb_error+=1	
		#fi
		
		#read dtb
		dd if=/dev/dtb of=${SOURCE_DTB}
		if [ $? -ne 0 ]
		then
			echo "read dtb error: from /dev/dtb  to ${SOURCE_DTB}" >> ${ERROR_LOG_FILE}
			let dtb_error+=1
		fi
		
		#write dtb
		
		dd if=${SOURCE_DTB} of=/dev/dtb
		if [ $? -ne 0 ]
		then
			echo "write dtb error: from ${SOURCE_DTB} to /dev/dtb"  >> ${ERROR_LOG_FILE}
			let dtb_error+=1
		fi
		
		#read dtb
		dd if=/dev/dtb of=${SOURCE_DTB_compare}	
		if [ $? -ne 0 ]
		then
			echo "read dtb error: from /dev/dtb to ${SOURCE_DTB_compare}" >>  ${ERROR_LOG_FILE}
			let dtb_error+=1
		fi
		
		#compare dtb
		file_md5_compare  ${SOURCE_DTB}  ${SOURCE_DTB_compare}
		if [ $? -eq 436 ]
		then
			#echo "read dtb error: from /dev/dtb to ${SOURCE_DTB_compare}" >>  ${ERROR_LOG_FILE}
			let dtb_error+=1
		fi		
		
		if [ ${dtb_error} -ne 0 ]
		then
			let DTB_ERR+=1
		fi
		
		if [ ${DTB_ERR} -ne 0 ]
		then
			let FUNCTION_ERR+=1
		fi
}

create_resource_keyfile()
{
		local count=1
		local max_count=600
		echo "1" > $1
		while [ ${count} -lt  ${max_count} ]
		do
			sed -i 's/^/123456789abcdenfgz987654321/'  $1
			let count+=1
		done
		sync
}



# $1:file name
# $2:size
# $3:size count
add_2k_size()
{
		dd if=/nand_tools/resource_keyfile of=$1 bs=$2 count=$3
		if [ $? -ne 0 ]
		then
			echo "dd if=/nand_tools/resource_keyfile of=$1 bs=$2 count=$3 : failure" >> ${ERROR_LOG_FILE}
		fi
}

clean_env_mount_keyfile()
{
		# clean env tools
		rm /fw_setenv
		
		# clean mount
		umount /usb_mount
		
		# clean keyfile
		rm /nand_tools/resource_keyfile
}

A113_Prepare_Testpartition()
{
		#remove usb_mount
		umount /usb_mount
		rm /usb_mount
		
		#create usb_mount and mount usb_mount
		mkdir  /usb_mount
		data_ubisystem_number=$(cat /proc/mtd | grep  -E "data" | awk -F : '{print $1}' | grep -o '[0-9]\+')
		ubiattach /dev/ubi_ctrl -m ${data_ubisystem_number}
		ls /dev/ubi1_0 
		while [ $? -ne 0  ]
		do
			echo "ubiattach /dev/ubi_ctrl -m 4 : failure!"  
			ubiattach /dev/ubi_ctrl -m ${data_ubisystem_number}
			ls /dev/ubi1_0 		
		done
			echo "ubiattach /dev/ubi_ctrl -m 4 : successful!"
				
		mount -t ubifs /dev/ubi1_0 /usb_mount/
		while [ $? -ne 0  ]
		do
			echo "mount -t ubifs /dev/ubi1_0 /usb_mount/: failure!"   >> ${ERROR_LOG_FILE}
			mount -t ubifs /dev/ubi1_0 /usb_mount/
			return  364
		done
			echo "mount -t ubifs /dev/ubi1_0 /usb_mount/: successful!"			
}

#prepare before test
Prepare_ready()
{
		local AML_NAND_KEYFILE=/nand_tools/resource_keyfile
	
		#export error env
		export_error_env
		
		# clean env tools && mount && keyfile
		clean_env_mount_keyfile
		
		#check usb 
		usb_storage_mount
		
		if [ $? -ne 0 ]
		then 
			#mount ubi system
			if [ "${Platform}"x == "A113"x ]
			then
				A113_Prepare_Testpartition
			else
				Prepare_Testpartition
			fi
			if [ $? -eq  364]
			then
				echo "error: mount ubi system failure!" >> ${ERROR_LOG_FILE}
				error_print
				exit 364
			fi
		fi	
		
		#create tmp file
		create_resource_keyfile	 ${AML_NAND_KEYFILE}
		if [ $? -ne 0  ]
		then
			echo "error: create_resource_keyfile failure!" >> ${ERROR_LOG_FILE}	
			error_print
			exit 506			
		fi
		
		# rm fw_setenv
		rm /fw_setenv
	
        cp /nand_tools/fw_printenv /bin
        chmod 777 /bin/fw_printenv

		cp /nand_tools/fw_env.config /etc/
		chmod 777 /etc/fw_env.config

		#create fw_setenv
		ln -s /bin/fw_printenv /fw_setenv
		if [ $? -ne 0 ]
		then
			echo "error ln -s /bin/fw_printenv /fw_setenv failure! " >>  ${ERROR_LOG_FILE}
			error_print
			exit 519
		fi
}

ubifs_rm_comparefile()
{
		echo "rm ubifs tmp file"
		rm $*
}

ReadWrite_env_all()
{
		local resource_keyfile_tmp=/nand_tools/resource_keyfile

		local amlnand_env_test_file=/usb_mount/amlnand_env_test_file
		
		# increase env value size
		ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  16 
		ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  32 
		ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  64 
		ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  128 
		#ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  256
		#ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  512 
		#ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  1024
		#ReadWrite_env_value_increase  ${resource_keyfile_tmp}  ${amlnand_env_test_file}  2048 	
		if [ ${ENV_ERR} -ne 0 ]
		then 
			let FUNCTION_ERR+=1
			#return 128
		fi
}

add_different_size_file()
{
		local amlnand_dest_file1=$1
		local amlnand_dest_file2=$2
		local bs_size=$3
		local count=$4
		add_2k_size ${amlnand_dest_file1} ${bs_size} ${count}
		
		#add_2k_size ${amlnand_dest_file2} ${bs_size} ${count}
		cp ${amlnand_dest_file1} ${amlnand_dest_file2}
		
		#sync file
		sync
		file_md5_compare ${amlnand_dest_file1} ${amlnand_dest_file2}
		if [ $? -ne 0 ]
		then
			return 128
		fi
		
		#rm ${amlnand_dest_file1} ${amlnand_dest_file2}
}

operation_2k_mult()
{
		local amlnand_dest_file1=/usb_mount/amlnand_dest_file_2k_$1
		local amlnand_dest_file2=/usb_mount/amlnand_dest_file1_2k_$1
		local bs_size=0
		let bs_size=2048*$1
		local count=1
		add_different_size_file ${amlnand_dest_file1} ${amlnand_dest_file2} ${bs_size} $1
		if [ $? -eq 128 ]
		then
			return 128
		fi
		#dele compare file
		#ubifs_rm_comparefile  $1 $2
}

#2k mult
operation_2k_mult_all()
{
		local count=1
		local max_count=2
		local k2_mult_all_error=0
		
		while [ ${count} -le  ${max_count} ]
		do
			operation_2k_mult  ${count} 
			if [ $? -eq 128 ]
			then
				let k2_mult_all_error+=1
			fi
			let count+=1
		done
		if  [ ${k2_mult_all_error} -ne 0 ]
		then
			let SYSTEM_ERR+=1
		fi
}

operation_2k_ood()
{
		local amlnand_dest_file1=/usb_mount/amlnand_dest_file_2k_ood_$1
		local amlnand_dest_file2=/usb_mount/amlnand_dest_file1_2k_ood_$1
		local bs_size=0
		local let bs_size=2048*$1

		let bs_size+=1
		local count=1

		add_different_size_file ${amlnand_dest_file1} ${amlnand_dest_file2} ${bs_size} ${count}
		if [ $? -eq 128 ]
		then
			return 128
		fi
		#dele compare file
		#ubifs_rm_comparefile  $1 $2
}


operation_2k_ood_all()
{
		local count=1
		local max_count=5
		local k2_ood_all_error=0
		
		while [ ${count} -le  ${max_count} ]
		do
			operation_2k_ood ${count} 
			if [ $? -eq 128 ]
			then
				let k2_ood_all_error+=1
			fi
			let count+=1
		done	
		
		if [ ${k2_ood_all_error} -ne 0  ]
		then
			let SYSTEM_ERR+=1
		fi
}

operation_create_file()
{
		echo "source file: $1"
		echo "compare file: $2"
		local resource_keyfile=/nand_tools/resource_keyfile
		
		#create file
		dd if=${resource_keyfile} of=$1 bs=$3 count=1
		cp $1 $2
		sync
}

operation_small_file()
{
		#1k ~ 10k
		local count=1
		local max_count=10
		local bs_size=0

		while [ ${count} -le ${max_count} ]
		do
			let bs_size=1024*${count}
			local source_file=/usb_mount/amlnand_smash_${count}k_source_file
			local compare_file=/usb_mount/amlnand_smash_${count}k_compare_file
			operation_create_file  ${source_file}  ${compare_file}  ${bs_size} 
			#operation_compare_file ${source_file}  ${compare_file}
			let count+=1
		done	
}

compare_smash_file()
{
		local count=1
		local max_count=10
		local COMPARTE_SMASH_FILE_ERR=0
		while [ ${count} -le ${max_count} ]
		do
			local source_file=/usb_mount/amlnand_smash_${count}k_source_file
			local compare_file=/usb_mount/amlnand_smash_${count}k_compare_file
			file_md5_compare ${source_file} ${compare_file}
			if [ $? -eq 436 ]
			then
				let COMPARTE_SMASH_FILE_ERR+=1
			fi
			let count+=1
		done	
		
		if [ ${COMPARTE_SMASH_FILE_ERR} -ne 0 ]
		then
			let SYSTEM_ERR+=1
		fi
}

operation_smash_file_all()
{
		local source_file=/usb_mount/amlnand_smash_sourcefile
		local compare_file=/usb_mount/amlnand_smash_comparefile
		local count=1
		
		
		# create small file
		operation_small_file
		
		#compare small file
		#operation_2k_ood  ${source_file} ${compare_file} ${count} 		
		compare_smash_file
		
		#rm smash file 
		#rm /usb_mount/amlnand_smash*
}

ReadWrite_system()
{
		#local system_error=0
		
		local amlnand_dest_file1=/usb_mount/amlnand_dest_file1
		local amlnand_dest_file2=/usb_mount/amlnand_dest_file2
		
		#read and write file in system0
		#operation_2k_mult_all ${amlnand_dest_file1} ${amlnand_dest_file2}
		operation_2k_mult_all
	 
		#
		#operation_2k_ood_all	${amlnand_dest_file1} ${amlnand_dest_file2}
		operation_2k_ood_all
		
		#smash file operation
		operation_smash_file_all
		#operation_small_file  ${amlnand_dest_file1} ${amlnand_dest_file2}	 
		
		if [ ${SYSTEM_ERR} -ne 0 ]
		then
			let FUNCTION_ERR+=1
		fi
}

Clean_resource()
{
		#dele resource file
		rm -rf /usb_mount/amlnand*
		
		#export env set 0
		export_error_env
		
		#error_print

		#umount /usb_mount
		#umount /usb_mount		
}

#Read efuse
Read_efuse()
{
	efuse_dir=/sys/class/efuse
	echo "----------------efuse test:start-------------"
	set userdata usid mac mac_bt mac_wifi
	for i in $@
	do	
		cat ${efuse_dir}/$i
		if [ $? -ne 0 ]
		then
			echo "eufse $i  error"
			exit 1	
		fi
	done
	echo "----------------efuse test:end-------------"
	
}

#function test
function_test()
{
		 #export_error_env
			
		if [ "${Platform}"x  == "A111"x ]
		then
			ReadWrite_flashByMTD
			ReadWrite_userpartition
			ReadWrite_nandkey
			ReadWrite_env
		elif [ "${Platform}"x  == "A112"x ]
		then
			#echo "-------------------function test begain---------------------" >> ${ERROR_LOG_FILE}
			if [ "${LINUX_VERSION}" == "4.9.20"  ]
			then
			    echo "current is kernel 4.9"
				ReadWrite_Bootloader_kernel49
			else
				ReadWrite_Bootloader_V2
			fi
			#ReadWrite_dtb
			ReadWrite_env_all
			#ReadWrite_unifykey
			ReadWrite_system
			#echo "-------------------function test end-----------------------" >> ${ERROR_LOG_FILE}
			#Clean_resource
		elif [ "${Platform}"x  == "A113"x ]
		then
			# dtb
			ReadWrite_dtb
			
			# env
		    ReadWrite_env_all
		
			#unifykey
			ReadWrite_unifykey
			#system
			ReadWrite_system
			
			#read efuse
			Read_efuse

		fi
}
#####################################################function test(end)################################################

#echo "pressure test"
pressure_test()
{		echo "----------------------------------pressure test begain----------------------------"	>> ${ERROR_LOG_FILE}
		local test_count=$1
		local start_count=1
		local error_count=0
		
		while [ ${start_count} -le ${test_count} ]
		do
			#echo "---------------------pressure count:${start_count}---------------------------"    >> ${ERROR_LOG_FILE}
			function_test
			if [ ${FUNCTION_ERR} -ne 0 ]
			then
				echo "pressure count:${start_count}:error!" >> ${ERROR_LOG_FILE}
				let error_count+=1
			fi
			
			if [ ${start_count} -eq ${test_count} ]
			then
				echo "pressure test error count: ${error_count}"  >>  ${ERROR_LOG_FILE}
				local success_count=0
				let success_count=test_count-error_count
				echo "pressure test success count : ${success_count}"   >>  ${ERROR_LOG_FILE}			
			fi
			Clean_resource
			let start_count+=1
		done
		echo "----------------------------------pressure test end-------------------------------"   >> ${ERROR_LOG_FILE}
}


#echo "stability test"
stability_env()
{
		#echo "++++++++++tability env start: "  >>  ${ERROR_LOG_FILE}
		local amlnand_env_test_file=/usb_mount/amlnand_env_test_file
		local READ_VALUE=$(fw_printenv env_test | awk -F = '{print $2}')

		local ENV_TEST_VALUE=$(cat ${amlnand_env_test_file})

		#compare env value
		if [ ${ENV_TEST_VALUE} -ne ${READ_VALUE} ]
		then	
			echo  "env write value ,size $3 : failure" >>  ${ERROR_LOG_FILE}
			echo  "env partition read and write value is different: env failure!!!" >>  ${ERROR_LOG_FILE}
			let ENV_ERR+=1
			let STABILITY_ERR+=1
		else
			echo  "env read and write test successfull"
		fi		
		
		#clean file and env
		rm ${amlnand_env_test_file}
		/fw_setenv env_test
		#echo "++++++++++tability env end "  >>  ${ERROR_LOG_FILE}
}

stability_dtb()
{
		#echo "++++++++++stability dtb start:" >> ${ERROR_LOG_FILE}	
		local OLD_DTB=/usb_mount/amlnand_dtb_source
		local READ_DTB=/usb_mount/amlnand_dtb_source_compare
		
		dd if=/dev/dtb of=${READ_DTB}

		file_md5_compare  ${READ_DTB}  ${OLD_DTB}
		if [ $? -eq 436 ]
		then
			let DTB_ERR+=1
			let STABILITY_ERR+=1
		fi
		#echo "++++++++++stability dtb end" >> ${ERROR_LOG_FILE}	
		#rm ${SOURCE_DTB}
}


stability_unifykey_step()
{
		echo 1 > /sys/class/unifykeys/lock
		
		echo "$1" >  /sys/class/unifykeys/name
		local KEY_VALUE=$(cat /sys/class/unifykeys/read)
		echo "KEY_VALUE IS ${KEY_VALUE}"
		
		if [ ${KEY_VALUE} -ne $2 ]
		then
			echo "stability read $1 can't matching: failure!!!" >> ${ERROR_LOG_FILE}
			let KEY_ERR+=1
		else
			echo "stability read $1 successfull"
		fi
		
		echo 0 > /sys/class/unifykeys/lock
}


stability_unifykey()
{
                 #echo "+++++++++++++stabilit unifykey start:" >> ${ERROR_LOG_FILE}
                 #key init
                 echo 1 >  /sys/class/unifykeys/attach
 
                 #key list
                 set usid mac hdcp mac_bt mac_wifi hdcp2_tx hdcp2_rx deviceid
 
                 local KEY_VALUE="123456789"
 
                 for i in $@
                 do
                         stability_unifykey_step  $i ${KEY_VALUE}
                 done
 
                 #dele key arr
                 set x;shift
				 
				 if [ ${KEY_ERR} -ne 0 ]
				 then
					let STABILITY_ERR+=1
				 fi
                 #echo "+++++++++++++stabilit unifykey end" >> ${ERROR_LOG_FILE}
 }


stability_2k_mult()
{
		local count=1
		local max_count=2
		local STABILITY_2K_ERR=0
		#echo "+++++++++++++stability system 2k mult test start:" >> ${ERROR_LOG_FILE}
		while [  ${count} -le ${max_count} ]
		do
			local amlnand_dest_file1=/usb_mount/amlnand_dest_file_2k_${count}
			local amlnand_dest_file2=/usb_mount/amlnand_dest_file1_2k_${count}
			file_md5_compare ${amlnand_dest_file1} ${amlnand_dest_file2}
			if [ $? -eq 436 ]
			then
				let STABILITY_2K_ERR+=1
			fi
			let count+=1
		done

		if [ ${STABILITY_2K_ERR} -ne 0 ]
		then
			let SYSTEM_ERR+=1
		fi
		#echo "+++++++++++++stability system 2k mult test end" >> ${ERROR_LOG_FILE}
}

stability_2k_ood()
{
		local count=1
		local max_count=5
		local STABILITY_2K_ODD_ERR=0
		#echo "++++++++++++++stability system 2k ood start:"  >> ${ERROR_LOG_FILE}
		while [  ${count} -le ${max_count} ]
		do
			local amlnand_dest_file1=/usb_mount/amlnand_dest_file_2k_ood_${count}
			local amlnand_dest_file2=/usb_mount/amlnand_dest_file1_2k_ood_${count}
			file_md5_compare ${amlnand_dest_file1} ${amlnand_dest_file2}
			if [ $? -eq 436 ]
			then
				let STABILITY_2K_ODD_ERR+=1
			fi
			let count+=1
		done
		
		if [ ${STABILITY_2K_ODD_ERR} -ne 0 ]
		then
			let SYSTEM_ERR+=1
		fi
		#echo "++++++++++++++stability system 2k ood end" >> ${ERROR_LOG_FILE}
		
}

stability_smash()
{
		#echo "++++++++++++stability_smash start:"  >> ${ERROR_LOG_FILE}
		compare_smash_file
		#echo "++++++++++++stability_smash end"     >> ${ERROR_LOG_FILE}
}

stability_system()
{	
		#echo "++++++++++++++stability system start:"	>> ${ERROR_LOG_FILE}
		#2k mult
		stability_2k_mult
		#2k mult add 1
		stability_2k_ood
		#smash file
		stability_smash
		
		if [ ${SYSTEM_ERR} -ne 0 ]
		then
			let STABILITY_ERR+=1
		fi
		#echo "+++++++++++++stability system end"   >>  ${ERROR_LOG_FILE}
}

stability_read_error_report()
{
		local stability_all_count=/nand_tools/stability_all_count
		local STABILITY_COUNT_FILE=/nand_tools/amltmp_stability_control_number
		local result_count=0
		local stability_error_count=/nand_tools/amlerr_stability_error_count
		
		#read all
		local all_count=$(cat ${stability_all_count} | awk -F = '{print $2}')
		#get current count 
		local current_count=$(cat ${STABILITY_COUNT_FILE} | awk -F = '{print $2}')
		
		#current test count
		let result=all_count-current_count
		let result+=1
		
		echo "------------------stability test count: ${result}, error!--------------------"  >>  ${ERROR_LOG_FILE}
		#change stability all count
		ls ${stability_error_count}
		if [ $? -eq 0 ]
		then
			local change_error_count=$(cat ${stability_error_count} | awk -F = '{print $2}')
			let change_error_count+=1
			echo "stability_error=${change_error_count}" > ${stability_error_count}	
		else
			echo "stability_error=1" > ${stability_error_count}
		fi
}

stability_read()
{
		echo "-------------------stablity read"
		#read env
		stability_env
				#read dtb
		#stability_dtb
		
		#read unifykeys
		stability_unifykey

		
		#system
		stability_system
		
		if [ ${STABILITY_ERR} -ne 0 ]
		then
			stability_read_error_report
		fi
		
		#export env set 0
		export_error_env
}

stability_test()
{
		local REBOOT_FLAG_FILE=/nand_tools/reboot_flag
		
		#file not exist 
		if [ ! -f ${REBOOT_FLAG_FILE} ]	
		then
			echo "reboot=0" > ${REBOOT_FLAG_FILE}
		fi
		
		#read reboot flag
		local REBOOT_FLAG=$(cat ${REBOOT_FLAG_FILE} | awk -F = '{print $2}')
		
		echo "----------------------------REBOOT_FLAG is: ${REBOOT_FLAG}"
		if [ ${REBOOT_FLAG} -eq 0 ]
		then
			echo "-----------------reboot flag  eq 0" 
			#function  test 
			function_test
			#echo "reboot=1" > ${REBOOT_FLAG_FILE}
			#set reboot flag
			echo "reboot=1" > ${REBOOT_FLAG_FILE}
		elif [ ${REBOOT_FLAG} -eq 1 ]
		then
			
			echo "-----------------reboot flag  eq 1" >> ${ERROR_LOG_FILE}
			stability_read
			echo "reboot=0" > ${REBOOT_FLAG_FILE}
			Clean_resource
		fi
}

#whether criterion for stability testing
choice()
{
		#test function choice
		echo "function test:  1"
		echo "pressure test:  2"
		echo "stability test: 3"
		echo "please your choice:"
		read CHOICE
		
		#control test choice
		function_flag=false
		pressure_flag=false
		stability_flag=false

		if [ ${CHOICE} -eq 1 ]
		then
			function_flag=true
		elif [ ${CHOICE} -eq 2 ]
		then
			pressure_flag=true
		elif [ ${CHOICE} -eq 3 ]
		then
			stability_flag=true
		elif [ ${CHOICE} -eq 0 ]
		then
			function_flag=true
			pressure_flag=true
			stability_flag=true
		fi		
}

stbility_count_handle()
{
		local Stability_control_Number=/nand_tools/amltmp_stability_control_number
		local COUNT_FLAG=$(cat ${Stability_control_Number} | awk -F = '{print $2}')
		if [ ${COUNT_FLAG} -gt 0 ]
		then 
		let COUNT_FLAG-=1
		fi
		echo "current stability count is : ${COUNT_FLAG}"
}

excuete_stability()
{
		local Stability_control_Number=/nand_tools/amltmp_stability_control_number
		local COUNT_FLAG=$(cat ${Stability_control_Number} | awk -F = '{print $2}')
		if [ ${COUNT_FLAG} -gt 0 ]
		then
			# again stability test
			stability_test
		elif [ ${COUNT_FLAG} -eq 0  ]
		then
			choice
		fi
}

A112_stability_handle()
{
		#prepare ready
		Prepare_ready
		
		echo "------------------debug---prepare"
		local REBOOT_FILE=/nand_tools/reboot_flag
		if [ -f ${REBOOT_FILE} ]
		then
			echo "-----------------reboot_file exist"
			local REBOOT_FLAG=$(cat ${REBOOT_FILE} | awk -F = '{print $2}')
			echo "---------REBOOT_FLAG IS : ${REBOOT_FLAG}"
			if [ ${REBOOT_FLAG} -eq 1 ]
			then
				echo "-----------------------------------stability reboot test"
				stability_test
				# handle stability count 
				stbility_count_handle
			elif [ ${REBOOT_FLAG} -eq 0 ]
			then
				# handle stability count
				excuete_stability
				#choice 
			fi
		
		else
			echo "------------------------------reboot_file not exit"
			choice
		fi
}

stability_count()
{
		local Stability_control_Number=/nand_tools/amltmp_stability_control_number
		local stability_all_count=/nand_tools/stability_all_count
		
		echo "please input your stability count "
		echo "eg: 10"
		read COUNT_NUMBER_STABILITY
		
		echo "count=${COUNT_NUMBER_STABILITY}" >  ${Stability_control_Number}
		#for report error information
		echo "all_count=${COUNT_NUMBER_STABILITY}" >  ${stability_all_count}
		
}

system_reboot_setup()
{
	echo "cominig system reboot setup............"
    #Buildroot
    uname -a | grep "buildroot"
    if [ $? -eq  0 ]
    then
        cp /nand_tools/buildroot_auto_execute_nand_check.sh /etc/init.d/S95AutoExecuteNandCheck
    else
    #openwrt
	    cp /nand_tools/auto_execute_nand_check.sh /etc/init.d/
	    sync
	    ln -s /etc/init.d/auto_execute_nand_check.sh /etc/rc.d/S95AutoExecuteNandCheck
    fi
    touch /nand_tools/auto_execute_nand_test_tools
}

open_function_api()
{
	 
		if [ "${function_flag}"x == "true"x ]
		then
			echo "function_test"
			function_test
			error_print
			Clean_resource
		fi
	
		if [ "${pressure_flag}"x == "true"x ]
		then
			echo "please input pressure count!"
			echo "eg: 10"
			echo "your pressure count:"
			read TEST_COUNT
			
			pressure_test ${TEST_COUNT}	
			mount -t ubifs /dev/ubi1_0 /usb_mount
			error_print
			umount /usb_mount
		fi	

		if [ "${stability_flag}"x == "true"x ]
		then
			#system auto run setting
			system_reboot_setup
			#exit 0 
			# input reboot count
			stability_count
			stability_test
			mount -t ubifs /dev/ubi1_0 /usb_mount
			error_print 
			umount /usb_mount
		fi
}

A112_env_init()
{
		#resource key file && fw_printenv tools && tmp partition
		Prepare_ready
}

clean_tmp_file()
{
		rm -rf /usb_mount/amlnand*
}

stability_count_handle()
{
		local Stability_control_Number=/nand_tools/amltmp_stability_control_number
		local COUNT_FLAG=$(cat ${Stability_control_Number} | awk -F = '{print $2}')
		echo "---------current stability count is:${COUNT_FLAG}--------------------"
		if [ ${COUNT_FLAG} -gt 0 ]
		then 
			let COUNT_FLAG-=1
		fi
		echo "count=${COUNT_FLAG}" >  ${Stability_control_Number}
		sync
}

staiblity_error_handle_auto()
{
	    local stability_all_count=/nand_tools/stability_all_count
        local STABILITY_COUNT_FILE=/nand_tools/amltmp_stability_control_number
        local result_count=0

        #read all
        local all_count=$(cat ${stability_all_count} | awk -F = '{print $2}')
        #get current count 
        local current_count=$(cat ${STABILITY_COUNT_FILE} | awk -F = '{print $2}')

        #current test count
        let result=all_count-current_count
        let result+=1

		stabilit_error_handle  ${result}
}

stablity_test_end_clean()
{
		rm /nand_tools/aml*
		rm /nand_tools/auto_execute_nand_test_tools
		rm /nand_tools/reboot_flag
		rm /nand_tools/resource_keyfile
		rm /nand_tools/stability_all_count
		umount /usb_mount
		exit 0	
}

stability_autorun_handle()
{
		local REBOOT_FLAG_FILE=/nand_tools/reboot_flag
		local STABILITY_COUNT_FILE=/nand_tools/amltmp_stability_control_number
		
		# 1 times read flag file exit or not 
		if [ -f ${REBOOT_FLAG_FILE} ]
		then
			#read reboot flag
			local REBOOT_FLAG=$(cat ${REBOOT_FLAG_FILE} | awk -F = '{print $2}')
			
			if [ ${REBOOT_FLAG} -eq 1 ]
			then
				# stability read compare 
				stability_read	
				#set reboot flag 
				echo "reboot=0" > ${REBOOT_FLAG_FILE}
				# clean tmp file
				clean_tmp_file
				#stabilit count --
				stability_count_handle
			fi
		fi
		
		#stability count handle
		if [ -f ${STABILITY_COUNT_FILE} ]
		then
			local COUNT_FLAG=$(cat ${STABILITY_COUNT_FILE} | awk -F = '{print $2}')
			if [ ${COUNT_FLAG} -gt 0 ]
			then
				#function test 
				function_test
				#stabilit_error_handle 
				staiblity_error_handle_auto
				#1 times read flag setup
				echo "reboot=1" > ${REBOOT_FLAG_FILE}
				# sync data or file 
				sync
				# reboot start
				reboot -f
			fi
			
			if [ ${COUNT_FLAG} -eq 0 ]
			then
				local stability_error_count=/nand_tools/amlerr_stability_error_count
				ls ${stability_error_count}
				local change_error_count=$(cat ${stability_error_count} | awk -F = '{print $2}')
				echo "stability all error count: ${change_error_count}"  >> ${ERROR_LOG_FILE}
				local success_count=0
				local stability_all_count=/nand_tools/stability_all_count
				local all_count=$(cat ${stability_all_count} | awk -F = '{print $2}')
				#let "${success_count} = ${all_count} - ${stability_error_count}"
				let success_count=all_count-change_error_count
				echo "stability all success count: ${success_count}"  >> ${ERROR_LOG_FILE}
				#rm /nand_tools/amltmp*
				stablity_test_end_clean
			fi
			
		fi	
}

reboot_flag_init()
{
		local REBOOT_FLAG_FILE=/nand_tools/reboot_flag	
		touch ${REBOOT_FLAG_FILE}
		
		echo "reboot=0" > ${REBOOT_FLAG_FILE}		
}

error_init_stability()
{
		local stability_error_count=/nand_tools/amlerr_stability_error_count
		echo "stability_error=0" > ${stability_error_count}
}

stability_resource_init()
{
		# init system auto run resource
		system_reboot_setup
		# init 1 times read stability file
		reboot_flag_init
		# init stabilit count
		stability_count
		# export env set 0
		#export_error_env
		#error init
		error_init_stability
}
stabilit_error_handle()
{		
		if [ ${FUNCTION_ERR} -ne 0 ]
		then
			echo "stability test count : $1 before reboot error!"  >> ${ERROR_LOG_FILE}
		fi
}

open_function_api_v2()
{
		if [ "${function_flag}"x == "true"x ]
		then
			echo "function_test"
			function_test
			error_print
			Clean_resource
		fi
	
		if [ "${pressure_flag}"x == "true"x ]
		then
			#local pressure_count=/nand_tools/aml_nand_pressure_count
			echo "please input pressure count!"
			echo "eg: 10"
			echo "your pressure count:"
			read TEST_COUNT
			
			#echo "pressure=${TEST_COUNT}" > ${pressure_count}
			pressure_test ${TEST_COUNT}	
			mount -t ubifs /dev/ubi1_0 /usb_mount
			error_print
			umount /usb_mount
		fi	

		local REBOOT_FLAG_FILE=/nand_tools/reboot_flag	
		if [ "${stability_flag}"x == "true"x ]
		then
			# resource init 	
			stability_resource_init
			# function test
			function_test
			#error handle
			stabilit_error_handle  1
			# 1 times read stability flag setup
			echo "reboot=1" >  ${REBOOT_FLAG_FILE}
			# sync data && file
			sync
			# reboot
			reboot -f 
		fi	
}

function_run()
{
		# choice
		choice
		# 
		open_function_api_v2
}


############################################ A113 NAND TEST ##################################
A113_env_init()
{
	A112_env_init
}

A113_stablity_autorun_handle()
{
	stability_autorun_handle
}

A113_function_run()
{
	function_run
}
##############################################################################################


####################################platform(begain)###########################################
ARM_ARCH=$(cat /proc/cpuinfo | grep  -E "CPU architecture:" | awk -F : '{print $2}' | head -n 1)
#LINUX_VERSION=$(cat /proc/version | grep -E "Linux version" | awk -F " " '{print $3}' | awk -F "-" '{print $1}')
echo "*********************"
echo ${ARM_ARCH}
echo "*********************"
case ${ARM_ARCH} in
	" 7") echo "ARM ARCH is ARMv7 Processor rev 1 (v7l)"
	   echo "Amlogic platform is A111"
	   Platform=A111
	;;
	" AArch64") echo "ARM ARCH is AArch64 Processor rev 4 (aarch64)"
		echo "Amlogic platform is A112"
		Platform=A112
	;;
	" 8") echo "ARM ARCH is arm v8 processor rev 4"
		echo "Amlogic platform A113"
		Platform=A113
	;;
	*) echo "can't recognition this device" 
		Platform=A112
	;;
esac

case ${Platform} in
	A111) echo "A111 function test"	
		open_function_api
	;;
	A112) echo "A112 function test"
		# enviroment init 
		A112_env_init
		#for stability auto run function check
		stability_autorun_handle
		#general function begain 
		function_run
		#A112_stability_handle
		#open_function_api
	;;
	A113)
		A113_env_init
		A113_stablity_autorun_handle
		A113_function_run
	;;
	*)  echo "error , can't recognition"
	;;
esac
####################################platform(end)###########################################

#error summary
#error_print
umount /usb_mount
