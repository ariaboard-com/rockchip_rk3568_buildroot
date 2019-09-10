################################################################################
#
# makeme
#
################################################################################

MAKEME_VERSION = 1.0.2
MAKEME_SOURCE = makeme-$(MAKEME_VERSION).tar.gz
MAKEME_SITE = $(call github, embedthis, makeme, $(MAKEME_VERSION))
MAKEME_LICENSE = GPL
MAKEME_LICENSE_FILES = LICENSE.md

define HOST_MAKEME_BUILD_CMDS
	$(HOST_MAKE_ENV) make -C $(@D) \
		boot
endef

define HOST_MAKEME_INSTALL_CMDS
	$(HOST_MAKE_ENV) make -C $(@D) \
		ME_ROOT_PREFIX=$(HOST_DIR) \
		ME_BIN_PREFIX=$(HOST_DIR)/bin \
		ME_SBIN_PREFIX=$(HOST_DIR)/sbin \
		ME_LIB_PREFIX=$(HOST_DIR)/lib \
		install
endef

$(eval $(host-generic-package))
