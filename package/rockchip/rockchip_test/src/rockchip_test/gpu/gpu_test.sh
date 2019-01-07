#!/bin/sh

DIR_GPU=/rockchip_test/gpu

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            GPU TEST                           ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "glmark2 fullscreen test:					1"
echo "glmark2 offscreen test:					2"
echo "***********************************************************"

read -t 30 GPU_CHOICE

glmark2_fullscreen_test()
{
	sh ${DIR_GPU}/test_glmark2_fullscreen.sh
}

glmark2_offscreen_test()
{
	sh ${DIR_GPU}/test_glmark2_offscreen.sh
}

case ${GPU_CHOICE} in
	1)
		glmark2_fullscreen_test
		;;
	2)
		glmark2_offscreen_test
		;;
	*)
		echo "not fount your input."
		;;
esac
