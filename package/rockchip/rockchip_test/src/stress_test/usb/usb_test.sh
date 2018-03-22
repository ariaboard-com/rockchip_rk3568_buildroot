#!/bin/sh


info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            USB TEST                           ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

usb_insert_test()
{
    echo  0xffe09094 > /sys/kernel/debug/aml_reg/paddr
    USB_VALUE=$(cat /sys/kernel/debug/aml_reg/paddr | awk -F = '{print $2}')
    
    if [ "${USB_VALUE}" == " 0xFF30" ]
    then
        echo "usb is insert"
    elif [ "${USB_VALUE}" == " 0xFF73" ]
    then
        echo "usb isn't insert"
    fi
}

usb_read_test()
{
   umount /mnt
   /test_plan/usb/amldevread /dev/sda1
}

usb_write_test()
{
    umount /mnt
    /test_plan/usb/amldevwrite /dev/sda1
}

usb_test()
{
    info_view
    echo "*****************************************************"
    echo "usb insert or not test:   1"
    echo "usb read test:            2"
    echo "usb write test:           3"
    echo "*****************************************************"

    read -t 30 USB_TEST_CASE

    case ${USB_TEST_CASE}  in
        1)
            usb_insert_test
            ;;
        2)
            usb_read_test
            ;;
        3)
            usb_write_test
            ;;
        *)
            echo "not fount usb test case."
            ;;
    esac
}

usb_test
