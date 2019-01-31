#!/bin/sh

/etc/init.d/S50launcher stop
sleep 1

export QT_QPA_PLATFORM=wayland-egl
export XDG_RUNTIME_DIR=/tmp/
export QT_GSTREAMER_WIDGET_VIDEOSINK=waylandsink
export QT_GSTREAMER_WINDOW_VIDEOSINK=waylandsink
export WAYLANDSINK_PLACE_ABOVE=1
weston --tty=2&
sleep 1

case "$1" in
	test)
		./videowidget file:///oem/SampleVideo_1280x720_5mb.mp4&
		sleep 1
		./videowidget file:///oem/SampleVideo_1280x720_5mb.mp4&
		sleep 1
		./videowidget file:///oem/SampleVideo_1280x720_5mb.mp4&
		sleep 1
		./videowidget file:///oem/SampleVideo_1280x720_5mb.mp4&
		;;
	$1)
		./videowidget file:///$1&
		sleep 1
		./videowidget file:///$1&
		sleep 1
		./videowidget file:///$1&
		sleep 1
		./videowidget file:///$1&
		;;
esac
shift
