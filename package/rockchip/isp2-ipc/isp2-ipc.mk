# Rockchip's MPP(Multimedia Processing Platform)

#LIBHDMISET_SITE = $(TOPDIR)/../external/libhdmiset
ifeq ($(BR2_PACKAGE_ISP2_IPC),y)
ISP2_IPC_SITE = $(TOPDIR)/../external/isp2-ipc
ISP2_IPC_SITE_METHOD = local
ISP2_IPC_INSTALL_STAGING = YES
ISP2_IPC_DEPENDENCIES = libglib2 dbus
endif
$(eval $(cmake-package))
