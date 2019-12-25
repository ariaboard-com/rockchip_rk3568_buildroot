ADK_SITE = $(TOPDIR)/../framework/adk
ADK_SITE_METHOD = local
ADK_INSTALL_STAGING = YES

# add dependencies
ADK_DEPENDENCIES = libion

ifeq ($(BR2_PACKAGE_ADK_MEDIA_OGG_PLAYBACK),y)
    ADK_DEPENDENCIES += alsa-lib rkmedia
    ADK_CONF_OPTS += -DENABLE_OGG_PLAYBACK=1
endif

ifeq ($(BR2_PACKAGE_ADK_MEDIA_WAV_PLAYBACK),y)
    ADK_DEPENDENCIES += alsa-lib
    ADK_CONF_OPTS += -DENABLE_WAV_PLAYBACK=1
endif

ifeq ($(BR2_PACKAGE_ADK_MEDIA_VIDEO_RECORD),y)
    ADK_DEPENDENCIES += mpp rkmedia ffmpeg
    ADK_CONF_OPTS += -DENABLE_VIDEO_RECORD=1
endif

$(eval $(cmake-package))
