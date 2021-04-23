ARCUVC_VERSION = 1.0.1
ARCUVC_LICENSE = GPL-2.0
ARCUVC_VERSION = master
ARCUVC_SITE_METHOD = local
ARCUVC_SITE = $(TOPDIR)/../external/arcuvc_app
ARCUVC_INSTALL_STAGING = YES 


define ARCUVC_INSTALL_TARGET_CMDS
	
	rm -rf $(TARGET_DIR)/usr/share/arcuvc
	mkdir -p $(TARGET_DIR)/usr/share/arcuvc 

	cp $(@D)/ArcAICamera $(TARGET_DIR)/usr/share/arcuvc/ArcAICamera -rf
	cp $(@D)/initial_param.ini $(TARGET_DIR)/usr/share/arcuvc/ -rf
        $(INSTALL) -D -m 0755 $(@D)/start_app.sh $(TARGET_DIR)/usr/share/arcuvc
        $(INSTALL) -D -m 0755 $(@D)/S99_* $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
