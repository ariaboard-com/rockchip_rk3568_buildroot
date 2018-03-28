#!/bin/sh

DDR_DIR=/rockchip_test/ddr

RESULT_DIR=/data/cfg/rockchip_test/
RESULT_LOG=${RESULT_DIR}/memtester.log

#run memtester test
echo "**********************DDR MEMTESTER TEST****************************"
echo "**********************run: memtester 128M***************************"
echo "**********************DDR MEMTESTER TEST****************************"
memtester 128M & 
