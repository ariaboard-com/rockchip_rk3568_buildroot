#!/bin/sh

if type pm-suspend &>/dev/null; then
        LOCK=/var/run/pm-utils/locks/pm-suspend.lock
        SUSPEND_CMD="pm-suspend"
else
        LOCK=/tmp/.power_key
        PRE_SUSPEND="touch $LOCK"
        SUSPEND_CMD="echo -n mem > /sys/power/state"
        POST_SUSPEND="{ sleep 2 && rm $LOCK; }&"
fi

logger "Received power key..."

if [ ! -f $LOCK ]; then
        logger "Prepare to suspend by power key..."
        su root -c "$PRE_SUSPEND"
        su root -c "$SUSPEND_CMD"
        su root -c "$POST_SUSPEND"
fi
