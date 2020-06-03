################################################################################
#
# QFacialGate
#
################################################################################

QFACIALGATE_VERSION = 1.0
QFACIALGATE_SITE = $(TOPDIR)/../app/QFacialGate
QFACIALGATE_SITE_METHOD = local

QFACIALGATE_DEPENDENCIES = rkfacial qt5base

define QFACIALGATE_CONFIGURE_CMDS
	cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake
endef

define QFACIALGATE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QFACIALGATE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/QFacialGate	$(TARGET_DIR)/usr/bin/QFacialGate
	$(INSTALL) -D -m 0755 $(@D)/S06_QFacialGate $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
