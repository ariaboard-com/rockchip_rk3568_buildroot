#!/bin/sh
## contrl test bl2 & tpl

ALL_FLAG=NULL
TARGET=NULL
TARGET_OP=NULL
TARGET_PER=NULL

MULT_IMG=/mnt/
LOG_FILE=/test_log/mult_uboot/mult_uboot.log

###########################
## log handle
###########################
log_init()
{
	#check file exit or not
	ls ${LOG_FILE}
	if [ $? -ne 0 ]
	then
		mkdir -p /test_log/mult_uboot/
		touch ${LOG_FILE}
	fi
}

###########################
## read_u_env_value
###########################
read_u_env_value()
{
    export TARGET=$(cat /mnt/mult_uboot_flag_file | grep -E "TARGET=" | awk -F = '{print $2}')
    if [ "${TARGET}" == ""  ]
    then
        return 1
    fi
    export TARGET_OP=$(cat /mnt/mult_uboot_flag_file | grep -E "TARGET_OP=" | awk -F = '{print $2}')
    if [ "${TARGET_OP}" == "" ]
    then
        return 2
    fi
    export TARGET_PER=$(cat /mnt/mult_uboot_flag_file | grep -E "TARGET_PER=" | awk -F = '{print $2}')
    if [ "${TARGET_PER}" == ""  ]
    then
        return 3
    fi
    export ALL_FLAG=$(cat /mnt/mult_uboot_flag_file | grep -E "ALL_FLAG=" | awk -F = '{print $2}')
    if [ "${ALL_FLAG}" == "" ]
    then
        return 4
    fi
}

first_init_u_disk_mult_file()
{
	echo "TARGET=BL2" > /mnt/mult_uboot_flag_file
	echo "TARGET_OP=erase" >>  /mnt/mult_uboot_flag_file
	echo "TARGET_PER=1" >>  /mnt/mult_uboot_flag_file
    echo "ALL_FLAG=NULL" >>  /mnt/mult_uboot_flag_file
}

lava_success()
{
   lava-test-case SYSTEM --result pass
}


bl2_down()
{
    #bl2:1
    flash_erase -N /dev/mtd0 0 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2

    #bl2:2
    flash_erase -N /dev/mtd0 0x40000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x40000

    #bl2:3
    flash_erase -N /dev/mtd0 0x80000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x80000

    #bl2:4
    flash_erase -N /dev/mtd0 0xc0000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0xc0000

    #bl2:5
    flash_erase -N /dev/mtd0 0x100000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x100000

    #bl2:6
    flash_erase -N /dev/mtd0 0x140000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x140000

    #bl2:7
    flash_erase -N /dev/mtd0 0x180000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x180000

    #bl2:8
    flash_erase -N /dev/mtd0 0x1c0000 2
    nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x1c0000
}

tpl_down()
{
    #tpl:1
    flash_erase -N /dev/mtd1 0 16
    nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl -p

    #tpl:2
    flash_erase -N /dev/mtd1 2097152  16
    nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl --start=0x200000 -p

    #tpl:3
    flash_erase -N /dev/mtd1 4194304  16
    nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl  --start=0x400000 -p

    #tpl:4
    flash_erase -N /dev/mtd1 6291456  16
    nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl  --start=0x600000 -p
}

handle_download_all_after()
{
    echo "TARGET=BL2" > /mnt/mult_uboot_flag_file
    echo "TARGET_OP=erase" >>  /mnt/mult_uboot_flag_file
    echo "TARGET_PER=1" >>  /mnt/mult_uboot_flag_file
    echo "ALL_FLAG=NULL" >>  /mnt/mult_uboot_flag_file
    sync

    #release u disk
    umont /mnt
    sync
}

down_uboot()
{
    bl2_down
    tpl_down
}

download_uboot_all()
{
    down_uboot
    #reboot
}

