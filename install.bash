#!/bin/bash

# How to execute (Install) 
# sudo bash ./install.bash $ROS_DISTRO

# How to execute (Uninstall)
# sudo bash ./install.bash uninstall

PROJECT_DIR=$(cd $(dirname $0); pwd)
TARGET_DIR='rclshark'
INSTALL_DIR='/opt'
COMPUTER_MSGS_VERSION='v1.0.0'
RCLSHARK_SMI_VERSION='v1.0.0'
BIN='/usr/local/bin'

RCLSHARK_WS=${INSTALL_DIR}'/'${TARGET_DIR}'_ws'

## Check superuser ======================================
if [ $(id -u) -ne 0 ]; then
    echo "You must execute this command as a superuser."
    echo "sudo bash ./install.bash \$ROS_DISTRO' or 'sudo bash ./install.bash uninstall'"
    exit 1
fi

## UNINSTALL =============================================
if [ $# -ne 1 ]; then
    echo "options failed ('sudo bash ./install.bash \$ROS_DISTRO' or 'sudo bash ./install.bash uninstall')"
    exit 1
fi

if [ "uninstall" = $1 ]; then
    echo "uninstall ..."
    for service_file in $RCLSHARK_WS/src/rclshark/rclshark/service/*.service ; do
        echo "uninstall" $service_file
        FILE=`basename $service_file`

        systemctl stop $FILE
        systemctl disable $FILE
        rm /etc/systemd/system/$FILE
    done
    systemctl daemon-reload
    rm -rf $INSTALL_DIR/${TARGET_DIR}_ws/
    rm $BIN/rclshark-smi
    echo "uninstalled"
    exit 0
else 
    source /opt/ros/$1/setup.bash
fi

## INSTALL =============================================
if [ -z $ROS_DISTRO ]; then
    echo "options failed ('sudo bash ./install.bash \$ROS_DISTRO' or 'sudo bash ./install.bash uninstall')"
    exit 1
fi

mkdir -p $RCLSHARK_WS/src
cp -r $PROJECT_DIR/../rclshark/ $RCLSHARK_WS/src/rclshark/
cd $RCLSHARK_WS/src/rclshark/ && rm -rf computer_msgs
cd $RCLSHARK_WS/src/rclshark/ && rm -rf rclshark-smi
cd $RCLSHARK_WS/src/rclshark/ && git clone https://github.com/Ar-Ray-code/computer_msgs.git -b $COMPUTER_MSGS_VERSION
cd $RCLSHARK_WS/src/rclshark/ && git clone https://github.com/Ar-Ray-code/rclshark-smi.git -b $RCLSHARK_SMI_VERSION

cd $RCLSHARK_WS && colcon build --symlink-install

for service_file in $RCLSHARK_WS/src/rclshark/rclshark/service/*.service ; do
    echo "User=$USER" >> $service_file

    FILE=`basename $service_file`
    echo "$service_file"
    echo "setting "$FILE"..."

    cp $service_file /etc/systemd/system/
    systemctl enable $FILE
done
cp $RCLSHARK_WS/src/rclshark/rclshark-smi/rclshark-smi $BIN/rclshark-smi
chmod +x $BIN/rclshark-smi

systemctl daemon-reload

echo "                                                       (}                    "
echo "                                                     ./ |                    "
echo "                                                    /   |                    "
echo "                                                  ./    |                    "
echo "                                                 _/_____\@\                  "
echo "                                             _/%@@@@@@@@@@@@@@@*\            "
echo " Thank you                                 /?@                  @@\_         "
echo "    for your interest      _%%%_         #@                        @\        "
echo "         in my rclshark ! @@@ @@@@%     @@                          @@       "
echo "                          @@@@@@@@@@#  @           L            k    @@      "
echo "                           @@@@@@@@@@#:/           L            k  _  %@     "
echo "                             @@@@@@@@*@  R r  cc   L    SS  R r k ?    @     "
echo "                                %@@@@*@  Rr  C  c  L  SS    Rr  K/     %@    "
echo "                                 @@@@*@  R  C      L    S   R   K\     |@    "
echo "                                  %@@*@  R   Ccc   L  SS    R   K \=   /@    "
echo "                                    @*%                               @@     "
echo "                                      =#@                            @@      "
echo "                                        =#@                       @@#        "
echo "                                         @####@@@@@@@@@@@@@@@@@@%###%        "
echo "                                         @@@@@%##- ###              \@@@.    "
echo "                                          @@@@@@@@   \}                      "
echo "                                            +@@@@@@@@                        "
echo "                                               =@@@@@@@@     by Ar-Ray 2021  "

sleep 1

echo "------------------------------------------------------"
echo "installation completed"
echo "run 'sudo systemctl start rclshark.service' to start rclshark"
echo "run 'rclshark-smi' to start rclshark-smi"
echo "------------------------------------------------------"

exit 0