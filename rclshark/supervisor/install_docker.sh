#!/bin/sh

# How to execute (Install) 
# sudo bash ./install.bash

# How to execute (Uninstall)
# sudo bash ./install.bash uninstall

PROJECT_DIR=$(cd $(dirname $0); pwd)
INSTALL_DIR='/opt'

cp -r $PROJECT_DIR/../../rclshark/ $INSTALL_DIR/
