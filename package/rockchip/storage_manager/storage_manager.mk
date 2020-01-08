STORAGE_MANAGER_SITE = $(TOPDIR)/../app/storage_manager
STORAGE_MANAGER_SITE_METHOD = local

STORAGE_MANAGER_DEPENDENCIES = libgdbus librkdb

$(eval $(cmake-package))
