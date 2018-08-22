################################################################################
#
# Copy extra alsa configs to /usr/share/alsa/
#
################################################################################

ALSA_CONFIG_VERSION = 1.0
ALSA_CONFIG_SITE = $(TOPDIR)/../external/alsa-config
ALSA_CONFIG_SITE_METHOD = local

ALSA_CONFIG_LICENSE = Apache V2.0
ALSA_CONFIG_LICENSE_FILES = NOTICE
PROJECT_DIR="$(@D)"

define ALSA_CONFIG_INSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
