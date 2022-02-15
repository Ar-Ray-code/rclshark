#!/bin/python3
from ast import arg
from numpy import int32, uint8
import rclpy
from rclpy.logging import get_logger
from rclpy.node import Node

# from computer_msgs.msg import PcStatus
# from computer_msgs.srv import PcStatusSrv
from rclshark_msgs.msg import PcStatus

import netifaces as ni
import ipaddress
import psutil
import os
import socket

import argparse
# ----------------------------------------

class get_ip_for_rclshark():
    def __init__(self):
        pass

    def ipv424hex(self, ipv4:str) -> str:
        # input: "192.168.11.17"
        data = []
        for i in ipv4.split('.'):
            data.append(self.dec2hex(int(i)))
        return str(data[0])+str(data[1])+str(data[2])+str(data[3])

    def dec2hex(self, dec:int) -> str:
        # input 0 ~ 255
        int2hex = hex(dec)
        # to str using zfill and remove 0x
        return str(int2hex).replace("0x","").zfill(2)

    def ip_get_with_namespace(self, ipv4_str:str) -> str:
        ipv4_hex = self.ipv424hex(ipv4_str)

        try:
            user_name = os.environ.get("USER")
        except AssertionError:
        # user_name (string) is empty on docker
            user_name = "docker"

        return "rsk"+ipv4_hex+"_"+user_name.replace(" ","_").replace(".","_").replace("-","_")

    def ip_get_str(self):
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
    
    def ip_get_str_using_socket_name(self, interface:str) -> str:
        i = 0
        result = []
        address_list = psutil.net_if_addrs()

        for nic in address_list.keys():
            if (interface in ni.interfaces()[i]):
                ip = ni.ifaddresses(ni.interfaces()[i])[ni.AF_INET][0]['addr']
                return ip
            i += 1
        return "0.0.0.0"


class pub_status(Node):
    def __init__(self):
        self.ipv4_class = get_ip_for_rclshark()
        
        # argments
        parser = argparse.ArgumentParser(description='rclshark_node')
        parser.add_argument('--interface', type=str, default="", help='interface name')
        parser.add_argument('--const-ipv4', type=str, default="", help='ipv4 address')
        args = parser.parse_args()

        self.const_ip = False
        self.interface_set = False

        self.const_ip = str()
        self.interface = str()

        # get ipv4 address
        if args.const_ipv4 != "":
            self.const_ip = args.const_ipv4
            self.ip_get_str = args.const_ipv4
            const_ip = True
            interface_set = False
        
        if args.interface != "":
            self.interface = args.interface
            self.ip_get_str = self.ipv4_class.ip_get_str_using_socket_name(self.interface)
            const_ip = False
            interface_set = True

        if not( const_ip or interface_set ):
            self.ip_get_str = self.ipv4_class.ip_get_str()
            print("auto setting ipv4 address: "+self.ip_get_str)
            const_ip = False
            interface_set = False

        # ros init
        super().__init__(self.ipv4_class.ip_get_with_namespace(self.ip_get_str),enable_rosout=False)        

        self.pub = self.create_publisher(PcStatus, self.ipv4_class.ip_get_with_namespace(self.ip_get_str)+'_pub',10)
        # create timer
        self.timer = self.create_timer(1.0, self.status_pub)

    def get_pc_status(self) -> PcStatus:
        status = PcStatus()

        # CPU temp
        try:
            status.core_temp = int(psutil.sensors_temperatures()[next(iter(psutil.sensors_temperatures()))][0][1])
        except:
            status.core_temp = 0
        # CPU usage
        status.cpu_percent = int(psutil.cpu_percent(interval=0.5))
        
        # IP address
        if self.interface_set:
            status.ipv4_address_str = self.ipv4_class.ip_get_str_using_socket_name(self.interface)
            status.ipv4_address = int(ipaddress.IPv4Address(status.ipv4_address_str))
        
        elif self.const_ip:
            status.ipv4_address_str = self.const_ip
            status.ipv4_address = int(ipaddress.IPv4Address(status.ipv4_address_str))
        
        else:
            status.ipv4_address_str = self.ipv4_class.ip_get_str()
            status.ipv4_address = int(ipaddress.IPv4Address(status.ipv4_address_str))
        
        # RAM usage
        status.mem_percent = int(psutil.virtual_memory().percent)
        # Time stamp
        status.header.stamp = self.get_clock().now().to_msg()
        
        # User name
        try:
            status.user_name = os.environ.get("USER")
        except AssertionError:
            status.user_name = "docker"
        
        return status

    def status_pub(self):
        data = PcStatus()
        data = self.get_pc_status()
        self.pub.publish(data)

def ros_main(args = None):
    rclpy.init(args=args)
    
    ros_class = pub_status()
    try:
        rclpy.spin(ros_class)
    except KeyboardInterrupt:
        pass

    ros_class.destroy_node()
    rclpy.shutdown()

if __name__=='__main__':
    ros_main()
