ADK_SITE = $(TOPDIR)/../framework/adk
ADK_SITE_METHOD = local
ADK_INSTALL_STAGING = YES

# add dependencies
ADK_DEPENDENCIES = libion

ifeq ($(BR2_PACKAGE_ADK_MEDIA),y)
    ADK_DEPENDENCIES += alsa-lib rkmedia
    ADK_CONF_OPTS += -DENABLE_ADK_MEDIA=1
endif

$(eval $(cmake-package))
