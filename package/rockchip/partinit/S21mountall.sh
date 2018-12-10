#!/bin/sh

# Uncomment below to see more logs
# set -x

check_tool()
{
	TOOL=$1
	CONFIG=$2

	type $TOOL >/dev/null && return 0

	[ -n "$CONFIG" ] && echo "You may need to enable $CONFIG"
	return 1
}

resize_e2fs()
{
	DEV=$1
	MOUNT_POINT=$2
	PART_NAME=$3

	check_tool dumpe2fs BR2_PACKAGE_E2FSPROGS || return
	LABEL=$(dumpe2fs -h $DEV | grep "volume name:" | grep -o "[^ ]*$")
	[ $? -eq 0 ] || { echo "Wrong fs type!"; return; }

	# Use volume label to mark resized
	echo "$LABEL" |grep -wq "$PART_NAME" && { echo "Already resized"; return; }

	check_tool e2fsck BR2_PACKAGE_E2FSPROGS_FSCK || return
	check_tool resize2fs BR2_PACKAGE_E2FSPROGS_RESIZE2FS || return

	# Do an initial fsck as resize2fs required.
	if ! mountpoint -q $MOUNT_POINT;then
		if ! e2fsck -fy $DEV;then
			echo "Error detected"
			e2fsck -y $DEV
		fi
		[ $? -eq 0 ] || { echo "Fatal error(cannot recover)!"; return; }
	fi

	# Force using online resize, see:
	# https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/1796788.
	TEMP=$(mktemp -d)
	mount $DEV $TEMP || return
	resize2fs $DEV

	# The online resize is unavailable when kernel disabled ext4.
	# So let's fallback to format it.
	if [ $? -ne 0 -a $MOUNT_POINT != "/" ];then
		echo "Unable to resize $DEV, formatting it..."

		# Backup original data
		tar cvf /tmp/${PART_NAME}.tar $TEMP >/dev/null
		umount $TEMP

		mkfs.ext2 $DEV || return

		# Restore backup data
		mount $DEV $TEMP
		tar xvf /tmp/${PART_NAME}.tar -C / >/dev/null
		rm /tmp/${PART_NAME}.tar
	fi

	umount $TEMP

	# Use volume label to mark resized
	tune2fs $DEV -L $PART_NAME
}

resize_fatresize()
{
	DEV=$1
	SIZE=$2
	MAX_SIZE=$3

	check_tool fatresize BR2_PACKAGE_FATRESIZE || return 1

	# Somehow fatresize only works for 256M+ fat
	[ ! $SIZE -gt $((256 * 1024 * 1024)) ] && return 1

	MIN_SIZE=$(($MAX_SIZE - 16 * 1024 * 1024))
	[ $MIN_SIZE -lt $SIZE ] && MIN_SIZE=$SIZE
	while [ $MAX_SIZE -gt $MIN_SIZE ];do
		# Somehow fatresize cannot resize to max size
		MAX_SIZE=$(($MAX_SIZE - 512 * 1024))

		# Try to resize with fatresize, not always work
		fatresize -s $MAX_SIZE $DEV && return 0
	done

	return 1
}

resize_fat()
{
	DEV=$1
	PART_NAME=$3
	MAX_SIZE=$4

	check_tool fatlabel BR2_PACKAGE_DOSFSTOOLS_FATLABEL || return
	LABEL=$(fatlabel $DEV)
	[ $? -eq 0 ] || { echo "Wrong fs type"; return; }

	# Use volume label to mark resized
	echo "$LABEL" |grep -wq "$PART_NAME" && { echo "Already resized"; return; }

	# Prefer to format it when possible
	TEMP=$(mktemp -d)
	mount $DEV $TEMP || return

	SIZE=$(df $TEMP|tail -1|awk '{ print $2 }')
	USED_SIZE=$(df $TEMP|tail -1|awk '{ print $3 }')
	TEMP_SIZE=$(df /tmp/|tail -1|awk '{ print $4 }')
	if [ $USED_SIZE -lt $TEMP_SIZE ]; then
		echo "Formatting it..."

		# Backup original data
		tar cvf /tmp/${PART_NAME}.tar $TEMP >/dev/null
		umount $TEMP

		mkfs.fat $DEV && FORMATTED=true

		# Restore backup data
		mount $DEV $TEMP
		tar xvf /tmp/${PART_NAME}.tar -C / >/dev/null
		rm /tmp/${PART_NAME}.tar
	fi

	umount $TEMP

	# Try fatresize (might not work though)
	if [ -z "$FORMATTED" ]; then
		resize_fatresize $DEV $SIZE $MAX_SIZE && FORMATTED=true
	fi

	# Use volume label to mark resized
	if [ -n "$FORMATTED" ]; then
	       fatlabel $DEV $PART_NAME
       else
	       echo "Resize failed"
       fi
}

