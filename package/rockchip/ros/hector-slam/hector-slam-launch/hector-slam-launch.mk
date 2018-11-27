HECTOR_SLAM_LAUNCH_VERSION = 0.3.4
HECTOR_SLAM_LAUNCH_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_SLAM_LAUNCH_SOURCE = $(HECTOR_SLAM_LAUNCH_VERSION).tar.gz
HECTOR_SLAM_LAUNCH_SUBDIR = hector_slam_launch

$(eval $(catkin-package))
