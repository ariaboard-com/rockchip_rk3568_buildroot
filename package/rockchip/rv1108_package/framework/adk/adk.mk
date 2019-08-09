ADK_SITE = $(TOPDIR)/../framework/adk
ADK_SITE_METHOD = local
ADK_INSTALL_STAGING = YES

# add dependencies
ADK_DEPENDENCIES = libion

$(eval $(cmake-package))
