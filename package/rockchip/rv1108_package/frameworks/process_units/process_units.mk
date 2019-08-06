PROCESS_UNITS_SITE = $(TOPDIR)/../frameworks/process_units
PROCESS_UNITS_SITE_METHOD = local
PROCESS_UNITS_INSTALL_STAGING = YES

# add dependencies
PROCESS_UNITS_DEPENDENCIES = rkcamera librkfb librkrga

PROCESS_UNITS_CONF_OPTS += \
    -DBOARD_VERSION=$(BR2_RV1108_BOARD_VERSION)

$(eval $(cmake-package))
