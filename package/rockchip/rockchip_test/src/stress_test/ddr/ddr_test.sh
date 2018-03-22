#!/bin/sh

DIR_DDR=/test_plan/ddr

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            DDR TEST                           ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "*****************************************************"
echo "qpl test:                                 1"
echo "auto reboot:                              2"
echo "ddr window test:                          3"
echo "*****************************************************"

read -t 30 DDR_CHOICE

qpl_test()
{
	sh ${DIR_DDR}/qpl/qpl_test.sh
}

auto_reboot_test()
{
	sh ${DIR_DDR}/auto_reboot/autoreboot_control.sh
}

ddr_window_test()
{
	sh ${DIR_DDR}/ddr_window/ddr_window_test.sh
}

case ${DDR_CHOICE} in
	1)
		qpl_test
		;;
	2)
		auto_reboot_test
		;;
	3)
		ddr_window_test
		;;
	*)
		echo "not fount your input."
		;;
esac
