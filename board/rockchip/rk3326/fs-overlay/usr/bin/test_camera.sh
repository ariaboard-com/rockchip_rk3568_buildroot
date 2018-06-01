#!/bin/sh

gst-launch-1.0 -vvv v4l2src device=/dev/video0 ! videoconvert ! kmssink
