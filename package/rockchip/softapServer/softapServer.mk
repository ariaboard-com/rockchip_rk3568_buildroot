# Rockchip's softap server demo
# Author : Jacky <jorge.ge@rock-chips.com>

ifeq ($(BR2_PACKAGE_SOFTAPSERVER), y)
SOFTAPSERVER_SITE = $(TOPDIR)/../external/softapServer
SOFTAPSERVER_SITE_METHOD = local
SOFTAPSERVER_INSTALL_STAGING = YES
SOFTAPSERVER_CONF_OPTS +=\
    -DLIBRARY_OUTPUT_PATH=$(TOPDIR)/board/rockchip/rk322x/fs-overlay/usr/lib \
    -DEXECUTABLE_OUTPUT_PATH=$(TOPDIR)/board/rockchip/rk322x/fs-overlay/usr/bin

$(eval $(cmake-package))
endif


