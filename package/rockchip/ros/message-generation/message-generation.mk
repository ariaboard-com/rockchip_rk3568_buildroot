MESSAGE_GENERATION_VERSION = 0.2.10	#groovy
MESSAGE_GENERATION_SOURCE = $(MESSAGE_GENERATION_VERSION).tar.gz
MESSAGE_GENERATION_SITE = https://github.com/ros/message_generation/archive

MESSAGE_GENERATION_DEPENDENCIES = gencpp genlisp genpy

$(eval $(catkin-package))
