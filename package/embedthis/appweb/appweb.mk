################################################################################
#
# appweb
#
################################################################################

APPWEB_VERSION = 7.2.0
APPWEB_SOURCE = appweb-$(APPWEB_VERSION).tar.gz
APPWEB_SITE = $(call github, embedthis, appweb, $(APPWEB_VERSION))
APPWEB_LICENSE = GPL
APPWEB_LICENSE_FILES = LICENSE.md
APPWEB_INSTALL_STAGING = YES

APPWEB_DEPENDENCIES += host-makeme

APPWEB_CONF_OPTS += --platform linux-arm-static --static --nolocal --with cgi --with ssl --with mbedtls --without esp --without mdb

define APPWEB_CONFIGURE_CMDS
	OS="linux" \
	ARCH="$(TARGET_ARCH)" \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	PROFILE="static" \
	$(TARGET_MAKE_ENV) me \
		--chdir $(@D) \
		--configure $(@D)\
		--prefix $(STAGING_DIR) \
		$(APPWEB_CONF_OPTS)
endef

define APPWEB_BUILD_CMDS
	OS="linux" \
	ARCH="$(TARGET_ARCH)" \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	PROFILE="static" \
	$(TARGET_MAKE_ENV) me \
		--chdir $(@D)
endef

#define APPWEB_INSTALL_STAGING_CMDS
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libpcre.so $(STAGING_DIR)/usr/lib/libpcre.so
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libmpr.so $(STAGING_DIR)/usr/lib/libmpr.so
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libhttp.so $(STAGING_DIR)/usr/lib/libhttp.so
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libappweb.so $(STAGING_DIR)/usr/lib/libappweb.so
#endef

define APPWEB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/var/www/appweb
	mkdir -p $(TARGET_DIR)/var/log/appweb
	mkdir -p $(TARGET_DIR)/etc/appweb/certs
	$(INSTALL) -D -m 0644 $(@D)/src/server/appweb.conf $(TARGET_DIR)/etc/appweb/appweb.conf
	$(INSTALL) -D -m 0644 $(@D)/src/server/install.conf $(TARGET_DIR)/etc/appweb/install.conf
	$(INSTALL) -D -m 0644 $(@D)/src/server/mime.types $(TARGET_DIR)/etc/appweb/mime.types
	$(INSTALL) -D -m 0755 $(@D)/build/linux-arm-static/bin/appweb $(TARGET_DIR)/usr/bin/appweb
	$(INSTALL) -D -m 0755 $(@D)/build/linux-arm-static/bin/appman $(TARGET_DIR)/usr/bin/appman
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libpcre.so $(TARGET_DIR)/usr/lib/libpcre.so
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libmpr.so $(TARGET_DIR)/usr/lib/libmpr.so
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libhttp.so $(TARGET_DIR)/usr/lib/libhttp.so
#	$(INSTALL) -D -m 0644 $(@D)/build/linux-arm-default/bin/libappweb.so $(TARGET_DIR)/usr/lib/libappweb.so
endef

$(eval $(generic-package))
