#!/bin/sh

DIR_CHROMIUM=/rockchip_test/chromium

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            CHROMIUM TEST                      ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "Chromium test:						1"
echo "***********************************************************"

read -t 30 CHROMIUM_CHOICE

chromium_test()
{
	sh ${DIR_CHROMIUM}/test_chromium_with_video.sh
}

case ${CHROMIUM_CHOICE} in
	1)
		chromium_test
		;;
	*)
		echo "not fount your input."
		;;
esac
