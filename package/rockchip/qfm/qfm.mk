################################################################################
#
# qfm
#
################################################################################

QLAUNCHER_VERSION = 1.0
QLAUNCHER_SITE = $(TOPDIR)/../app/qfm
QLAUNCHER_SITE_METHOD = local

QLAUNCHER_LICENSE = Apache V2.0
QLAUNCHER_LICENSE_FILES = NOTICE

define QLAUNCHER_CONFIGURE_CMDS
	cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake
endef

define QLAUNCHER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QLAUNCHER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/qfm	$(TARGET_DIR)/usr/bin/qfm
endef

$(eval $(generic-package))
