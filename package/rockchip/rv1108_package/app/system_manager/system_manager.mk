SYSTEM_MANAGER_SITE = $(TOPDIR)/../app/system_manager
SYSTEM_MANAGER_SITE_METHOD = local
SYSTEM_MANAGER_INSTALL_STAGING = YES

# add dependencies
SYSTEM_MANAGER_DEPENDENCIES = adk messenger

define SYSTEM_MANAGER_CONF_DEF
    $(INSTALL) -m 0644 -D package/rockchip/rv1108_package/apps/system_manager/system_manager.conf \
                    $(TARGET_DIR)/etc/system_manager.conf
endef

$(eval $(cmake-package))
