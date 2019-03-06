#!/bin/bash

MODEL_PATH=vgg_16_maxpool

#default count 4320000, about 24 hours
total=${1:-4320000}
test_cnt=50
pass_cnt=0

if [ $test_cnt -ge $total ]; then
    test_cnt=$total
fi

echo "==========total: $total, test_cnt: $test_cnt"
export VSI_NN_LOG_LEVEL=0
export VIV_VX_ENABLE_SWTILING_PHASE1=1
export VIV_VX_ENABLE_SWTILING_PHASE2=1
export NN_EXT_DDR_READ_BW_LIMIT=5
export NN_EXT_DDR_WRITE_BW_LIMIT=5
export NN_EXT_DDR_TOTAL_BW_LIMIT=5

echo "###"$MODEL_PATH"###"
RKNN_MODEL=`find $MODEL_PATH -name "*.rknn"`
IMAGE_FILE=`find $MODEL_PATH -name "*.jpg"`

while true; do
  if [ $pass_cnt -ge $total ]; then
    echo "======npu stress test PASS===="
    exit
  fi
  PERF=$(./rknn_inference $RKNN_MODEL $IMAGE_FILE $test_cnt 2>&1)
  echo $PERF
  dmesg |grep "GPU[0] hang"
  if [ $? != 0 ]; then
    let "pass_cnt=$pass_cnt + $test_cnt"
  else
    echo "====npu stress test FAIL===="
    exit
  fi
done
