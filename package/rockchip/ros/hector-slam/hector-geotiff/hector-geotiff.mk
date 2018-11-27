HECTOR_GEOTIFF_VERSION = 0.3.4
HECTOR_GEOTIFF_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_GEOTIFF_SOURCE = $(HECTOR_GEOTIFF_VERSION).tar.gz
HECTOR_GEOTIFF_SUBDIR = hector_geotiff

HECTOR_GEOTIFF_DEPENDENCIES = eigen cmake_modules hector-map-tools \
			      hector-nav-msgs nav-msgs pluginlib \
			      roscpp std-msgs qt

$(eval $(catkin-package))
