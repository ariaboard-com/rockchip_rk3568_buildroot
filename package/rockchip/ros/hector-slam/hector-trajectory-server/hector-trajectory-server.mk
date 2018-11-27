HECTOR_TRAJECTORY_SERVER_VERSION = 0.3.4
HECTOR_TRAJECTORY_SERVER_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_TRAJECTORY_SERVER_SOURCE = $(HECTOR_TRAJECTORY_SERVER_VERSION).tar.gz
HECTOR_TRAJECTORY_SERVER_SUBDIR = hector_trajectory_server

HECTOR_TRAJECTORY_SERVER_DEPENDENCIES = roscpp hector-nav-msgs nav-msgs \
					hector-map-tools tf

$(eval $(catkin-package))
