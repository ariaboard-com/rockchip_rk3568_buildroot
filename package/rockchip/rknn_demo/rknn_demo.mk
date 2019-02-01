################################################################################
#
# rknn demo
#
################################################################################

RKNN_DEMO_VERSION = 1.0.0
RKNN_DEMO_SITE = $(TOPDIR)/../external/rknn_demo
RKNN_DEMO_SITE_METHOD = local
RKNN_DEMO_DEPENDENCIES = jpeg libpng12 libv4l rknpu linux-rga minigui

ifeq ($(BR2_PACKAGE_RKNN_DEMO_ENABLE_JOINT),y)
	RKNN_DEMO_CONF_OPTS += -DENABLE_JOINT=1
else
	RKNN_DEMO_CONF_OPTS += -DENABLE_SSD=1
endif


ifeq ($(BR2_PACKAGE_RKNN_DEMO_ENABLE_JOINT),y)
define RKNN_DEMO_INSTALL_TARGET_CMDS
		mkdir -p $(TARGET_DIR)/usr/share/rknn_demo/
		mkdir -p $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0644 $(@D)/rknn/joint/cpm.rknn $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/minigui/MiniGUI.cfg $(TARGET_DIR)/etc
		cp -r $(@D)/minigui/ $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0755 $(@D)/rknn_demo $(TARGET_DIR)/usr/bin
endef
else
define RKNN_DEMO_INSTALL_TARGET_CMDS
		mkdir -p $(TARGET_DIR)/usr/share/rknn_demo/
		mkdir -p $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_inception_v2.rknn $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/coco_labels_list.txt $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/box_priors.txt $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/minigui/MiniGUI.cfg $(TARGET_DIR)/etc
		cp -r $(@D)/minigui/ $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0755 $(@D)/rknn_demo $(TARGET_DIR)/usr/bin
endef
endif

$(eval $(cmake-package))
