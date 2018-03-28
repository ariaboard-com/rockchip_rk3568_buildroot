#!/bin/sh
### file: rockchip_test.sh
### author: yhx@rock-chips.com
### function: ddr cpu gpio audio usb player ehernet sdio/pcie(wifi) 
### date: 20180327

moudle_env()
{
   export  MODULE_CHOICE

}

module_choice()
{  
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***        ********************                   ***"
    echo "***       *ROCKCHIPS TEST TOOLS*                  ***"
    echo "***        *                  *                   ***"
    echo "***        ********************                   ***"
    echo "***                                               ***"
    echo "*****************************************************"

    
    echo "*****************************************************"
    echo "ddr test :            1 (memtester & stressapptest)"
    echo "cpu test :            2 (dvfs & cpu hotplug & suspend resume & thermal)"
    echo "nand test:            3"
    echo "gpio test:            4 (pio & irq & pull)"
    echo "audio test:           5"
    echo "usb  test:            6 (insert & read & write)"
    echo "player test:          7 "
    echo "mult uboot test:      8 (erase & bad data & half data)"
    echo "wifi test:            9"
    echo "ethernet test:        10"
    echo "IR test:              11"
    echo "QT test:              12"
	echo "auto reboot test:     13"
    echo "*****************************************************"

    echo  "please input your test moudle: "
    read -t 30  MODULE_CHOICE
}

ddr_test()
{
    sh /rockchip_test/ddr/ddr_test.sh
}

cpu_test()
{
    sh /rockchip_test/cpu/cpu_test.sh
}

nand_test()
{
   rm /nand_tools -rf
   cp /test_plan/nand_tools / -rf
   sync
   cd /nand_tools/
   umount /mnt
   sh /nand_tools/Nand_test_tools.sh
   
}

usb_test()
{
    sh /test_plan/usb/usb_test.sh
}
player_test()
{
    sh /test_plan/player/test.sh
}

mult_uboot_test()
{
   sh /test_plan/mult_uboot/mult_reboot_control.sh 
}

wifi_test()
{
    sh /test_plan/wifi/wifi_test.sh
}

ethernet_test()
{
   sh /test_plan/ethernet/eth_test.sh 
}

gpio_test()
{
    sh /test_plan/gpio/gpio_test.sh
}

audio_test()
{
    sh /test_plan/audio/audio_test.sh
}

ir_test()
{
    sh /test_plan/ir/ir_test.sh
}

qt_test()
{
	sh /test_plan/qt/mipi_test.sh
}

auto_reboot_test()
{
	fcnt=/data/config/rockchip_test/reboot_cnt;                 
	if [ -e "$fcnt" ]; then
		rm -f $fcnt;                   
	fi
	sh /rockchip_test/auto_reboot/auto_reboot.sh
}

module_test()
{
    case ${MODULE_CHOICE} in
        1)
            ddr_test
            ;;
        2)
            cpu_test
            ;;
        3)
            nand_test
            ;;
        4)
            gpio_test
            ;;
        5)
            audio_test
            ;;
        6)
            usb_test
            ;;
        7)
            player_test
            ;;
        8)
            mult_uboot_test
            ;;
        9)
            wifi_test
            ;;
        10)
            ethernet_test
            ;;
        11)
            ir_test
            ;;
        12)
            qt_test	
            ;;
		13)
            auto_reboot_test	
            ;;
    esac
}

# module env
#module_env
# moudule choice
module_choice
# moudle test
module_test



