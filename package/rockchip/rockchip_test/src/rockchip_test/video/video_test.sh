#!/bin/sh

DIR_VIDEO=/rockchip_test/video

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            VIDEO TEST                         ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "video test:						1"
echo "multivideo test:						2"
echo "multivideo app demo test:					3"
echo "***********************************************************"

read -t 30 VIDEO_CHOICE

video_test()
{
	sh ${DIR_VIDEO}/test_gst_video.sh
}

multivideo_app_demo_test()
{
	cd ${DIR_VIDEO}
	./test_app_demo_multivideo.sh test
}

multivideo_test()
{
	cd ${DIR_VIDEO}
	./test_gst_multivideo.sh test
}

case ${VIDEO_CHOICE} in
	1)
		video_test
		;;
	2)
		multivideo_test
		;;
	3)
		multivideo_app_demo_test
		;;
	*)
		echo "not fount your input."
		;;
esac
