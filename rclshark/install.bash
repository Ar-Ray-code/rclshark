#!/bin/bash

# How to execute (Install) 
# sudo bash ./install.bash

# How to execute (Uninstall)
# sudo bash ./install.bash uninstall

PROJECT_DIR=$(cd $(dirname $0); pwd)
TARGET_DIR='rclshark'
INSTALL_DIR='/opt'

## Check superuser ======================================

if [ $(id -u) -ne 0 ]; then
    echo "You must execute this command as a superuser. (sudo bash ./install.bash)"
    exit 1
fi

## UNINSTALL =============================================

if [ $# -eq 1 ]; then
    if [ "uninstall" = $1 ]; then
        echo "uninstall ..."
        for service_files in $INSTALL_DIR/$TARGET_DIR/service/*.service ; do
            FILE=`basename $service_files`

            systemctl disable $FILE
            rm /etc/systemd/system/$FILE
        done
        rm -r $INSTALL_DIR/$TARGET_DIR/
        echo "uninstalled"
        exit 0
    else
        echo "options failed ('sudo bash ./install.bash' or 'sudo bash ./install.bash uninstall')"
        exit 1
    fi
fi

## INSTALL =============================================

cp -r $PROJECT_DIR/ $INSTALL_DIR/

for service_files in $INSTALL_DIR/$TARGET_DIR/service/*.service ; do
    FILE=`basename $service_files`
    echo "setting "$FILE"..."

    cp $service_files /etc/systemd/system/
    systemctl enable $FILE
done
