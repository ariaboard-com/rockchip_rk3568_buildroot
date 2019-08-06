PCBA_TEST_SITE = $(TOPDIR)/../app/pcba_test
PCBA_TEST_SITE_METHOD = local
PCBA_TEST_INSTALL_STAGING = YES

# add dependencies
PCBA_TEST_DEPENDENCIES = librkrga librkfb adk


ifeq ($(BR2_PACKAGE_PCBA_TEST_PCTOOL_APP),y)
    PCBA_TEST_CONF_OPTS += -DUSE_PCBA_PCTOOL_APP=1
endif

ifeq ($(BR2_PACKAGE_PCBA_TEST_SELTTEST_APP),y)
    PCBA_TEST_CONF_OPTS += -DUSE_PCBA_SELFTEST_APP=1
    PCBA_TEST_DEPENDENCIES += rv1108_minigui libjpeg libpng12 tslib
endif

$(eval $(cmake-package))
