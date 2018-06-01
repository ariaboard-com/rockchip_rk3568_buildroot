MALI_ROCKCHIP_SITE = "https://github.com/rockchip-linux/libmali.git"
MALI_ROCKCHIP_VERSION = rockchip
MALI_ROCKCHIP_SITE_METHOD = git
MALI_ROCKCHIP_GIT_SUBMODULES = YES
#MALI_ROCKCHIP_PROVIDES = libegl libgles lGLESv2
MALI_ROCKCHIP_PROVIDES = libgles 
MALI_ROCKCHIP_INSTALL_STAGING = YES
$(eval $(cmake-package))
$(eval $(host-cmake-package))
