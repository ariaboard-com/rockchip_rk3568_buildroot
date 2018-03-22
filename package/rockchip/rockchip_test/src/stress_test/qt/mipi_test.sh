#!/bin/sh

echo 0 > /proc/sys/kernel/printk
echo ""
echo "****************************************************"
echo "*     Amlogic A113 Platform MIPI OSD Case Test     *"
echo "****************************************************"
echo "*   mipi lcd lit test:                      [0]    *"
echo "*   ge2d test(768x1024/256x256/1920x1080):  [1]    *"
echo "*   qt LinuxFB test:                        [2]    *"
echo "*   qt quick test:                          [3]    *"
echo "*   exit shell test:                        [q]    *"
echo "****************************************************"

echo ""
echo -n  "choice your case:"
read TEST_CASE

taskkill()
{
    if [ $# -ne 2 ]; then
        PID=`ps ax | grep $1 | awk '{if ($0 !~/grep/) {print $1}}'`
	#echo "PID=$PID"
	if [ -n "$PID" ]; then
	    kill -9 $PID >/dev/null 2>&1
            return 0
        else
	    return 1
	fi
    fi
    return 1
}

kill_task()
{
    while true
    do
        taskkill $1
	ret=$?
	if [ $ret -eq 1 ]; then
	    break
	fi
    done
}

delay()
{
    local index=$1
    local m=0
    local n=0
    if [ $# -ne 2 ]; then
        while [ $index -gt 0 ]
	do
	    sleep 1
	    #index=$[ $index -1 ]
	    let index-=1
	    echo -n "."
	    let m+=1
	    n=$(( $m % 20 ))
	    if [ $n -eq 0 ]; then
		echo ""
	    fi
	done
	echo "stop"
        echo ""
	return 0
	fi
    return 1
}

kill_all()
{
    kill_task lighting
    kill_task df_dok
    kill_task dfbshow
    echo ""
    echo "kill all process..."
    echo ""
    exit
}

trap kill_all INT

qt_32_bit_demo()
{
        echo "******************start qt quick test***************"
        export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0
        export QT_QUICK_BACKEND=softwarecontext
        /mnt/playerdemo32/playerdemo /mnt/playerdemo32/main.qml &
        delay 60
        kill_task playerdemo
        echo "******************stop qt quick test****************"
}

qt_64_bit_demo()
{
        echo "******************start qt quick test***************"
        export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0
        export QT_QUICK_BACKEND=softwarecontext
        /mnt/DemoQPainter32/DemoQPainter32 /mnt/DemoQPainter32/main.qml &
		delay 60
        kill_task playerdemo
        echo "******************stop qt quick test****************"
}

qt_quick_test()
{
	echo "current system is $1 bit"
    export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0
    export QT_QUICK_BACKEND=softwarecontext
    /mnt/QT/$1/qt_quick/DemoQPainter /mnt/QT/$1/qt_quick/main.qml &
	delay 60
	kill_task DemoQPainter

}

qt_fb_test()
{
	echo "current system is $1 bit"
    export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0
    export QT_QUICK_BACKEND=softwarecontext
    /mnt/QT/$1/qt_fb/lighting  &
	delay 60
	kill_task lighting

}

case $TEST_CASE in
    "0")
	echo ""
	echo "****************start mipi lcd lit test****************"
	echo 1 > /sys/class/lcd/test
	echo "****************stop mipi lcd lit test*****************"
	echo ""
    ;;
    "1")
	echo 0 > /sys/class/lcd/test
	echo ""
	echo "***************start ge2d test(768x1024)***************"
	rm ge2d_* -rf
	df_dok --size 768x1024 &
	delay 120
	kill_task df_dok

	echo ""
        echo "********************start ge2d test(256x256)***********"
        df_dok --size 256x256 &
        delay 90
        kill_task df_dok

	echo ""
        echo "*****************start ge2d test(1920x1080)************"
        df_dok --size 1920x1080 &
        delay 120
        kill_task df_dok
    ;;
    "2")
	#echo 0 > /sys/class/lcd/test
	echo "******************start qt LinuxFB test***************"
	lib_64=/lib64
	lib_32=/lib32
	if [ -d  ${lib_64} ]
	then
		qt_fb_test 64
	else
		qt_fb_test 32
	fi
	#export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0
    #export QT_QUICK_BACKEND=softwarecontext
	#/usr/lib/qt/examples/widgets/effects/lighting/lighting &
	#delay 60
	#kill_task lighting
	echo "******************stop qt LinuxFB test****************"
    ;;
    "3")
	echo 0 > /sys/class/lcd/test
	lib_64=/lib64
	lib_32=/lib32
	if [ -d  ${lib_64} ]
	then
		#qt_64_bit_demo
		qt_quick_test 64
	else
		qt_quick_test 32
	fi
    ;;
    "q")
	echo "exit!"
    ;;
    *) echo "can't recognition this case"
    ;;
esac

echo 7 > /proc/sys/kernel/printk
exit

