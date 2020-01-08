DBSERVER_SITE = $(TOPDIR)/../app/dbserver
DBSERVER_SITE_METHOD = local

DBSERVER_DEPENDENCIES = libgdbus librkdb

$(eval $(cmake-package))
