#!/bin/sh
echo "======================================================="
echo "    Test all camera(rkisp_demo)"
echo "======================================================="
if [ $# -eq 0 ];
then
	echo "If you want to test rkisp camera 1000 times"
	echo "CMD: test_rkisp.sh 1000"
	exit
fi
#num is test times
num=0;
#media node max
MEDIA_MAX=10
#cif path node name
CIF_PATH="stream_cif"
#isp path node name
ISP_PATH="rkisp1_mainpath"
for i in $(seq 0 $MEDIA_MAX); do
	MEDIA_DEV=/dev/media$i
	ISP_NODE=$(media-ctl -d $MEDIA_DEV -e $ISP_PATH)
	CIF_NODE=$(media-ctl -d $MEDIA_DEV -e $CIF_PATH)
	if echo $ISP_NODE | grep -q "^/dev/video"
	then
		eval VIDEO_NODE$i=$ISP_NODE;
		echo "     Check /dev/media$i is ISP-camera($(eval echo \$VIDEO_NODE$i))"
	elif echo $CIF_NODE | grep -q "^/dev/video"
	then
		eval VIDEO_NODE$i=$CIF_NODE;
		echo "     Check /dev/media$i is CIF-camera($(eval echo \$VIDEO_NODE$i))"
	else
		CAM_NUM=$i;
		echo ""
		echo "     Test camera(Num=$i) $1 times"
		echo "======================================================="		
		break;
	fi
done
CAM_NUM=$(($CAM_NUM -1));
for i in $(seq 0 $CAM_NUM); do
	while [ $num -lt $1 ]
	do
		num=$(($num +1));
		VIDEO_DEV=$(eval echo \$VIDEO_NODE$i);
		rkisp_demo --device=$VIDEO_DEV --output=/tmp/video$i.yuv --count=100;
		echo "======================================================="
		echo " camera $(eval echo \$VIDEO_NODE$i) No.($num) out /tmp/video$i.yuv is ok!";
		echo "======================================================="
		sleep 1;
	done;
	#init times for next test 
	num=0;
done;
