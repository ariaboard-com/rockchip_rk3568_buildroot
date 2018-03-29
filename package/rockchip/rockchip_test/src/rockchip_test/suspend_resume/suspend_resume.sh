#!/bin/sh

RESULT_DIR=/data/cfg/rockchip_test/
RESULT_LOG=${RESULT_DIR}/suspend_resume.log

mkdir -p ${RESULT_DIR}

# suspend & resume test
echo "**************************************"
echo "auto suspend:                        1"
echo "suspend (resume by key):             2"
echo "**************************************"

read  SUSPEND_CHOICE

suspend_resume_by_Key()
{
    echo "System will suspend, Please resume by key"
    echo mem >  /sys/power/state
}

auto_suspend_resume()
{
    while true
    do
        echo mem >  /sys/power/state
        sleep 5
    done
}

case ${SUSPEND_CHOICE} in
    1)
        auto_suspend_resume &
        ;;
    2)
        suspend_resume_by_Key
        ;;
esac