error_control()
{
    #lava-test-case SYSTEM  --result fail
    echo "error: $1" >> ${LOG_FILE}
	echo "**************************test result*****************************"
	cat ${LOG_FILE}
	echo "******************************************************************"

}

write_value_to_env()
{
    echo "to here"
#   /fw_setenv TARGET ${TARGET}
#    /fw_setenv TARGET_OP ${TARGET_OP}
#    /fw_setenv TARGET_PER ${TARGET_PER}
#    /fw_setenv ALL_FLAG ${ALL_FLAG}
	echo "TARGET=${TARGET}" > /mnt/mult_uboot_flag_file
	echo "TARGET_OP=${TARGET_OP}" >>  /mnt/mult_uboot_flag_file
	echo "TARGET_PER=${TARGET_PER}" >>  /mnt/mult_uboot_flag_file
	echo "ALL_FLAG=${ALL_FLAG}" >>  /mnt/mult_uboot_flag_file
	sync
}

read_env_to_value()
{
    export TARGET=$(fw_printenv TARGET | awk -F = '{print $2}')
    if [ "${TARGET}" == ""  ]
    then
        return 1
    fi
    export TARGET_OP=$(fw_printenv TARGET_OP | awk -F = '{print $2}')
    if [ "${TARGET_OP}" == "" ]
    then
        return 1
    fi
    export TARGET_PER=$(fw_printenv TARGET_PER | awk -F = '{print $2}')
    if [ "${TARGET_PER}" == ""  ]
    then
        return 1
    fi
    export ALL_FLAG=$(fw_printenv ALL_FLAG | awk -F = '{print $2}')
    if [ "${ALL_FLAG}" == "" ]
    then
        return 1
    fi
}

env_value_change()
{
    TARGET=$1
    TARGET_OP=$2
    TARGET_PER=$3

    if [ $# == 4 ]
    then
        ALL_FLAG=$4
    else
		ALL_FLAG=NULL
	fi

    #write value to env
    write_value_to_env

	#log handle
	echo "next process: TARGET:$1 TARGET_OP:$2 TARGET_PER:$3" >> ${LOG_FILE}

	#release u disk
	umount /mnt
	sync
	sleep 1
    reboot
}

bl2_erase()
{
    case ${TARGET_PER} in
        1)
            flash_erase -N /dev/mtd0 0 2
            env_value_change BL2 erase 2
            ;;
        2)
            flash_erase -N /dev/mtd0 0x40000 2
            env_value_change BL2 erase 3
            ;;
        3)
            flash_erase -N /dev/mtd0 0x80000 2
            env_value_change BL2 erase 4
            ;;
        4)
            flash_erase -N /dev/mtd0  0xC0000 2
            env_value_change BL2 erase 5
            ;;
        5)
            flash_erase -N /dev/mtd0 0x100000 2
            env_value_change BL2 erase 6
            ;;
        6)
            flash_erase -N /dev/mtd0 0x140000 2
            env_value_change BL2 erase 7
            ;;
        7)
            flash_erase -N /dev/mtd0 0x180000 2
            env_value_change BL2 erase 8
            ;;
        8)
			echo "bl2 erase sucess..................................." >> ${LOG_FILE}
            env_value_change BL2 baddata  1 ALL
            ;;
        *)
            error_control bl2_erase
            ;;
    esac
}

bl2_baddata()
{
    case ${TARGET_PER} in
        1)
            flash_erase -N /dev/mtd0 0 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0x20000
            env_value_change BL2 baddata 2
            ;;
        2)
            flash_erase -N /dev/mtd0 0x40000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0x60000
            env_value_change BL2 baddata 3
            ;;
        3)
            flash_erase -N /dev/mtd0 0x80000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0xA0000
            env_value_change BL2 baddata 4
            ;;
        4)
            flash_erase -N /dev/mtd0 0xC0000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0xE0000
            env_value_change BL2 baddata 5
            ;;
        5)
            flash_erase -N /dev/mtd0 0x100000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0x120000
            env_value_change BL2 baddata 6
            ;;
        6)
            flash_erase -N /dev/mtd0 0x140000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0x160000
            env_value_change BL2 baddata 7
            ;;
        7)
            flash_erase -N /dev/mtd0 0x180000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/boot.img  --input-size=0x1A0000
            env_value_change BL2 baddata 8
            ;;
        8)
		echo "bl2 baddata sucess..................................." >> ${LOG_FILE}
            env_value_change BL2 halfdata  1 ALL
            ;;
        *)
            error_control bl2_baddata
            ;;
    esac
}

