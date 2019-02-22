#!/bin/sh

DIR_CAMERA=/rockchip_test/camera

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            CAMERA TEST                        ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "*****************************************************"
echo "camera app test:                                    1"
echo "camera stresstest:                                  2"
echo "*****************************************************"

read -t 30 CAMERA_CHOICE

camera_app_test()
{
	sh ${DIR_CAMERA}/camera_rkisp.sh
}

camera_stresstest()
{
	sh ${DIR_CAMERA}/camera_stresstest.sh 1000
}

case ${CAMERA_CHOICE} in
	1)
		camera_app_test
		;;
	2)
		camera_stresstest
		;;
	*)
		echo "not fount your input."
		;;
esac
