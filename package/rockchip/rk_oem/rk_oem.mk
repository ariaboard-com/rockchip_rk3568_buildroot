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

define RK_OEM_TARGET_POST_CLEAN_HOOK_CMDS
	rm -rf $(RK_OEM_INSTALL_TARGET_DIR)/usr/include $(RK_OEM_INSTALL_TARGET_DIR)/usr/share/aclocal \
		$(RK_OEM_INSTALL_TARGET_DIR)/usr/lib/pkgconfig $(RK_OEM_INSTALL_TARGET_DIR)/usr/share/pkgconfig \
		$(RK_OEM_INSTALL_TARGET_DIR)/usr/lib/cmake $(RK_OEM_INSTALL_TARGET_DIR)/usr/share/cmake
	find $(RK_OEM_INSTALL_TARGET_DIR)/usr/{lib,share}/ -name '*.cmake' -print0 | xargs -0 rm -f
	find $(RK_OEM_INSTALL_TARGET_DIR)/lib/ $(RK_OEM_INSTALL_TARGET_DIR)/usr/lib/ $(RK_OEM_INSTALL_TARGET_DIR)/usr/libexec/ \
		\( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
endef

define RK_OEM_TARGET_FINALIZE_STRIP_HOOK_CMDS
	find $(RK_OEM_INSTALL_TARGET_DIR) -type f \( -perm /111 -o -name '*.so*' \) \
		-not \( -name 'libpthread*.so*' -o -name 'ld-*.so*' -o -name '*.ko' \) -print0 | \
		xargs -0 $(STRIPCMD) 2>/dev/null || true
endef

ifneq ($(BR2_ENABLE_DEBUG),y)
ifneq ($(BR2_PACKAGE_RK_OEM_ENABLE_DEBUG),y)
RK_OEM_TARGET_FINALIZE_HOOKS += RK_OEM_TARGET_FINALIZE_STRIP_HOOK_CMDS
endif
endif
RK_OEM_POST_INSTALL_TARGET_HOOKS += RK_OEM_TARGET_POST_CLEAN_HOOK_CMDS

endif

$(eval $(generic-package))
