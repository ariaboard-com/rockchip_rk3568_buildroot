#!/bin/bash -e

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

echo performance | tee $(find /sys/ -name *governor)

export XDG_RUNTIME_DIR=/tmp/.xdg
export export QT_QPA_PLATFORM=wayland

touch /dev/video-dec0
ln -sf /usr/lib/libmali.so /usr/lib/libMali.so.1

if [ -e "/usr/lib/qt/examples/webenginewidgets/simplebrowser" ] ;
then
	cd /usr/lib/qt/examples/webenginewidgets/simplebrowser
	./simplebrowser --no-sandbox --disable-es3-gl-context
	#./simplebrowser --no-sandbox --disable-es3-gl-context https://www.baidu.com
	#./simplebrowser --no-sandbox --disable-es3-gl-context "file:///oem/SampleVideo_1280x720_5mb.mp4"
	#./simplebrowser --no-sandbox --disable-es3-gl-context --enable-logging --v=5 "file:///oem/SampleVideo_1280x720_5mb.mp4"
else
	echo "Please sure the config/rockchip_xxxx_defconfig include "chromium.config"........"
fi
echo "the governor is performance for now, please restart it........"
