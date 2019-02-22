HECTOR_MAPPING_VERSION = 0.3.4
HECTOR_MAPPING_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_MAPPING_SOURCE = $(HECTOR_MAPPING_VERSION).tar.gz
HECTOR_MAPPING_SUBDIR = hector_mapping

HECTOR_MAPPING_DEPENDENCIES = cmake_modules roscpp nav-msgs visualization-msgs \
			      tf message-filters laser-geometry \
			      tf-conversions message-generation

$(eval $(catkin-package))
