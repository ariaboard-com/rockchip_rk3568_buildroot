#!/bin/sh

RESULT_DIR=/test_log/cpu
RESULT_LOG=${RESULT_DIR}/suspend_resume.log

mkdir -p ${RESULT_DIR}

#
echo "**************************************"
echo "auto suspend:                        1"
echo "suspend (resume by key or ir):       2"
echo "**************************************"

read  SUSPEND_CHOICE

suspend_resume_by_KeyIr()
{
    echo mem >  /sys/power/state
    if [  $? -ne 0 ]
    then
        echo "suspend_resume=failure" >> ${RESULT_LOG}
    else
        echo "suspend_resume=failure" >> ${RESULT_LOG}
    fi
}

auto_suspend_resume()
{
	while true
	do
		rtcwake -s 5 -m mem
		sleep 10
	done
}

case ${SUSPEND_CHOICE} in
    1)
        auto_suspend_resume &
        ;;
    2)
        suspend_resume_by_KeyIr
        ;;
esac

