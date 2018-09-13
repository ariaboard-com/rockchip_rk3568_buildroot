################################################################################
#
# FBALPHA
#
################################################################################
LIBRETRO_FBALPHA_VERSION = 6f85b5d19085f91c8f3df5c53dd235c037782fee
LIBRETRO_FBALPHA_SITE = $(call github,libretro,fbalpha,$(LIBRETRO_FBALPHA_VERSION))

define LIBRETRO_FBALPHA_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
	       LDFLAGS="$(TARGET_LDFLAGS) -lstdc++ -lm" \
	       $(MAKE) -C $(@D)/ -f makefile.libretro \
	       CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_CC)" \
	       RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" \
	       platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_FBALPHA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fbalpha_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/fbalpha_libretro.so
endef

$(eval $(generic-package))
