#!/bin/sh


case "$1" in
	test)
		rk_image_process -input="/oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4 /oem/SampleVideo_1280x720_5mb.mp4" -disp -width 2048 -height 1080 -loop -slice_num 25
		;;
	$1)
		rk_image_process -input="$1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1 $1" -disp -width 2048 -height 1080 -loop -slice_num 25
		;;
esac
shift
