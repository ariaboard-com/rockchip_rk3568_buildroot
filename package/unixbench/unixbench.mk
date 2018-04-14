################################################################################
#
# UnixBench
#
################################################################################

UNIXBENCH_VERSION = master
UNIXBENCH_SITE = $(TOPDIR)/../external/byte-unixbench/UnixBench
UNIXBENCH_SITE_METHOD = local

UNIXBENCH_LICENSE = GPL-2.0+
UNIXBENCH_LICENSE_FILES = ../LICENSE.txt
UNIXBENCH_DEPENDENCIES = perl

UNIXBENCH_MAKE_OPTS = \
	UB_GCC_OPTIONS="-O3 -ffast-math" \
	CC="$(TARGET_CC)"

define UNIXBENCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(UNIXBENCH_MAKE_OPTS)
endef

UNIXBENCH_TARGET_DIR = \
	$(TARGET_DIR)/opt/unixbench

define UNIXBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/Run -t $(UNIXBENCH_TARGET_DIR)
	$(INSTALL) -D -m 755 $(@D)/pgms/* -t $(UNIXBENCH_TARGET_DIR)/pgms/
	$(INSTALL) -D -m 644 $(@D)/pgms/index.base -t $(UNIXBENCH_TARGET_DIR)/pgms/
	$(INSTALL) -D -m 644 $(@D)/pgms/unixbench.logo -t $(UNIXBENCH_TARGET_DIR)/pgms/
	$(INSTALL) -D -m 644 $(@D)/testdir/* -t $(UNIXBENCH_TARGET_DIR)/testdir/
	$(INSTALL) -d -m 755 $(UNIXBENCH_TARGET_DIR)/results \
		$(UNIXBENCH_TARGET_DIR)/tmp
endef

$(eval $(generic-package))
