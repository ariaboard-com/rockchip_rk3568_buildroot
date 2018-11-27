HECTOR_MAP_TOOLS_VERSION = 0.3.4
HECTOR_MAP_TOOLS_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_MAP_TOOLS_SOURCE = $(HECTOR_MAP_TOOLS_VERSION).tar.gz
HECTOR_MAP_TOOLS_SUBDIR = hector_map_tools

HECTOR_MAP_TOOLS_DEPENDENCIES = nav-msgs

$(eval $(catkin-package))