bl2_halfdata()
{
    case ${TARGET_PER} in
        1)
            flash_erase -N /dev/mtd0 0 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2   --input-size=0x8000
            env_value_change BL2 halfdata 2
            ;;
        2)
            flash_erase -N /dev/mtd0 0x40000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x40000 --input-size=0x8000
            env_value_change BL2 halfdata 3
            ;;
        3)
            flash_erase -N /dev/mtd0 0x80000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x80000 --input-size=0x8000
            env_value_change BL2 halfdata 4
            ;;
        4)
            flash_erase -N /dev/mtd0 0xC0000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0xc0000 --input-size=0x8000
            env_value_change BL2 halfdata 5
            ;;
        5)
            flash_erase -N /dev/mtd0 0x100000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x100000 --input-size=0x8000
            env_value_change BL2 halfdata 6
            ;;
        6)
            flash_erase -N /dev/mtd0 0x140000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x140000 --input-size=0x8000
            env_value_change BL2 halfdata 7
            ;;
        7)
            flash_erase -N /dev/mtd0 0x180000 2
            nandwrite /dev/mtd0 ${MULT_IMG}/u-boot.bin.usb.bl2  --start=0x180000 --input-size=0x8000
            env_value_change BL2 halfdata 8
            ;;
        8)
			echo "bl2 halfdata sucess..................................." >> ${LOG_FILE}
            env_value_change TPL erase  1 ALL
            ;;
        *)
            error_control bl2_halfdata
            ;;
    esac
}
bl2_operation()
{
    case ${TARGET_OP} in
        erase)
            bl2_erase
            ;;
        baddata)
            bl2_baddata
            ;;
        halfdata)
            bl2_halfdata
            ;;
        *)
            error_control bl2_operation
            ;;
    esac
}

tpl_erase()
{
    case ${TARGET_PER} in
        1)
            flash_erase -N /dev/mtd1 0 16
            env_value_change TPL erase 2
            ;;
        2)
            flash_erase -N /dev/mtd1 2097152  16
            env_value_change TPL erase 3
            ;;
        3)
            flash_erase -N /dev/mtd1 4194304  16
            env_value_change TPL erase 4
            ;;
        4)
			echo "tpl erase sucess..................................." >> ${LOG_FILE}
            env_value_change TPL baddata 1 ALL
            ;;
        *)
            error_control tpl_erase
            ;;
    esac
}

tpl_baddata()
{
   case ${TARGET_PER} in
        1)
            flash_erase -N /dev/mtd1 0 16
            nandwrite /dev/mtd1 ${MULT_IMG}/boot.img  --input-size=0x200000
            env_value_change TPL baddata 2
            ;;
        2)
            flash_erase -N /dev/mtd1 2097152  16
            nandwrite /dev/mtd1 ${MULT_IMG}/boot.img  --input-size=0x400000
            env_value_change TPL baddata 3
            ;;
        3)
            flash_erase -N /dev/mtd1 4194304  16
            nandwrite /dev/mtd1 ${MULT_IMG}/boot.img  --input-size=0x600000
            env_value_change TPL baddata 4
            ;;
        4)
			echo "tpl baddata sucess..................................." >> ${LOG_FILE}
            env_value_change TPL halfdata 1 ALL
            ;;
        *)
            error_control tpl_baddata
            ;;
   esac
}

