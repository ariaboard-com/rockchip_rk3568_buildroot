################################################################################
#
# rockit project
#
################################################################################

ROCKIT_SITE = $(TOPDIR)/../external/rockit

ROCKIT_SITE_METHOD = local

ROCKIT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_FFMPEG),y)
RKMEDIA_DEPENDENCIES += ffmpeg
endif


$(eval $(cmake-package))
