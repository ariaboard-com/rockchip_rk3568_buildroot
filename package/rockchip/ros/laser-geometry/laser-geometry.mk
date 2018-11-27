LASER_GEOMETRY_VERSION = 1.6.4
LASER_GEOMETRY_SITE = https://github.com/ros-perception/laser_geometry/archive
LASER_GEOMETRY_SOURCE = ${LASER_GEOMETRY_VERSION}.tar.gz

LASER_GEOMETRY_DEPENDENCIES = eigen boost angles roscpp sensor-msgs tf tf2

${eval ${catkin-package}}
