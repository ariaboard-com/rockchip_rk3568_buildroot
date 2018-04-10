#!/bin/sh

DIR_DVFS=/rockchip_test/dvfs

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            DVFS TEST                          ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "*****************************************************"
echo "cpu auto freq test:                             1"
echo "dvfs stress test:                               2"
echo "*****************************************************"

read -t 30 DVFS_CHOICE

auto_cpu_freq_test()
{
	#value 1 is sleep time
	sh ${DIR_DVFS}/auto_cpu_freq_test.sh 60 &
}

dvfs_stress_test()
{
	sh ${DIR_DVFS}/dvfs_stress_test.sh &
}

case ${DVFS_CHOICE} in
	1)
		auto_cpu_freq_test
		;;
	2)
		dvfs_stress_test
		;;
	*)
		echo "not fount your input."
		;;
esac
