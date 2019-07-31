ADK_SITE = $(TOPDIR)/../frameworks/adk
ADK_SITE_METHOD = local
ADK_INSTALL_STAGING = YES

# add dependencies
ADK_DEPENDENCIES = libion

$(eval $(cmake-package))
