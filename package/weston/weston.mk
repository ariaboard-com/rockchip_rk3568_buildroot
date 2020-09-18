################################################################################
#
# weston
#
################################################################################

ifeq ($(BR2_PACKAGE_WESTON_VERSION_3),y)
WESTON_VERSION = 3.0.0
else ifeq ($(BR2_PACKAGE_WESTON_VERSION_8),y)
WESTON_VERSION = 8.0.0
endif

WESTON_SITE = http://wayland.freedesktop.org/releases
WESTON_SOURCE = weston-$(WESTON_VERSION).tar.xz
WESTON_LICENSE = MIT
WESTON_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LINUX_RGA),y)
WESTON_DEPENDENCIES += linux-rga
endif

define WESTON_INSTALL_TARGET_ENV
        $(INSTALL) -D -m 0644 $(WESTON_PKGDIR)/weston.sh \
                $(TARGET_DIR)/etc/profile.d/weston.sh
endef

WESTON_POST_INSTALL_TARGET_HOOKS += WESTON_INSTALL_TARGET_ENV

ifneq ($(WESTON_VERSION),)
include $(pkgdir)/weston-$(WESTON_VERSION).inc
endif
