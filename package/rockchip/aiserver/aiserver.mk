AISERVER_SITE = $(TOPDIR)/../app/aiserver
AISERVER_SITE_METHOD = local

AISERVER_DEPENDENCIES = rockit dbus dbus-cpp librkdb

AISERVER_CONF_OPTS += -DBR2_SDK_PATH=$(HOST_DIR)

ifeq ($(BR2_PACKAGE_RK_OEM), y)
AISERVER_INSTALL_TARGET_OPTS = DESTDIR=$(BR2_PACKAGE_RK_OEM_INSTALL_TARGET_DIR) install/fast
AISERVER_DEPENDENCIES += rk_oem
AISERVER_CONF_OPTS += -DAISERVER_CONF_PREFIX="\"/oem\""
endif

ifeq ($(BR2_PACKAGE_AISERVER_SANITIZER_DYNAMIC), y)
    AISERVER_CONF_OPTS += -DSANITIZER_DYNAMIC=ON
else
    ifeq ($(BR2_PACKAGE_AISERVER_SANITIZER_STATIC), y)
        AISERVER_CONF_OPTS += -DSANITIZER_STATIC=ON
    endif
endif

ifeq ($(BR2_PACKAGE_AISERVER_CONIFG), none)
    AISERVER_CONF_OPTS += -DMEDIASERVE_CONF=none
else
    AISERVER_CONF_OPTS += -DMEDIASERVE_CONF=${BR2_PACKAGE_AISERVER_CONIFG}
endif

ifeq ($(BR2_PACKAGE_RV1126_RV1109),y)
    AISERVER_CONF_OPTS += -DCOMPILE_PLATFORM=rv1109
endif

ifeq ($(BR2_PACKAGE_AISERVER_MINILOGGER), y)
    AISERVER_CONF_OPTS += -DENABLE_MINILOGGER=ON
    AISERVER_DEPENDENCIES += minilogger
else
    AISERVER_CONF_OPTS += -DENABLE_MINILOGGER=OFF
endif

ifeq ($(BR2_PACKAGE_AISERVER_SHM_SERVER), y)
    AISERVER_CONF_OPTS += -DENABLE_SHM_SERVER=ON
    AISERVER_DEPENDENCIES += shm-tools
endif

ifeq ($(BR2_PACKAGE_AISERVER_OSD_SERVER), y)
    AISERVER_CONF_OPTS += -DENABLE_OSD_SERVER=ON
    AISERVER_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_AISERVER_EXIV2_FEATURE), y)
    AISERVER_CONF_OPTS += -DENABLE_EXIV2_LIB=ON
    AISERVER_DEPENDENCIES += exiv2
endif

ifeq ($(BR2_PACKAGE_AISERVER_USE_ROCKFACE), y)
    AISERVER_DEPENDENCIES += rknpu rockface
    AISERVER_CONF_OPTS += -DUSE_ROCKFACE=ON
endif

ifeq ($(BR2_PACKAGE_AISERVER_USE_ROCKX), y)
    AISERVER_DEPENDENCIES += rknpu rockx
    AISERVER_CONF_OPTS +=  -DROCKX=ON \
        -DROCKX_HEADER_DIR=$(STAGING_DIR)/usr/include/rockx
endif

$(eval $(cmake-package))
