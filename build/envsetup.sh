#!/bin/bash

if [ -z "${BASH_SOURCE}" ];then
	echo Not in bash, switching to it...
	bash -c "$0" "$@"
fi

function choose_board()
{
	echo
	echo "You're building on Linux"
	echo "Lunch menu...pick a combo:"
	echo ""

	echo ${DEFCONFIG_ARRAY[@]} | xargs -n 1 | sed "=" | sed "N;s/\n/. /"

	local INDEX
	while true; do
		read -p "Which would you like? [1]: " INDEX
		INDEX=$((${INDEX:-1} - 1))

		if echo $INDEX | grep -vq [^0-9]; then
			TARGET_BUILD_CONFIG="${DEFCONFIG_ARRAY[$INDEX]}"
			[ -n "$TARGET_BUILD_CONFIG" ] && break
		fi

		echo
		echo "Choice not available. Please try again."
		echo
	done
}

function lunch()
{
	TARGET_DIR_NAME="$TARGET_BUILD_CONFIG"
	export TARGET_OUTPUT_DIR="$BUILDROOT_OUTPUT_DIR/$TARGET_DIR_NAME"

	mkdir -p $TARGET_OUTPUT_DIR || return

	echo "==========================================="
	echo
	echo "#TARGET_BOARD=`echo $TARGET_BUILD_CONFIG | cut -d '_' -f 2`"
	echo "#OUTPUT_DIR=output/$TARGET_DIR_NAME"
	echo "#CONFIG=${TARGET_BUILD_CONFIG}_defconfig"
	echo
	echo "==========================================="

	make -C ${BUILDROOT_DIR} O="$TARGET_OUTPUT_DIR" \
		"$TARGET_BUILD_CONFIG"_defconfig

	CONFIG=${TARGET_OUTPUT_DIR}/.config
	cp ${CONFIG}{,.new}
	mv ${CONFIG}{.old,} &>/dev/null

	make -C ${BUILDROOT_DIR} O="$TARGET_OUTPUT_DIR" olddefconfig &>/dev/null

	if ! diff ${CONFIG}{,.new}; then
		read -p "Found old config, override it? (y/n):" YES
		[ "$YES" = "y" ] && cp ${CONFIG}{.new,}
	fi
}

function main()
{
	SCRIPT_PATH=$(realpath ${BASH_SOURCE})
	SCRIPT_DIR=$(dirname ${SCRIPT_PATH})
	BUILDROOT_DIR=$(dirname ${SCRIPT_DIR})
	BUILDROOT_OUTPUT_DIR=${BUILDROOT_DIR}/output
	TOP_DIR=$(dirname ${BUILDROOT_DIR})
	source ${TOP_DIR}/device/rockchip/.BoardConfig.mk
	echo Top of tree: ${TOP_DIR}

	# Set croot alias
	alias croot="cd ${TOP_DIR}"

	DEFCONFIG_ARRAY=(
		$(cd ${BUILDROOT_DIR}/configs/; ls rockchip_* | \
			sed "s/_defconfig$//" | grep "$1" | sort)
	)

	DEFCONFIG_ARRAY_LEN=${#DEFCONFIG_ARRAY[@]}
	if [ $DEFCONFIG_ARRAY_LEN -eq 0 ]; then
		echo No available configs${1:+" for: $1"}
		return
	fi

	if [ -n "$1" ]; then
		TARGET_BUILD_CONFIG=${DEFCONFIG_ARRAY[0]}
	else
		choose_board
	fi
	[ -n "$TARGET_BUILD_CONFIG" ] || return

	lunch
}

if [ "${BASH_SOURCE}" == "$0" ];then
	echo This script is executed directly...
	bash -c "source \"$0\" \"$@\"; bash"
else
	main "$@"
fi
