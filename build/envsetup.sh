#!/bin/bash

if [ -z "${BASH_SOURCE}" ];then
	echo Not in bash, switch to it...
	bash -c $0
fi

function get_target_board_type() {
	echo $1 | cut -d '_' -f 2
}

function choose_type()
{
	echo
	echo "You're building on Linux"
	echo "Lunch menu...pick a combo:"
	echo ""

	echo ${DEFCONFIG_ARRAY[@]} | xargs -n 1 | sed "=" | sed "N;s/\n/. /"

	local DEFAULT_NUM
	DEFAULT_NUM=1

	unset TARGET_BUILD_CONFIG
	local ANSWER
	while [ -z "$TARGET_BUILD_CONFIG" ]
	do
		echo -n "Which would you like? ["$DEFAULT_NUM"] "
		if [ -z "$1" ]; then
			read ANSWER
		else
			echo $1
			ANSWER=$1
		fi

		if [ -z "$ANSWER" ]; then
			ANSWER="$DEFAULT_NUM"
		fi

		if ! echo $ANSWER | grep -q [^0-9]; then
			if [ $ANSWER -le $DEFCONFIG_ARRAY_LEN ]; then
				index=$((${ANSWER}-1))
				TARGET_BUILD_CONFIG="${DEFCONFIG_ARRAY[$index]}"
			else
				echo
				echo "number not in range. Please try again."
				echo
			fi
		else
			echo $ANSWER
			TARGET_BUILD_CONFIG="$ANSWER"
		fi

		if [ -n "$1" ]; then
			break
		fi
	done

	TARGET_DIR_NAME="$TARGET_BUILD_CONFIG"
	export TARGET_OUTPUT_DIR="$BUILDROOT_OUTPUT_DIR/$TARGET_DIR_NAME"
}

function lunch()
{
	mkdir -p $TARGET_OUTPUT_DIR
	if [ -z "$TARGET_BUILD_CONFIG" ]; then
		return;
	fi

	echo "==========================================="
	echo
	echo "#TARGET_BOARD=`get_target_board_type $TARGET_BUILD_CONFIG`"
	echo "#OUTPUT_DIR=output/$TARGET_DIR_NAME"
	echo "#CONFIG=${TARGET_BUILD_CONFIG}_defconfig"
	echo
	echo "==========================================="

	make -C ${BUILDROOT_DIR} O="$TARGET_OUTPUT_DIR" \
		"$TARGET_BUILD_CONFIG"_defconfig

	OLD_CONF=${TARGET_OUTPUT_DIR}/.config.old
	CONF=${TARGET_OUTPUT_DIR}/.config
	if diff ${OLD_CONF} ${CONF} 2>/dev/null|grep -qE "is not set$|=y$";then
		read -p "Found old config, override it? (y/n):" YES
		[ "$YES" != y ] && cp ${OLD_CONF} ${CONF}
	fi
}

if [ "${BASH_SOURCE}" == "$0" ];then
	echo This script is executed directly...
	bash -c "source ${BASH_SOURCE}; bash"
else
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
	$(cd ${BUILDROOT_DIR}/configs/; ls -v rockchip_* | sed "s/_defconfig$//")
	)

	DEFCONFIG_ARRAY_LEN=${#DEFCONFIG_ARRAY[@]}

	choose_type $@
	lunch
fi
