ROSCPP_CORE_VERSION = 0.6.11
ROSCPP_CORE_SITE = https://github.com/ros/roscpp_core/archive
ROSCPP_CORE_SOURCE = $(ROSCPP_CORE_VERSION).tar.gz
ROSCPP_CORE_SUBDIR = roscpp_core
ROSCPP_CORE_INSTALL_STAGING = YES
ROSCPP_CORE_DEPENDENCIES += host-catkin cpp_common rostime roscpp_traits roscpp_serialization

ROSCPP_CORE_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'


define ROSCPP_CORE_CONFIGURE_CMDS
        (mkdir -p $($(PKG)_BUILDDIR) && \
        cd $($(PKG)_BUILDDIR) && \
        rm -f CMakeCache.txt && \
        PATH=$(BR_PATH) \
        $($(PKG)_CONF_ENV) $(BR2_CMAKE) $($(PKG)_SRCDIR) \
                -DCMAKE_TOOLCHAIN_FILE="$(HOST_DIR)/share/buildroot/toolchainfile.cmake" \
                -DCMAKE_COLOR_MAKEFILE=OFF \
                -DBUILD_DOC=OFF \
                -DBUILD_DOCS=OFF \
                -DBUILD_EXAMPLE=OFF \
                -DBUILD_EXAMPLES=OFF \
                -DBUILD_TEST=OFF \
                -DBUILD_TESTS=OFF \
                -DBUILD_TESTING=OFF \
                -DBUILD_SHARED_LIBS=$(if $(BR2_STATIC_LIBS),OFF,ON) \
                $($(PKG)_CONF_OPTS) \
        )
endef

$(eval $(cmake-package))
