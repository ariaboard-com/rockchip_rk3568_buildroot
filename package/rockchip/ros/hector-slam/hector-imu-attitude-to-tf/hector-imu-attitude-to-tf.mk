HECTOR_IMU_ATTITUDE_TO_TF_VERSION = 0.3.4
HECTOR_IMU_ATTITUDE_TO_TF_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_IMU_ATTITUDE_TO_TF_SOURCE = $(HECTOR_IMU_ATTITUDE_TO_TF_VERSION).tar.gz
HECTOR_IMU_ATTITUDE_TO_TF_SUBDIR = hector_imu_attitude_to_tf

HECTOR_IMU_ATTITUDE_TO_TF_DEPENDENCIES = roscpp sensor-msgs tf

$(eval $(catkin-package))
