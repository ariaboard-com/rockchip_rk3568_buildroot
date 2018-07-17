CATKIN_VERSION = 0.7.14
CATKIN_SITE = https://github.com/ros/catkin/archive
CATKIN_SOURCE = $(CATKIN_VERSION).tar.gz
CATKIN_INSTALL_STAGING = YES

HOST_CATKIN_DEPENDENCIES += host-python-catkin_pkg host-python-em host-python-empy

HOST_CATKIN_CONF_OPTS += -DCMAKE_PREFIX_PATH=$(HOST_DIR)/opt/ros/kinetic -DCMAKE_INSTALL_PREFIX=$(HOST_DIR)/opt/ros/kinetic
define CATKIN_CONFIGURE_CMDS
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

# The toolchain file limited package search path(CMAKE_FIND_ROOT_PATH)
# to the staging dir.
define HOST_CATKIN_SYMLINK_STAGING
	$(INSTALL) -d $(STAGING_DIR)/opt/ros/kinetic/share
	ln -sf $(HOST_DIR)/opt/ros/kinetic/share/catkin $(STAGING_DIR)/opt/ros/kinetic/share
endef

HOST_CATKIN_POST_INSTALL_HOOKS += HOST_CATKIN_SYMLINK_STAGING

$(eval $(cmake-package))
$(eval $(host-cmake-package))
