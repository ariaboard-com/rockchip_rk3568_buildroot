DATABASE_SITE = $(TOPDIR)/../frameworks/database
DATABASE_SITE_METHOD = local
DATABASE_INSTALL_STAGING = YES

# add dependencies
DATABASE_DEPENDENCIES = sqlite

$(eval $(cmake-package))
