NETSERVER_SITE = $(TOPDIR)/../app/netserver
NETSERVER_SITE_METHOD = local

NETSERVER_DEPENDENCIES = libgdbus librkdb

$(eval $(cmake-package))
