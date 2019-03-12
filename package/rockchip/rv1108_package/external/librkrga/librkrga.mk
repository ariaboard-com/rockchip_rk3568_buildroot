LIBRKRGA_SITE = $(TOPDIR)/../external/librkrga
LIBRKRGA_SITE_METHOD = local

LIBRKRGA_DEPENDENCIES = libion


$(eval $(cmake-package))
