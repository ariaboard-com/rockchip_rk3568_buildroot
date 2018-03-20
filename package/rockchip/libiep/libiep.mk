# Rockchip's libiep
# Author : yuyz <yuyz@rock-chips.com>

LIBIEP_SITE = $(call qstrip, ssh://git@10.10.10.78:2222/argus/externals/iep.git)
LIBIEP_SITE_METHOD = git
LIBIEP_VERSION = bf54327
LIBIEP_INSTALL_STAGING = YES
LIBIEP_SOURCE = libiep-${LIBIEP_VERSION}.tar.gz
LIBIEP_FROM_GIT = y

$(eval $(cmake-package))
