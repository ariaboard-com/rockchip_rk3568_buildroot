#!/bin/bash

if [ -z "${BASH_SOURCE}" ];then
	echo Not in bash, switch to it...
	bash -c $0
fi

function get_target_board_type() {
	TARGET=$1
	RESULT="$(echo $TARGET | cut -d '_' -f 2)"
	echo "$RESULT"
}

function get_build_config() {
	TARGET=$1
	RESULT1="$(echo $TARGET | cut -d '_' -f 3)"
	RESULT2="$(echo $TARGET | cut -d '_' -f 4)"
	if [[ $RESULT1 = "debug" ]]; then
		echo "${DEFCONFIG_ARRAY[$index]}"
	elif [[ $RESULT1 = "release" ]]; then
		echo "${DEFCONFIG_ARRAY[$index]}"
	elif [[ $RESULT2 = "debug" ]]; then
		echo "${DEFCONFIG_ARRAY[$index]}"
	elif [[ $RESULT2 = "release" ]]; then
		echo "${DEFCONFIG_ARRAY[$index]}"
	else
		echo "${DEFCONFIG_ARRAY[$index]}"
	fi
}

function get_defconfig_name() {
	echo $TARGET_DIR_NAME
}

# Checking the file "buildroot/configs/*_defconfig"
# If it contian of "_32_","_32","32_", and return build_type is 32 bit
# Else return 64 bit
function get_target_build_type() {
	TARGET=$1

	TARGET=${TARGET}_defconfig
	if [ "${TARGET#*_32_}" == "${TARGET}"  -a "${TARGET#*32_}" == "${TARGET}" -a "${TARGET#*_32}" == "${TARGET}" ]; then
		echo "64"
	else
		echo "32"
	fi
}

function choose_type()
{
	echo
	echo "You're building on Linux"
	echo "Lunch menu...pick a combo:"
	echo ""

	i=0
	for conf in ${DEFCONFIG_ARRAY[@]}
	do
		let ++i
		echo "$i. $conf"
	done
	echo

	local DEFAULT_NUM
	DEFAULT_NUM=1

	export TARGET_BUILD_TYPE=
	local ANSWER
	while [ -z $TARGET_BUILD_TYPE ]
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

		if [ -n "`echo $ANSWER | sed -n '/^[0-9][0-9]*$/p'`" ]; then
			if [ $ANSWER -le $DEFCONFIG_ARRAY_LEN ] && [ $ANSWER -gt 0 ]; then
				index=$((${ANSWER}-1))
				TARGET_BUILD_CONFIG=`get_build_config ${DEFCONFIG_ARRAY[$index]}`
				TARGET_DIR_NAME="${DEFCONFIG_ARRAY[$index]}"
				TARGET_BUILD_TYPE=`get_target_build_type ${DEFCONFIG_ARRAY[$index]}`
				TARGET_BOARD_TYPE=`get_target_board_type ${DEFCONFIG_ARRAY[$index]}`
			else
				echo
				echo "number not in range. Please try again."
				echo
			fi
		else
			echo $ANSWER
			TARGET_BUILD_CONFIG="$ANSWER"
			TARGET_DIR_NAME="$ANSWER"
			TARGET_BUILD_TYPE=`get_target_build_type $ANSWER`
			TARGET_BOARD_TYPE=`get_target_board_type $ANSWER`
		fi
		if [ -n "$1" ]; then
			break
		fi
	done
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
	echo "#TARGET_BOARD=${TARGET_BOARD_TYPE}"
	echo "#BUILD_TYPE=${TARGET_BUILD_TYPE}"
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

	if [ -z "$index" ]; then
		return
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
