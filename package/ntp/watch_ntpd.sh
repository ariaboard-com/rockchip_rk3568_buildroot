#!/bin/sh

NTPD_NAME=ntpd
let WATCH_SECONDS=24*60*60  # Check ntpd in one day in background

while [ true ]
do
	COUNT=`ps -ef | grep -ws $NTPD_NAME | grep -v "grep" | wc -l`
	if [ $COUNT == 0 ]
	then
		echo "run ntpd once and watch it every $WATCH_SECONDS seconds"

		# If network works, ntpd will find a suitable ntp server, adjust time, and quit.
		ntpd -gq &
	else
		echo "$NTPD_NAME has been run and check it in $WATCH_SECONDS seconds"
	fi

        sleep $WATCH_SECONDS
done
