#!/bin/sh

RESULT_DIR=/test_plan/wifi/
RESULT_LOG_SDIO=${RESULT_DIR}/sdio_wifi.log
RESULT_LOG_PCIE=${RESULT_DIR}/pcie_wifi.log
WIFI_CONFIG_DIR=/test_plan/wifi/wifi_configure.txt
ERROR_FLAG=0
AUTO_REBOOT_FLAG_FILE=/test_plan/wifi/auto_reboot_all

error_handle()
{
    echo "not fount your choice wifi mode: ${WIFI_MODE}"
}

change_config_data()
{
    cat /test_plan/wifi/wifi_configure.txt | grep "$1=$2"
    if [ $? -ne 0 ]
    then
        sed -i "s/$1=$3/$1=$2/g" /test_plan/wifi/wifi_configure.txt
        sync
    fi
}

change_wifi_mode()
{
    change_config_data $1 $2 $3
}

wifi_mode()
{
    echo "*****************************"
    echo " select wifi mode."
    echo "station mode:         1"
    echo "ap mode:              2"
    echo "*****************************"
    read -t 30 WIFI_MODE_CHOICE

    case ${WIFI_MODE_CHOICE} in
        1)
            change_wifi_mode mode station ap
            ;;
        2)
            change_wifi_mode mode ap station
            ;;
        *)
            error_handle
            ;;
    esac
}

pcie_wifi()
{
    change_wifi_mode driver ath10k_pci dhd
    wifi_mode
    sync

    #sh /test_plan/wifi/pcie_wifi/pcie_wifi_test.sh
    sh /test_plan/wifi/wifi_tool.sh
	if [ $? -eq 11 ]
    then
        exit 11
    fi
}

sdio_wifi()
{
    change_wifi_mode  driver dhd  ath10k_pci
    wifi_mode
    sync

    #sh /test_plan/wifi/pcie_wifi/pcie_wifi_test.sh
    sh /test_plan/wifi/wifi_tool.sh
	if [ $? -eq 11 ]
    then
        exit 11
    fi
}

autoreboot_source_handle()
{
	#system config & reboot flag
	if [ ! -f ${AUTO_REBOOT_FLAG_FILE} ]
	then
		touch ${AUTO_REBOOT_FLAG_FILE}
		cp ${RESULT_DIR}/S45autorebootwifi  /etc/init.d/
		chmod 777 /etc/init.d/S45autorebootwifi
	fi
}

autoreboot_run_step()
{
	#load wifi
    sh /test_plan/wifi/wifi_tool.sh
	if [ $? -eq 11 ]
    then
		echo "****************wifi test count: $1 end: failure**********"
		rm ${AUTO_REBOOT_FLAG_FILE}
        exit 11
    fi

	echo "****************wifi test count: $1 end : successful**********"
}

autoreboot_run()
{
	init_count=0
	#count
	let init_count+=1
	echo "${init_count}" > ${AUTO_REBOOT_FLAG_FILE}

	#load wifi
	autoreboot_run_step ${init_count}

	reboot -f
}

on_off_source_handle()
{
   change_wifi_mode  onoff_test 1  0
    sync
}
on_off_run()
{
	#load wifi
    sh /test_plan/wifi/wifi_tool.sh
    return_value=$?
	if [ ${return_value} -ne 0 ]
    then
		echo "****************wifi test count: ${return_value} end: failure**********"
        exit 11
    fi
}

stability_function()
{
    echo "*****************************"
    echo "auto reboot:                1"
    echo "on/off:                     2"
    read -t 30 stability_CHOICE
    case ${stability_CHOICE} in
        1)
            autoreboot_source_handle
			autoreboot_run
            ;;
        2)
            on_off_source_handle
			on_off_run
			;;
		*)
		;;
	esac
}

stability_test()
{
    echo "*****************************"
    echo "SDIO:                1"
    echo "PCIE:                2"
    read -t 30 stability_CHOICE
    case ${stability_CHOICE} in
        1)
			change_wifi_mode  driver dhd  ath10k_pci
            stability_function
            ;;
        2)
			change_wifi_mode driver ath10k_pci dhd
            stability_function
            ;;
		*)
		;;
	esac
}

wifi_test()
{
    echo "*****************************"
    echo "**                         **"
    echo "**      WIFI TEST          **"
    echo "**                         **"
    echo "*****************************"

    echo "*****************************"
    echo "input sdio wifi or pcie wifi"
    echo "SDIO WIFI:                1"
    echo "PCIE WIFI:                2"
	echo "STABILTIY TEST:           3"

    read -t 30 WIFI_CHOICE
    case ${WIFI_CHOICE} in
        1)
            sdio_wifi
            ;;
        2)
            pcie_wifi
            ;;
        3)
            stability_test
            ;;
        *)
            echo "not found wifi module."
            ;;
    esac
}

reboot_handle()
{
	read -t 3 BREAK_FLAG
	if [ $? -eq 0 ]
	then
	    rm ${AUTO_REBOOT_FLAG_FILE}
	    sync
	    exit 0
	else
		reboot -f
	fi
}

stabilit_reboot_run()
{
	CURRENT_REBOOT_COUNT=`cat ${AUTO_REBOOT_FLAG_FILE}`
	let CURRENT_REBOOT_COUNT+=1
	echo "${CURRENT_REBOOT_COUNT}" > ${AUTO_REBOOT_FLAG_FILE}
	autoreboot_run_step  ${CURRENT_REBOOT_COUNT}
	reboot_handle
}

if [ -f ${AUTO_REBOOT_FLAG_FILE} ]
then
	stabilit_reboot_run
else
	wifi_test
fi
