#!/bin/sh

echo "*****************************************"
echo "***                                   ***"
echo "***         IR TEST                   ***"
echo "***                                   ***"
echo "*****************************************"


echo "*****************************************"
echo " select ir test."
echo " send data :          1"
echo " recevie data:        2"
echo "*****************************************"

read -t 30 IR_CHOICE

ir_send_data()
{
    /test_plan/ir/irsend -lc 0xe21dfb04 -t 800000
    if [ $? -ne 0 ]
    then
        echo "ir test error."
    fi
}

ir_receive_data()
{
    echo "please send ir data to board."
    cat /dev/input/event0
}

error_handle()
{
    echo "not found your choice."
}

case ${IR_CHOICE} in
    1)
        ir_send_data
        ;;
    2)
        ir_receive_data
        ;;
    *)
        error_handle
        ;;
esac
