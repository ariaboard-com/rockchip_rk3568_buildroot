ARCFACE_VERSION = 1.0.1
ARCFACE_LICENSE = GPL-2.0
ARCFACE_VERSION = master
ARCFACE_SITE_METHOD = local
ARCFACE_SITE = $(TOPDIR)/../external/arcface_app
ARCFACE_INSTALL_STAGING = YES 


define ARCFACE_INSTALL_TARGET_CMDS
	
	rm -rf $(TARGET_DIR)/usr/share/arc
	mkdir -p $(TARGET_DIR)/usr/share/arc 

	cp $(@D)/ArcFaceGo $(TARGET_DIR)/usr/share/arc/ArcFaceGo -rf
	cp $(@D)/ArcFaceServer $(TARGET_DIR)/usr/share/arc/ArcFaceServer -rf
        $(INSTALL) -D -m 0755 $(@D)/start_app.sh $(TARGET_DIR)/usr/share/arc
        $(INSTALL) -D -m 0755 $(@D)/S99_* $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
