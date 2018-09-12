ROSPACK_VERSION = 2.2.8
ROSPACK_SITE = https://github.com/ros/rospack/archive
ROSPACK_SOURCE = ${ROSPACK_VERSION}.tar.gz

ROSPACK_DEPENDENCIES = boost tinyxml cmake_modules python

${eval ${catkin-package}}
