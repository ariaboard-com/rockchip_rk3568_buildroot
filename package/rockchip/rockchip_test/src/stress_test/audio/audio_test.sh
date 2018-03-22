#!/bin/sh

PROCESS="aplay"
DELAYS=3
TEST_CASE=8

taskkill()
{
	if [ $# -ne 2 ]; then
	  PID=`ps ax | grep $1 | awk '{if ($0 !~/grep/) {print $1}}'`
		#echo "PID=$PID"
		if [ -n "$PID" ]; then
			kill -9 $PID >/dev/null 2>&1
                        return 0
		else
			return 1
		fi
	fi
	return 1
}

delay()
{
	local index=$1
	if [ $# -ne 2 ]; then
		while [ $index -gt 0 ]
		do
		   sleep 1
	           #index=$[ $index -1 ]
	           let index-=1
		   echo -n "."
		done
		echo "stop"
                echo ""
		return 0
	fi
	return 1
}


mount_u_disk()
{
	#check udisk insert or not
	ls /dev/sda1
	while [ $? -ne 0 ]
	do
        echo "please insert your u disk."
		sleep 2
		ls /dev/sda1
	done
	echo "u disk inserted ."
}

pdm_in()
{
	local channel=8
	if [ $# -ne 1 ]; then
	#mount -t vfat  /dev/sda1 /mnt
	rm /mnt/pdm_in_dir -rf
	mkdir -p /mnt/pdm_in_dir
	echo "******************start PDM_IN test**************************"
	#set 8000 16000 44100 48000
	ratelist="8000 16000 44100 48000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 1 ]
	do
		for i in $ratelist
        	do
			for j in $bitlist
			do
				echo "channel="$channel",rate="$i",bit=$j"
				aplay -C -Dhw:0,3 -r $i -f $j -t wav -c $channel /mnt/pdm_in_dir/tdm_out_ch${channel}_r${i}_$j.wav &
				delay $DELAYS
				kill_task
			done
		done
		let channel=channel/2
	done
	#umount /mnt
	echo "*********************stop PDM_IN test*************************"
	fi
}

tdm_in()
{
	local channel=8
	if [ $# -ne 1 ]; then
	#mount -t vfat  /dev/sda1 /mnt
	rm /mnt/tdm_in_dir -rf
	mkdir -p /mnt/tdm_in_dir
	echo ""
	echo ""
	echo ""
	echo "******************start TDM_IN test**************************"
	#set 8000 16000 44100 48000
        ratelist="8000 16000 44100 48000"
        bitlist="S16_LE S32_LE"
	while [ $channel -ge 1 ]
	do
		for i in $ratelist
        	do
			for j in $bitlist
			do
				echo "channel="$channel",rate="$i",bit=$j"
				aplay -C -Dhw:0,1 -r $i -f $j -t wav -c $channel /mnt/tdm_in_dir/tdm_in_ch${channel}_r${i}_$j.wav &
				delay $DELAYS
				kill_task
			done
		done
		let channel=channel-1
	done
	#umount /mnt
	echo "*********************stop TDM_IN test*************************"
	fi
}

tdm_out()
{
	local channel=8
	if [ $# -ne 3 ]; then
	#mount -t vfat  /dev/sda1 /mnt
#	echo ""
#	echo ""
#	echo ""
#	echo "******************start TDM_OUT test**************************"
	#set 8000 16000 44100 48000 96000 192000 384000
	#set S16_LE S24_LE S32_LE
	ratelist="8000 16000 44100 48000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 1 ]
	do
		for i in $ratelist
        	do
			for j in $bitlist
			do
				echo "channel="$channel",rate="$i",bit=$j"
				aplay -Dhw:0,2 /mnt/$1/$2_ch${channel}_r${i}_$j.wav &
				delay $DELAYS
				kill_task
			done
		done
		let channel=channel-1
	done
	#umount /mnt
#	echo "*********************stop TDM_OUT test*************************"
	fi
}

tdm_in_tdm_out()
{
    echo ""
    echo ""
    echo ""
    echo "******************start TDM_IN_TDM_OUT test**************************"
	#tdm_out tdm_in_dir  tdm_in

	#set 8000 16000 44100 48000
	local channel=8
	ratelist="8000 16000 44100 48000"
	bitlist="S16_LE S32_LE"
    while [ $channel -ge 2 ]
	do
		for i in $ratelist
        do
			for j in $bitlist
			do
				echo "channel="$channel",rate="$i",bit=$j"
				aplay -C -Dhw:0,1 -r $i -f $j -t wav -c $channel | aplay  -Dhw:0,2 &
				delay $DELAYS
                kill_task
			done
		done
		let channel=channel-1
	done
    echo "*********************stop TDM_IN_TDM_OUT test*************************"
}

pdm_in_tdm_out_line_out()
{
    echo ""
	echo ""
	echo ""
	echo "******************start PDM_IN_TDM_OUT test**************************"
	#tdm_out pdm_in_dir pdm_in

	#mkdir pdm_in_tdm_out_line_out
	mkdir /mnt/pdm_in_tdm_out_line_out


	#set 8000 16000 44100 48000
	local channel=2
	ratelist="8000 16000 44100 48000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 1 ]
	do
		for i in $ratelist
        do
			for j in $bitlist
			do
				echo "channel="$channel",rate="$i",bit=$j"
				arecord  -C -Dhw:0,3 -r $i -f $j  -c $channel -d 2 /mnt/pdm_in_tdm_out_line_out/test${i}_${j}.wav
				aplay -Dhw:0,2 /mnt/pdm_in_tdm_out_line_out/test${i}_${j}.wav 
				delay $DELAYS
				kill_task
			done
		done
		if [ "${channel}"x == "2"x ]
		then
			echo "last channel."
			break
		else
		    let channel=channel/2
		fi
	done
	echo "*********************stop PDM_IN_TDM_OUT test*************************"
}

line_in_line_out()
{
	local channel=2
	if [ $# -ne 2 ]; then
	#mount -t vfat  /dev/sda1 /mnt
	echo ""
	echo ""
	echo ""
	echo "******************start LINE_IN and LINE_OUT  test**************************"

    mkdir /mnt/line_in_line_out

	#set 8000 16000 44100 48000 96000
	#set S16_LE S24_LE S32_LE
	ratelist="8000 16000 44100 48000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 1 ]
	do
		for i in $ratelist
        	do
			for j in $bitlist
			do
				echo "channel="$channel",rate="$i",bit=$j"
				arecord  -C -Dhw:0,2 -r $i -f $j  -c $channel -d 2 /mnt/line_in_line_out/test${i}_${j}.wav
				aplay -Dhw:0,2 /mnt/line_in_line_out/test${i}_${j}.wav
				#aplay -C -Dhw:0,2 -r $i -f $j -c 2 | aplay  -Dhw:0,2 &
				delay 10
				kill_task
			done
		done
		if [ "${channel}"x == "2"x ]
		then
			echo "last channel."
			break
		else
		    let channel=channel/2
	    fi
	done
	#umount /mnt
	echo "*********************stop LINE_IN and LINE_OUT test*************************"
	fi
}

spdif_in_spdif_out()
{
    echo ""
    echo ""
    echo ""
    echo "******************start SPDIF_IN_SPDIF_OUT test**************************"
	echo ""
	echo "(^_^)"
	echo ""
    echo "*********************stop SPDIF_IN_SPDIF_OUT test*************************"
}


kill_task()
{
	while true
	do
		taskkill $PROCESS
		ret=$?
		if [ $ret -eq 1 ]; then
		break
		fi
	done
}

tdm_a_dummy()
{
	local channel=2
	if [ $# -ne 1 ]; then
	#mount -t vfat  /dev/sda1 /mnt
	rm /tmp/bat.wav.*
	rm /mnt/tdm_a_dummy_dir -rf
	mkdir -p /mnt/tdm_a_dummy_dir
	echo "******************start tdm_a_dummy test**************************"
	#set 8000 16000 44100 48000
	ratelist="8000 16000 44100 48000 96000 192000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 2 ]
	do
		for i in $ratelist
            do
			for j in $bitlist
			do
				echo ""
				echo ""
				echo "channel="$channel",rate="$i",bit=$j"
				alsabat -Dplughw:0,0 -c $channel -r $i -f $j
				cp /tmp/bat.wav.* /mnt/tdm_a_dummy_dir/tdm_a_dummy_ch${channel}_r${i}_$j.wav
				rm /tmp/bat.wav.*
			done
		done
		let channel=channel/2
	done
	#umount /mnt
	echo "*********************stop tdm_a_dummy test*************************"
	fi
}

tdm_b_dummy()
{
	local channel=2
	if [ $# -ne 1 ]; then
	#mount -t vfat  /dev/sda1 /mnt
	rm /tmp/bat.wav.*
	rm /mnt/tdm_b_dummy_dir -rf
	mkdir -p /mnt/tdm_b_dummy_dir
	echo ""
	echo ""
	echo ""
	echo "******************start tdm_b_dummy test**************************"
	#set 8000 16000 44100 48000
	ratelist="8000 16000 44100 48000 96000 192000 384000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 2 ]
	do
		for i in $ratelist
        do
			for j in $bitlist
			do
				echo ""
				echo ""
				echo "channel="$channel",rate="$i",bit=$j"
				alsabat -Dplughw:0,1 -c $channel -r $i -f $j
				cp /tmp/bat.wav.* /mnt/tdm_b_dummy_dir/tdm_b_dummy_ch${channel}_r${i}_$j.wav
				rm /tmp/bat.wav.*
			done
		done
		let channel=channel/2
	done
	#umount /mnt
	echo "*********************stop tdm_b_dummy test*************************"
	fi
}
tdm_c_dummy()
{
	local channel=2
	if [ $# -ne 1 ]; then
	#mount -t vfat  /dev/sda1 /mnt
	rm /tmp/bat.wav.*
	rm /mnt/tdm_c_dummy_dir -rf
	mkdir -p /mnt/tdm_c_dummy_dir
	echo "******************start tdm_c_dummy test**************************"
	#set 8000 16000 44100 48000
	ratelist="8000 16000 44100 48000 96000 192000"
	bitlist="S16_LE S24_LE S32_LE"

	while [ $channel -ge 2 ]
    do
		for i in $ratelist
            do
			for j in $bitlist
			do
				echo ""
				echo ""
				echo "channel="$channel",rate="$i",bit=$j"
				alsabat -Dplughw:0,2 -c $channel -r $i -f $j
				cp /tmp/bat.wav.* /mnt/tdm_c_dummy_dir/tdm_c_dummy_ch${channel}_r${i}_$j.wav
				rm /tmp/bat.wav.*
			done
		done
		let channel=channel/2
	done
	#umount /mnt
	echo "*********************stop tdm_c_dummy test*************************"
	fi
}


echo 0 > /proc/sys/kernel/printk
echo ""
echo "****************************************************"
echo "*     Amlogic A113 Platform Audio Case Test        *"
echo "****************************************************"
echo "*   pdm in and tdm_line out test:   [0]            *"
#echo "*   pdm in test                     [1]            *"
#echo "*   tdm out test:                   [2]            *"
#echo "*   tdm in and tdm out test:        [3]            *"
#echo "*   pdm in and tdm out test:        [4]            *"
echo "*   line in and line out test:      [1]            *"
#echo "*   spdif in and spdif out test:    [6]            *"
#echo "*   tdm_A_dummy test:               [2]            *"
#echo "*   tdm_B_dummy test:               [3]            *"
#echo "*   tdm_C_dummy test:               [4]            *"
echo "*   exit shell test:                [q]            *"
echo "****************************************************"

echo ""
echo -n  "choice your case:"
read TEST_CASE

# u disk init
mount_u_disk

#

case $TEST_CASE in
    "0")
		pdm_in_tdm_out_line_out
        #tdm_in
    ;;
    "1")
		line_in_line_out
		#pdm_in
    ;;
    "2")
        tdm_a_dummy
	#echo ""
	#echo ""
	#echo ""
    #    echo "******************start TDM_OUT test**************************"
    #    tdm_out pcm_dir tdm_out
    #    echo "******************stop TDM_OUT test**************************"
    ;;
    "3")
		tdm_b_dummy
        #itdm_in_tdm_out tdm_in_dir
    ;;
    "4")
		tdm_c_dummy
       # pdm_in_tdm_out pdm_in_dir
    ;;
    "q")
 		echo "exit!"
 		#line_in_line_out
    ;;
##   "6")
#        spdif_in_spdif_out
#    ;;
#    "7")
#	tdm_a_dummy
#    ;;
#    "8")
#	tdm_b_dummy
#    ;;
#    "9")
#	tdm_c_dummy
#    ;;
#    "q")
#	echo "exit!"
#    ;;
    *) echo "can't recognition this case"
    ;;
esac

echo 7 > /proc/sys/kernel/printk
exit
