#!/bin/sh

T_INPUT=""
O_INPUT=""
I_INPUT=""
E_INPUT=""
P_INPUT=""


#read file
read_file()
{
    while read line ; do
        key=`echo $line | awk -F "=" '{print $1}'`
        value=`echo $line | awk -F "=" '{print $2}'`
        case ${key} in
            t)
                T_INPUT=${value}
                ;;
            o)
                O_INPUT=${value}
                ;;
            i)
                I_INPUT=${value}
                ;;
            e)
                E_INPUT=${value}
                ;;
            p)
                P_INPUT=${value}
                ;;
        esac
    done < /test_plan/gpio/gpio.conf
}

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            GPIO TEST                          ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

gpio_irq_test()
{
    /test_plan/gpio/gpio -t irq -e  ${E_INPUT}  -o ${O_INPUT} -i ${I_INPUT}
}

gpio_pio_test()
{
    /test_plan/gpio/gpio -t pio -o ${O_INPUT} -i ${I_INPUT}

}


gpio_pull_test()
{
    /test_plan/gpio/gpio -t pull -p ${P_INPUT} -i ${I_INPUT}
}

gpio_test()
{
    info_view
    echo "*****************************************************"
    /test_plan/gpio/gpio -h 
    echo "*****************************************************"

	read_file
    case ${T_INPUT} in
        "pio")
            gpio_pio_test
            ;;
        "irq")
            gpio_irq_test
            ;;
        "pull")
            gpio_pull_test
            ;;
        *)
            echo "not found gpio test case"
            ;;
    esac

    echo "*****************"
}

gpio_test
