#!/bin/python3
import rclpy
from rclpy.logging import get_logger
from rclpy.node import Node

from computer_msgs.msg import PcStatus
from computer_msgs.srv import PcStatusSrv

import netifaces as ni
import psutil
import os
import socket
# ----------------------------------------

class sub_empty(Node):
    def __init__(self):
        super().__init__(self.ip_get(),enable_rosout=False)
        
        service = self.create_service(PcStatusSrv,self.ip_get()+'cb',self.status_cb)

    def sub_number(self,data):
        self.get_logger().info(str(data.data))

    def ip_get(self):
        result = []
        address_list = psutil.net_if_addrs()
        for nic in address_list.keys():
            ni.ifaddresses(nic)
            try:
                ip = ni.ifaddresses(nic)[ni.AF_INET][0]['addr']
                if ip not in ["127.0.0.1"]:
                    ip_data = ip.replace(".","_")
                    result.append(ip_data)
            except KeyError as err:
                ip_data = "0_0_0_0"
                result.append(ip_data)
                
                
        return "ip_"+str(result[0])+"_end"

    def ip_get_raw(self):
        result = []
        address_list = psutil.net_if_addrs()
        for nic in address_list.keys():
            ni.ifaddresses(nic)
            try:
                ip = ni.ifaddresses(nic)[ni.AF_INET][0]['addr']
                if ip not in ["127.0.0.1"]:
                    result.append(ip)
            except KeyError as err:
                pass
        return str(result[0])

    def get_pc_status(self):
        status = PcStatus()
        try:
            status.core_temp = int(psutil.sensors_temperatures()[next(iter(psutil.sensors_temperatures()))][0][1])
        except:
            status.core_temp = 0
        status.cpu_percent = int(psutil.cpu_percent(interval=0.5))
        # status.disk_percent = int(psutil.disk_usage('/').percent)
        # status.process_count = int(len(psutil.pids()))
        status.ip_address = self.ip_get_raw()
        status.mem_percent = int(psutil.virtual_memory().percent)
        
        try:
            status.user_name = os.environ.get("USER")
        except AssertionError:
        # user_name (string) is empty on docker
            status.user_name = "docker?"
        
        return status

    def status_cb(self, request, response:PcStatusSrv):
        response.callback_status = self.get_pc_status()
        return response

def ros_main(args = None):
    rclpy.init(args=args)
    
    ros_class = sub_empty()
    try:
        rclpy.spin(ros_class)
    except KeyboardInterrupt:
        pass

    ros_class.destroy_node()
    rclpy.shutdown()

if __name__=='__main__':
    ros_main()
