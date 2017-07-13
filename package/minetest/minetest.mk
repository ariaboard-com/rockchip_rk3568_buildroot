################################################################################
#
# minetest
#
################################################################################

MINETEST_VERSION = 0.4.16
MINETEST_SITE = $(call github,minetest,minetest,$(MINETEST_VERSION))
MINETEST_LICENSE = LGPL-2.1+ (code), CC-BY-SA-3.0 (textures and sounds)
MINETEST_LICENSE_FILES = README.txt

MINETEST_DEPENDENCIES = gmp irrlicht jsoncpp luajit sqlite zlib

MINETEST_CONF_OPTS = \
	-DDEFAULT_RUN_IN_PLACE=OFF \
	-DENABLE_SOUND=OFF \
	-DENABLE_GLES=OFF \
	-DENABLE_FREETYPE=OFF \
	-DENABLE_LUAJIT=ON \
	-DENABLE_CURSES=OFF \
	-DENABLE_POSTGRESQL=OFF \
	-DENABLE_LEVELDB=OFF \
	-DENABLE_REDIS=OFF \
	-DENABLE_SPATIAL=OFF \
	-DAPPLY_LOCALE_BLACKLIST=OFF \
	-DENABLE_SYSTEM_GMP=ON \
	-DENABLE_SYSTEM_JSONCPP=ON

ifeq ($(BR2_PACKAGE_MINETEST_CLIENT),y)
MINETEST_DEPENDENCIES += bzip2 jpeg libgl libpng xlib_libXxf86vm
MINETEST_CONF_OPTS += -DBUILD_CLIENT=ON
else
MINETEST_CONF_OPTS += -DBUILD_CLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_MINETEST_SERVER),y)
MINETEST_CONF_OPTS += -DBUILD_SERVER=ON
else
MINETEST_CONF_OPTS += -DBUILD_SERVER=OFF
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
MINETEST_DEPENDENCIES += libcurl
MINETEST_CONF_OPTS += -DENABLE_CURL=ON
else
MINETEST_CONF_OPTS += -DENABLE_CURL=OFF
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
MINETEST_DEPENDENCIES += $(TARGET_NLS_DEPENDENCIES)
MINETEST_CONF_OPTS += -DENABLE_GETTEXT=ON
else
MINETEST_CONF_OPTS += -DENABLE_GETTEXT=OFF
endif

$(eval $(cmake-package))