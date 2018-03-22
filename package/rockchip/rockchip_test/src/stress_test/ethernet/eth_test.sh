#/bin/sh

RESULT_DIR=/test_log/ethernet
RESULT_LOG=${RESULT_DIR}/eth_test.log

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            ETHERNET TEST                      ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

log_init()
{
    info_view
    mkdir -p ${RESULT_DIR}
}

up_eth0()
{
    ifconfig eth0 up
    count=0    
    while  [ $? -ne 0 ]
    do
        echo "etho up error"
        sleep 2

        if [ ${count} -gt 10 ]
        then
            echo "ifconfig eth0 up : failure."
            exit 1
        fi
        let count+=1
        ifconfig eth0 up
    done
 
    count=0
    udhcpc 
    while  [ $? -ne 0 ]
    do
        echo "udhcpc error"
        sleep 2

        if [ ${count} -gt 10 ]
        then
            echo "udhcpc config ip : failure."
            exit 1
        fi
        let count+=1
        udhcpc
    done
}
eth_restart()
{
    up_eth0

    echo "eth0 ready..."
    sleep 2
    ping -c 5 www.baidu.com
    if [ $? -eq 0 ]
    then
        echo "ping www.baidu.success." >>  ${RESULT_LOG} 
        echo "ethernet=success"  >> ${RESULT_LOG}
    else
        echo "ping www.baidu.com failure." >> ${RESULT_LOG}
        echo "ethernet=failure"  >> ${RESULT_LOG}
    fi 
}

eth_test()
{
    log_init
    
    eth_restart

    cat ${RESULT_LOG}
}


/etc/init.d/S42wifi stop
eth_test