resize_ntfs()
{
	DEV=$1
	PART_NAME=$3
	MAX_SIZE=$4

	check_tool ntfslabel BR2_PACKAGE_NTFS_3G_NTFSPROGS || return
	LABEL=$(ntfslabel $DEV)
	[ $? -eq 0 ] || { echo "Wrong fs type"; return; }

	# Use volume label to mark resized
	echo "$LABEL" |grep -wq "$PART_NAME" && { echo "Already resized"; return; }

	echo y | ntfsresize -f $DEV || { echo "Resize failed"; return; }

	# Use volume label to mark resized
	ntfslabel $DEV $PART_NAME
}

do_resize()
{
	# Not enough args
	[ $# -lt 3 ] && return

	# Ignore comments
	echo $1 |grep -q "^#" && return

	DEV=$1
	MOUNT_POINT=$2
	FSTYPE=$3

	# Find real dev for root dev
	if [ "$MOUNT_POINT" == '/' ];then
		DEV=$(mountpoint -n /|cut -d ' ' -f 1)
	fi

	DEV=$(realpath $DEV 2>/dev/null)

	# Unknown device
	[ -b "$DEV" ] || return

	SYS_PATH=/sys/class/block/${DEV##*/}
	MAX_SIZE=$(( $(cat ${SYS_PATH}/size) * 512))
	PART_NAME=$(grep PARTNAME ${SYS_PATH}/uevent | cut -d '=' -f 2)

	echo Resizing $DEV $MOUNT_POINT $FSTYPE...

	case $FSTYPE in
		ext[234])
			check_tool fsck.ext4 BR2_PACKAGE_E2FSPROGS_FSCK
			resize_e2fs $DEV $MOUNT_POINT $PART_NAME $MAX_SIZE
			return
			;;
		msdos|fat|vfat)
			check_tool fsck.fat BR2_PACKAGE_DOSFSTOOLS_FSCK_FAT
			resize_fat $DEV $MOUNT_POINT $PART_NAME $MAX_SIZE
			return
			;;
		ntfs)
			check_tool fsck.ntfs BR2_PACKAGE_NTFS_3G_NTFSPROGS
			resize_ntfs $DEV $MOUNT_POINT $PART_NAME $MAX_SIZE
			return
			;;
	esac

	# Unsupported file system
}

resizeall()
{
	echo "Will now resize all file systems"
	while read LINE;do
		do_resize $LINE
	done < /etc/fstab
}

checkall()
{
	grep -wq "force_fsck" /proc/cmdline && FORCE_FSCK="-f"
	grep -wq "no_force_fsck" /proc/cmdline && unset FORCE_FSCK

	# Uncomment below to enable force fsck
	# FORCE_FSCK="-f"

	if [ "$1" ];then
		FSCKTYPES_OPT="-t $1"
		echo "Will now check all file systems of types $1"
	else
		echo "Will now check all file systems"
	fi

	SKIP_FSCK="/var/.skip_fsck"
	if [ -f $SKIP_FSCK ];then
		echo "Skipped, remove $SKIP_FSCK to enable it again"
		return
	else
		echo "Create $SKIP_FSCK to skip the check"
		echo "This might take awhile if it didn't shutdown properly!"
	fi

	fsck -ARy $FORCE_FSCK $FSCKTYPES_OPT
}

mountall()
{
	if [ "$1" ];then
		MOUNTTYPES_OPT="-t $1"
		echo "Will now mount all file systems of types $1"
	else
		echo "Will now mount all file systems"
	fi
	mount -a $MOUNTTYPES_OPT
}

is_recovery()
{
	# Recovery's rootfs is ramfs
	mountpoint -d /|grep -wq 0:1
}

case "$1" in
  start|"")
	RESIZE_LOG=/tmp/resizefs.log
	CHECK_LOG=/tmp/checkfs.log
	MOUNT_LOG=/tmp/mountfs.log

	SYS_BASE_FSTYPES="proc,devpts,tmpfs,sysfs,debugfs,pstore"

	# Mount /tmp firstly to save logs
	mountpoint -q /tmp || mount -t tmpfs tmpfs /tmp

	if is_recovery;then
		# Only mount basic file systems for recovery
		mountall $SYS_BASE_FSTYPES 2>&1 | tee $MOUNT_LOG
		echo Log saved to $MOUNT_LOG
	else
		resizeall 2>&1 | tee $RESIZE_LOG
		echo Log saved to $RESIZE_LOG
		checkall 2>&1 | tee $CHECK_LOG
		echo Log saved to $CHECK_LOG
		mountall 2>&1 | tee $MOUNT_LOG
		echo Log saved to $MOUNT_LOG
	fi
	;;
  restart|reload|force-reload)
	echo "Error: argument '$1' not supported" >&2
	exit 3
	;;
  stop|status)
	# No-op
	;;
  *)
	echo "Usage: [start|stop]" >&2
	exit 3
	;;
esac

:
