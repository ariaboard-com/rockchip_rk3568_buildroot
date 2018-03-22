#!/bin/sh

#Run as daemon
/test_plan/player/cpuburn-a53 &

/test_plan/player/cpu_freq_v1_0.sh &

mount /dev/sda1 /mnt

info(){
    if [ $? -neq 0 ]; then
        echo "play $3 wrong"
    else
        echo "play $3 OK"
    fi
}

while true
do
    aplay -D dmixer_auto /mnt/Hello.wav
    info
    echo "============aplay for wav============"

    aplay -D dmixer_auto /mnt/8ch_full.wav
    info
    echo "============aplay for wav============"

    alsaplayer -d dmixer_auto /mnt/Hello.wav
    info
    echo "============alsaplayer for wav============"

    alsaplayer -d dmixer_auto /mnt/Hello.flac
    info
    echo "============alsaplayer for flac============"

    alsaplayer -d dmixer_auto /mnt/Hello.ogg
    info
    echo "============alsaplayer for ogg============"

    alsaplayer -d dmixer_auto /mnt/Hello.mp3
    info
    echo "============alsaplayer for mp3============"

    cvlc --play-and-exit --alsa-audio-device dmixer_auto /mnt/Hello.wav
    info
    echo "============VLC for wav============"

    cvlc --play-and-exit --alsa-audio-device dmixer_auto /mnt/Hello.mp3
    info
    echo "============VLC for mp3============"

    cvlc --play-and-exit --alsa-audio-device dmixer_auto /mnt/Hello.ogg
    info
    echo "============VLC for ogg============"

    cvlc --play-and-exit --alsa-audio-device dmixer_auto /mnt/Hello.flac
    info
    echo "============VLC for flac============"

done
