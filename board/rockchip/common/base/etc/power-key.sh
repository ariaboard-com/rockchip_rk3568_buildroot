#!/bin/sh

EVENT=${1:-short-press}

TIMEOUT=3 # s
PIDFILE="/tmp/$(basename $0).pid"
LOCKFILE=/tmp/.power_key

power_key_led_blink()
{
    echo 0 > /sys/class/leds/firefly:blue:power/brightness
    echo 0 > /sys/class/leds/firefly:yellow:user/brightness
    sleep 1
    echo 1 > /sys/class/leds/firefly:blue:power/brightness
    echo 1 > /sys/class/leds/firefly:yellow:user/brightness
    sleep 1
    echo 0 > /sys/class/leds/firefly:blue:power/brightness
    echo 0 > /sys/class/leds/firefly:yellow:user/brightness
    sleep 1
    echo 1 > /sys/class/leds/firefly:blue:power/brightness
    echo 1 > /sys/class/leds/firefly:yellow:user/brightness
}

short_press()
{
	power_key_led_blink
}

long_press()
{
	logger -t $(basename $0) "[$$]: Power key long press (${TIMEOUT}s)..."

	logger -t $(basename $0) "[$$]: Prepare to power off..."

	poweroff
}

logger -t $(basename $0) "[$$]: Received power key event: $@..."

case "$EVENT" in
	press)
		ifconfig wlan0 down&
		# Lock it
		exec 3<$0
		flock -x 3

		start-stop-daemon -K -q -p $PIDFILE || true
		start-stop-daemon -S -q -b -m -p $PIDFILE -x /bin/sh -- \
			-c "sleep $TIMEOUT; $0 long-press"

		# Unlock
		flock -u 3
		;;
	release)
		# Avoid race with press event
		sleep .5

		start-stop-daemon -K -q -p $PIDFILE && short_press
		ifconfig wlan0 up&
		;;
	short-press)
		short_press
		;;
	long-press)
		long_press
		;;
esac