erase_all()
{
    #bl2
    flash_erase -N /dev/mtd0 0 2
    flash_erase -N /dev/mtd0 0x40000 2
    flash_erase -N /dev/mtd0 0x80000 2
    flash_erase -N /dev/mtd0 0xC0000 2
    flash_erase -N /dev/mtd0 0x100000 2
    flash_erase -N /dev/mtd0 0x140000 2
    flash_erase -N /dev/mtd0 0x180000 2
    flash_erase -N /dev/mtd0 0x1C0000 2

    #tpl
    flash_erase -N /dev/mtd1 0 16
    flash_erase -N /dev/mtd1 2097152  16
    flash_erase -N /dev/mtd1 4194304  16
    flash_erase -N /dev/mtd1 6291456  16
    reset
}
tpl_halfdata()
{
    case ${TARGET_PER} in
        1)
            flash_erase -N /dev/mtd1 0 16
            nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl  --input-size=0x7D000
            env_value_change TPL halfdata 2
            ;;
        2)
            flash_erase -N /dev/mtd1 2097152  16
            nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl --start=0x200000  --input-size=0x7D000
            env_value_change TPL halfdata 3
            ;;
        3)
            flash_erase -N /dev/mtd1 4194304  16
            nandwrite /dev/mtd1 ${MULT_IMG}/u-boot.bin.usb.tpl  --start=0x400000  --input-size=0x7D000
            env_value_change TPL halfdata 4
            ;;
        4)
		echo "tpl halfdata sucess..................................." >> ${LOG_FILE}
          #lava_success
           #erase_all
		   rm /test_plan/mult_uboot/reboot_flag
		   rm /mnt/mult_uboot_flag_file
		   echo "**************************test result*****************************"
		   cat ${LOG_FILE}
		   echo "******************************************************************"
            ;;
        *)
			error_control tpl_halfdata
            ;;
    esac
}

tpl_operation()
{
    case ${TARGET_OP} in
        erase)
            tpl_erase
            ;;
        baddata)
            tpl_baddata
            ;;
        halfdata)
            tpl_halfdata
            ;;
        *)
            error_control tpl_operation
            ;;
    esac
}

#env tools init
env_tools_init()
{
   ln /bin/fw_printenv /fw_setenv
}
###########################
#uboot read env
#env_tools_init

# read env value
#read_env_to_value
###########################

###########################
## u disk init
###########################
u_disk_init()
{
	#umont
	#umount /mnt

	#mount sda1
	ls /dev/sda1
	while [ $? -ne 0 ]
	do
		ls /dev/sda1
	done

	mount /dev/sda1 /mnt
}

###########################
#### u disk read env
###########################
env_u_disk_to_value()
{
	#u disk init
	u_disk_init
	#check env file exist or not
	MULT_FLAG_FILE=/mnt/mult_uboot_flag_file
	if [ ! -f ${MULT_FLAG_FILE} ]
	then
		first_init_u_disk_mult_file
	fi
	# read env value
	read_u_env_value
}

REBOOT_RUN_MULT_FLAG_FILE=/test_plan/mult_uboot/reboot_flag
if [ ! -f ${REBOOT_RUN_MULT_FLAG_FILE}  ]
then
    touch ${REBOOT_RUN_MULT_FLAG_FILE}
fi

#u release
umount /mnt
echo "to here"

#log init
log_init
#u disk init
env_u_disk_to_value

if [ "${ALL_FLAG}" == "ALL"  ]
then
    download_uboot_all
    sed -i "s/ALL_FLAG=ALL/ALL_FLAG=NULL/g" /mnt/mult_uboot_flag_file
    reboot
else
    case ${TARGET} in
    BL2)
        bl2_operation
        ;;
    TPL)
        tpl_operation
        ;;
    *)
        error_control bl2_tpl_target_operation
        ;;
    esac
fi

