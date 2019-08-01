SYSTEM_MANAGER_SITE = $(TOPDIR)/../app/system_manager
SYSTEM_MANAGER_SITE_METHOD = local
SYSTEM_MANAGER_INSTALL_STAGING = YES

# add dependencies
SYSTEM_MANAGER_DEPENDENCIES = adk messenger

$(eval $(cmake-package))
