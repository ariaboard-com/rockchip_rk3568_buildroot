# Rockchip's alexa c++ sdk
# Author : Nyx Zheng <zyh@rock-chips.com>

ifeq ($(BR2_PACKAGE_DUERCLIENTSDK),y)
CMAKE_BUILD_TYPE="DEBUG"
DEBUG_SWITCH="-g"
CMAKE_FPIC_FLAG="-fPIC"
CMAKE_C_FLAGS="${DEBUG_SWITCH} ${CMAKE_FPIC_FLAG}"
CMAKE_CXX_FLAGS="-std=c++11 ${DEBUG_SWITCH} ${CMAKE_FPIC_FLAG}"
Platform="Rockchip"
KITTAI_KEY_WORD_DETECTOR="ON"
DUERCLIENTSDK_SITE = $(TOPDIR)/../external/DuerClientSDK
DUERCLIENTSDK_SITE_METHOD = local
DUERCLIENTSDK_INSTALL_STAGING = YES
DUERCLIENTSDK_DEPENDENCIES = libnghttp2 zlib sqlite libcurl portaudio ffmpeg3 
DUERCLIENTSDK_CONF_OPTS +=\
						  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
						  -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} \
						  -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} \
						  -DCMAKE_C_COMPILE_OBJECT=${CMAKE_C_COMPILE_OBJECT} \
						  \
						  -DPlatform=${Platform} \
						  \
						  -DPORTAUDIO_LIB_PATH=${TARGET_DIR}/usr/lib/libportaudio.so \
						  -DPORTAUDIO_INCLUDE_DIR=${TARGET_DIR}/include \
						  -DKITTAI_KEY_WORD_DETECTOR=${KITTAI_KEY_WORD_DETECTOR} \
						  -DFFMPEG_LIB_PATH=${TARGET_DIR}/usr/lib \
						  -DFFMPEG_INCLUDE_DIR=${TARGET_DIR}/usr/include \
						  -DCURL_LIBRARY=${TARGET_DIR}/usr/lib/libcurl.so \
						  -DCURL_INCLUDE_DIR=${TARGET_DIR}/usr/include \
						  -DSQLITE_LDFLAGS=${TARGET_DIR}/usr/lib/libsqlite3.so \
						  -DSQLITE_INCLUDE_DIRS=${TARGET_DIR}/usr/include \
						  -DDUER_LIBRARY_DIR=${BUILD_DIR}/DuerClientSDK/sdk/lib \
						  -DDUER_INCLUDE_DIR=${BUILD_DIR}/DuerClientSDK/sdk/include \
						  -DPORTAUDIO=ON \
						  -DGSTREAMER_MEDIA_PLAYER=ON \
						  -DBUILD_DOC=OFF \
						  -DBUILD_TEST=OFF \
						  -DBUILD_ONE_LIB=ON \
						  -DOUTPUT_FOR_THIRD=ON

$(eval $(cmake-package))
endif


