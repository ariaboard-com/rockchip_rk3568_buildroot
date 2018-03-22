#!/bin/sh

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            CPU TEST                           ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

cpu_dvfs_test()
{
    sh /test_plan/cpu/dvfs/cpu_dvfs.sh
}

cpu_auto_reboot_test()
{
    sh /test_plan/cpu/autoreboot/autoreboot_control.sh
}

cpu_hotplug_test()
{
    sh /test_plan/cpu/cpu_hotplug/cpu_hotplug.sh
}

cpu_suspend_resume_test()
{
    sh /test_plan/cpu/suspend_resume/suspend_resume.sh
}

cpu_thermal_test()
{
    sh /test_plan/cpu/thermal/thermal.sh   
}

cpu_test()
{

    echo "*****************************************************"
    echo "dvfs :                                            1"
    echo "auto reboot:                                      2"
    echo "cpu hotplug:                                      3"
    echo "suspend resume:                                   4"
    echo "thermal:                                          5"
    echo "*****************************************************"
    read -t 30 CPU_TEST_CASE
    echo "cpu test case ${CPU_TEST_CASE}"

    if [ ${CPU_TEST_CASE} -eq 1 ]
    then
        cpu_dvfs_test
    elif [ ${CPU_TEST_CASE} -eq 2  ]
    then
        cpu_auto_reboot_test
    elif [ ${CPU_TEST_CASE} -eq 3 ] 
    then
        cpu_hotplug_test
    elif [ ${CPU_TEST_CASE} -eq 4  ]
    then
        cpu_suspend_resume_test
    elif [ ${CPU_TEST_CASE} -eq 5  ]
    then
        cpu_thermal_rest
    fi
}
info_view
cpu_test
