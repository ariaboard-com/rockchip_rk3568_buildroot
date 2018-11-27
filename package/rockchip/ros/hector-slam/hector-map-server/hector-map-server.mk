HECTOR_MAP_SERVER_VERSION = 0.3.4
HECTOR_MAP_SERVER_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_MAP_SERVER_SOURCE = $(HECTOR_MAP_SERVER_VERSION).tar.gz
HECTOR_MAP_SERVER_SUBDIR = hector_map_server

HECTOR_MAP_SERVER_DEPENDENCIES = roscpp hector-map-tools hector-marker-drawing \
				 hector-nav-msgs nav-msgs tf

$(eval $(catkin-package))
