# Rockchip's libion porting from Android
# Author : Cody Xie <cody.xie@rock-chips.com>

LIBION_SITE = $(call qstrip, ssh://git@10.10.10.78:2222/argus/externals/libion.git)
LIBION_SITE_METHOD = git
LIBION_VERSION = e74d6aa
LIBION_INSTALL_STAGING = YES
LIBION_SOURCE = libion-${LIBION_VERSION}.tar.gz
LIBION_FROM_GIT = y

$(eval $(cmake-package))
