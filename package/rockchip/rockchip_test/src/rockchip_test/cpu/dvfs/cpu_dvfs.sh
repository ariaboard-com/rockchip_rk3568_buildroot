#!/bin/sh

#run cpu a53
/test_plan/cpu/dvfs/cpuburn-a53 & 

#change cpu freq
sh /test_plan/cpu/dvfs/cpu_freq_v1_0.sh &
