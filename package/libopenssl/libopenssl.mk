################################################################################
#
# libopenssl
#
################################################################################

ifeq ($(BR2_PACKAGE_LIBOPENSSL_1_0),y)
include $(pkgdir)/libopenssl-1.0.inc
else ifeq ($(BR2_PACKAGE_LIBOPENSSL_1_1),y)
include $(pkgdir)/libopenssl-1.1.inc
endif
