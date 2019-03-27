#!/bin/bash -e

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
function run_glmark2() {
if [ "$1" == "rk3288" ]; then
	glmark2-es2-wayland --off-screen

elif [[  "$1" == "rk3328"  ]]; then
	glmark2-es2-wayland --off-screen

elif [[  "$1" == "rk3399"  ]]; then
	taskset -c 4-5 glmark2-es2-wayland --off-screen

elif [[  "$1" == "rk3399pro"  ]]; then
	taskset -c 4-5 glmark2-es2-wayland --off-screen

elif [[  "$1" == "px30" || "$1" == "rk3326"  ]]; then
	glmark2-es2-wayland --off-screen

elif [[  "$1" == "rk1808" || "$1" == "rk3308"  ]]; then
	echo "the chips didn't support gpu"

elif [[  "$1" == "px3se"  ]]; then
	glmark2-es2-wayland --off-screen
else
	echo "please check if the linux support it!!!!!!!"
fi
}

COMPATIBLE=$(cat /proc/device-tree/compatible)
if [[ $COMPATIBLE =~ "rk3288" ]]; then
    CHIPNAME="rk3288"
elif [[ $COMPATIBLE =~ "rk3308" ]]; then
    CHIPNAME="rk3308"
elif [[ $COMPATIBLE =~ "rk3328" ]]; then
    CHIPNAME="rk3328"
elif [[ $COMPATIBLE =~ "rk3399" ]]; then
    CHIPNAME="rk3399"
elif [[ $COMPATIBLE =~ "rk3326" ]]; then
    CHIPNAME="rk3326"
elif [[ $COMPATIBLE =~ "rk3399" ]]; then
    CHIPNAME="rk3399"
elif [[ $COMPATIBLE =~ "rk3399" && $COMPATIBLE =~ "rk3399pro"]]; then
    CHIPNAME="rk3399pro"
elif [[ $COMPATIBLE =~ "rk1808" ]]; then
    CHIPNAME="rk1808"
elif [[ $COMPATIBLE =~ "px3se" ]]; then
    CHIPNAME="px3se"
else
    CHIPNAME="rk3399"
fi
COMPATIBLE=${COMPATIBLE#rockchip,}

echo performance | tee $(find /sys/ -name *governor)

echo "run glmark2 wayland with offscreen......"
export XDG_RUNTIME_DIR=/tmp/.xdg
run_glmark2 ${CHIPNAME}

echo "the governor is performance for now, please restart it........"
