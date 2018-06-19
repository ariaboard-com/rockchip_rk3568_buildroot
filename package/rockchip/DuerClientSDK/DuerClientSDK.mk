# Rockchip's DuerOS c++ sdk
# Author : Nyx Zheng <zyh@rock-chips.com>
#          Hertz <wangh@rock-chips.com>

ifeq ($(BR2_PACKAGE_DUERCLIENTSDK),y)

DUERCLIENTSDK_SITE = $(TOPDIR)/../external/DuerClientSDK
DUERCLIENTSDK_SITE_METHOD = local
DUERCLIENTSDK_INSTALL_STAGING = YES
DUERCLIENTSDK_DEPENDENCIES = libnghttp2 zlib sqlite libcurl portaudio ffmpeg3 \
	rapidjson

DUERCLIENTSDK_BUILD_CONF = $(DUERCLIENTSDK_BUILDDIR)build/build.conf

# Duer DevKit has its special setting,
# keep same with $(DUERCLIENTSDK_BUILDDIR)build.sh.
define DUERCLIENTSDK_CONFIGURE_CMDS
	(mkdir -p $($(PKG)_BUILDDIR) && \
	cd $($(PKG)_BUILDDIR) && \
	rm -f CMakeCache.txt && \
	PATH=$(BR_PATH); \
	sed -i '/^COMPILER_PATH/d' $(DUERCLIENTSDK_BUILD_CONF); \
	COMPILER_PATH=$(HOST_DIR);\
	source $(DUERCLIENTSDK_BUILD_CONF); \
	$($(PKG)_CONF_ENV) $(BR2_CMAKE) $($(PKG)_SRCDIR) \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_COLOR_MAKEFILE=ON \
		-DCMAKE_RULE_MESSAGES=ON \
		-DCMAKE_INSTALL_MESSAGE=LAZY \
		-DCMAKE_INSTALL_RPATH=$(join "'\$$,ORIGIN/lib'") \
		-DCMAKE_BUILD_TYPE=$${CMAKE_BUILD_TYPE} \
		-DCMAKE_C_COMPILER=$${CMAKE_C_COMPILER} \
		-DCMAKE_CXX_COMPILER=$${CMAKE_CXX_COMPILER} \
		-DCMAKE_C_FLAGS="$${CMAKE_C_FLAGS}" \
		-DCMAKE_CXX_FLAGS="$${CMAKE_CXX_FLAGS}" \
		-DPlatform=$${Platform} \
		-DPORTAUDIO_LIB_PATH=${TARGET_DIR}/usr/lib/libportaudio.so \
		-DPORTAUDIO_INCLUDE_DIR=${STAGING_DIR}/usr/include \
		-DFFMPEG_LIB_PATH=${TARGET_DIR}/usr/lib \
		-DFFMPEG_INCLUDE_DIR=${STAGING_DIR}/usr/include \
		-DCURL_LIBRARY=${TARGET_DIR}/usr/lib/libcurl.so \
		-DCURL_INCLUDE_DIR=${STAGING_DIR}/usr/include \
		-DSQLITE_LDFLAGS=${TARGET_DIR}/usr/lib/libsqlite3.so \
		-DSQLITE_INCLUDE_DIRS=${STAGING_DIR}/usr/include \
		-DKITTAI_KEY_WORD_DETECTOR=$${KITTAI_KEY_WORD_DETECTOR} \
		-DBUILD_TTS_SDK=$${BUILD_TTS_SDK} \
		-DBUILD_CRAB_SDK=$${BUILD_CRAB_SDK} \
		-DPORTAUDIO=ON \
		-DGSTREAMER_MEDIA_PLAYER=ON \
		-DBUILD_DOC=OFF \
		-DBUILD_TEST=OFF \
		-DBUILD_ONE_LIB=ON \
		-DOUTPUT_FOR_THIRD=ON \
		-DDEBUG_FLAG=$${DEBUG_FLAG} \
		-DDUERLINK_V2=$${DUERLINK_V2} \
	)
endef

$(eval $(cmake-package))
endif


