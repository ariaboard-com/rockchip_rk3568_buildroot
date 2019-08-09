RKRGA_SITE = $(TOPDIR)/../framework/rkrga
RKRGA_SITE_METHOD = local
RKRGA_INSTALL_STAGING = YES

RKRGA_DEPENDENCIES = libion


$(eval $(cmake-package))
