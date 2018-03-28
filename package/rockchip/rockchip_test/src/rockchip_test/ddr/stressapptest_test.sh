#!/bin/sh

DDR_DIR=/rockchip_test/ddr
RESULT_DIR=/data/cfg/rockchip_test/
RESULT_LOG=${RESULT_DIR}/stressapptest.log

#run stressapptest_test
echo "**********************DDR STRESSAPPTEST TEST****************************"
echo "***run: stressapptest -s 43200 -i 4 -C 4 -W --stop_on_errors -M 128*****"
echo "**********************DDR STRESSAPPTEST TEST****************************"
stressapptest -s 43200 -i 4 -C 4 -W --stop_on_errors -M 128 & 
