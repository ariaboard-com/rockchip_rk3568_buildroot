#!/bin/sh

TYPE=`blkid /dev/$1 | awk -F '"' '{print $4}'`

if [ "${TYPE}" == "exfat" ] ;then
        mount.exfat /dev/$1 /mnt/sdcard
elif [ "${TYPE}" == "ntfs" ] ;then
        mount.ntfs-3g /dev/$1 /mnt/sdcard
else
        mount /dev/$1 /mnt/sdcard
fi

echo /dev/$1 > /sys/kernel/config/usb_gadget/g1/functions/mass_storage.0/lun.0/file

sync
