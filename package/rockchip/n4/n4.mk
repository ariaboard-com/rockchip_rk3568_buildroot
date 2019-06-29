N4_SITE = $(TOPDIR)/../app/n4
N4_SITE_METHOD = local
N4_INSTALL_STAGING = NO

N4_DEPENDENCIES = host-ninja libv4l rkmedia

#N4_CONF_OPTS = -DWARNINGS_AS_ERRORS=ON

N4_CONF_OPTS += -G Ninja

N4_NINJA_OPTS += $(if $(VERBOSE),-v) -j$(PARALLEL_JOBS)

define N4_BUILD_CMDS
$(TARGET_MAKE_ENV) $($(PKG)_MAKE_ENV) ninja $($(PKG)_NINJA_OPTS) -C $($(PKG)_BUILDDIR)
endef

define N4_INSTALL_TARGET_CMDS
$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) ninja $($(PKG)_NINJA_OPTS) -C $($(PKG)_BUILDDIR) install
endef

$(eval $(cmake-package))
