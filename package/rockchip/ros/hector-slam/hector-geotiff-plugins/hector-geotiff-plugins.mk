HECTOR_GEOTIFF_PLUGINS_VERSION = 0.3.4
HECTOR_GEOTIFF_PLUGINS_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_GEOTIFF_PLUGINS_SOURCE = $(HECTOR_GEOTIFF_PLUGINS_VERSION).tar.gz
HECTOR_GEOTIFF_PLUGINS_SUBDIR = hector_geotiff_plugins

HECTOR_GEOTIFF_PLUGINS_DEPENDENCIES = hector-geotiff hector-nav-msgs

$(eval $(catkin-package))
