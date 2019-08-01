LIBNANOMSG_SITE = $(TOPDIR)/../external/nanomsg
LIBNANOMSG_SITE_METHOD = local
LIBNANOMSG_INSTALL_STAGING = YES

$(eval $(cmake-package))
