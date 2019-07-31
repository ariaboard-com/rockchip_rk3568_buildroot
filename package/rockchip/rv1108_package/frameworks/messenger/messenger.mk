MESSENGER_SITE = $(TOPDIR)/../frameworks/messenger
MESSENGER_SITE_METHOD = local
MESSENGER_INSTALL_STAGING = YES

# add dependencies
MESSENGER_DEPENDENCIES = libnanomsg cjson adk

$(eval $(cmake-package))
