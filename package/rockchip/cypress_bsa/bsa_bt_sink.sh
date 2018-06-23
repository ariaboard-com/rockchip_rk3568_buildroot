#!/bin/sh

hcd_file="BTFIRMWARE_PATH"
echo "hcd_file = $hcd_file"

case "$1" in
    start)

    echo 0 > /sys/class/rfkill/rfkill0/state
    sleep 3
    echo 1 > /sys/class/rfkill/rfkill0/state
    sleep 3

    mkdir /data/bsa 2>/dev/null
    mkdir /data/bsa/config 2>/dev/null
    mkdir /mnt/udisk/bsa
    cd /data/bsa/config
    echo "start broadcom bluetooth server bsa_sever"
    killall bsa_server
    bsa_server -r 12 -b /mnt/udisk/bsa/btsnoop.log -p $hcd_file -d /dev/ttyS4 > /mnt/udisk/bsa/bsa_log &
    sleep 2

    echo "start broadcom bluetooth app_manager"
    app_manager -s > /mnt/udisk/bsa/app_mananger.log &

    echo "start broadcom bluetooth app_avk"
    app_avk -s > /mnt/udisk/bsa/app_avk.log &
    sleep 1


    echo "#########act as a bluetooth music player#########"
    app_socket avk 2
    cd - > /dev/null
    sleep 2
    echo "|----- bluetooth music player ------|"

        ;;
    stop)
        echo -n "Stopping broadcom bsa bluetooth server & app"
        sleep 1
        sleep 2
        echo 0 > /sys/class/rfkill/rfkill0/state
        echo "|-----bluetooth music player is close-----|"

        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
esac

exit $?

