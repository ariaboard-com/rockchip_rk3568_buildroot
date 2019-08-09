MODEL_LOADER_SITE = $(TOPDIR)/../framework/model_loader
MODEL_LOADER_SITE_METHOD = local
MODEL_LOADER_INSTALL_STAGING = YES

# add dependencies
MODEL_LOADER_DEPENDENCIES = libion adk

$(eval $(cmake-package))
