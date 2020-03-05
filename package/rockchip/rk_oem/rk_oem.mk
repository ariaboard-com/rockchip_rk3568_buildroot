################################################################################
#
# rk_oem
#
################################################################################

ifeq ($(BR2_PACKAGE_RK_OEM), y)
RK_OEM_SITE_METHOD = local

ifeq ($(BR2_PACKAGE_RK_OEM_RESOURCE_DIR),"")
RK_OEM_SITE = $(TOPDIR)/package/rockchip/rk_oem/src

define RK_OEM_INSTALL_INIT_SYSV
$(INSTALL) -D -m 0755 $(@D)/S98_lunch_init \
		$(TARGET_DIR)/etc/init.d/S98_lunch_init
endef

else
RK_OEM_SITE = $(BR2_PACKAGE_RK_OEM_RESOURCE_DIR)
endif

RK_OEM_REDIRECT_DBUS4OEM_CONF = package/rockchip/rk_oem/redirect_dbus4oem.conf
RK_OEM_INSTALL_TARGET_DIR = $(BR2_PACKAGE_RK_OEM_INSTALL_TARGET_DIR)

define RK_OEM_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/dbus-1/system.d
	$(INSTALL) -D -m 0644 $(RK_OEM_REDIRECT_DBUS4OEM_CONF) \
		$(TARGET_DIR)/usr/share/dbus-1/system.d
	mkdir -p $(RK_OEM_INSTALL_TARGET_DIR)
	cp -rfp $(@D)/* $(RK_OEM_INSTALL_TARGET_DIR)
	rm -fv $(RK_OEM_INSTALL_TARGET_DIR)/rk_oem.tar
endef

endif

$(eval $(generic-package))
