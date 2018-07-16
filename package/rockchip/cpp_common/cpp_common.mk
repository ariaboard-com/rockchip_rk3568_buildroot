CPP_COMMON_VERSION = 0.6.11
CPP_COMMON_SITE = https://github.com/ros/roscpp_core/archive
CPP_COMMON_SOURCE = $(CPP_COMMON_VERSION).tar.gz
CPP_COMMON_SUBDIR = cpp_common
CPP_COMMON_INSTALL_STAGING = YES
CPP_COMMON_DEPENDENCIES += host-catkin console-bridge boost

CPP_COMMON_CONF_OPTS += -DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' -DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'
define CPP_COMMON_CONFIGURE_CMDS
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
                $(CMAKE_QUIET) \
                $($(PKG)_CONF_OPTS) \
        )
endef

$(eval $(cmake-package))
