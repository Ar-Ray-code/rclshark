#!/bin/python3
import subprocess
import os
import re
import signal
import time
import threading
import sys
import select

import rclpy
from rclpy.node import Node

from computer_msgs.msg import PcStatus
from computer_msgs.srv import PcStatusSrv

version_mejor = 0
version_minor = 1
version_revision = 0
version_build = str(version_mejor) + "." + str(version_minor) + "." + str(version_revision)

global_data = list()
srv_class_list = list()
ip_list = list()


# ==========================================================

class using_srv(Node):
    def __init__(self, _ip:str):
        self.ip = _ip
        super().__init__('get'+self.ip)
        self.sub_pc_0 = 'ip_'+self.ip+'_endcb'

    def __dell__(self):
        self.destroy_node()
        self.get_status.destroy()
        del self.req

    def reset_client(self) -> bool:
        self.get_status = self.create_client(PcStatusSrv, '/'+self.sub_pc_0)
        if not self.get_status.wait_for_service(timeout_sec=0.2):
            self.get_logger().info('service not available, waiting again...')
            return 1
        self.req = PcStatusSrv.Request()
        return 0
        
    def get_by_service(self):
        self.req.trigger = False
        self.future = self.get_status.call_async(self.req)

class srv_main:
    def __init__(self, _ip:str):
        self.ip = _ip
        self.ros_class = using_srv(self.ip)
    def __dell__(self):
        self.ros_class.destroy_node()
    
    def using_srv_fnc(self):
        if(self.ros_class.reset_client()):
            return 1
        self.req = self.ros_class.get_by_service()
        if rclpy.ok():
            rclpy.spin_once(self.ros_class)
            if self.ros_class.future.done():
                try:
                    self.ros_class.future.result().callback_status.cpu_percent
                    global_data.append(self.ros_class.future.result().callback_status)
                    rclpy.spin_once(self.ros_class)
                except Exception as e:
                    print(e)
            # break
        return 0

def show_data():
    global_data

    print("+============================================================================+")
    print("| RCLSHARK-SMI " + version_build + "\t" + "ROS-DISTRO " + os.environ['ROS_DISTRO'] + "\t\t\t\t\t     |")
    print("|============================================================================|")
    print("| ip_address\tcpu(%)\ttmp(*C)\tmem(%)\tdisk(%)\tps-cnt\t\t\t     |")
    print("|============================================================================|")
    terminal_col = 5

    for data in global_data:
        ip_data = int(data.ip_address.split(".")[3])
        data.local_tag = ip_data

    for data in sorted(global_data, reverse=False, key=lambda x: x.local_tag):
        print_status = "| "+ data.ip_address + "\t" + str(data.cpu_percent).rjust(5) + "\t" + str(data.core_temp).rjust(5) + "\t" + str(data.mem_percent).rjust(5) + "\t" + str(data.disk_percent).rjust(5) + "\t" + str(data.process_count).rjust(5) + "\t\t\t" + "     |"
        print(print_status)
        terminal_col = terminal_col + 1

    for i in range(22 - terminal_col):
        print("|\t\t\t\t\t\t\t\t\t     |")
    print("+============================================================================+")

def get_from_srv(srv_list:list, _ip_list:list):
    # get data from srv_list
    for i in range(len(srv_list)):
        try:
            out = srv_list[i].using_srv_fnc()
            if(out):
                _ip_list.remove(srv_list[i].ip)
        except:
            pass
    return srv_list, _ip_list

def get_ip_list() -> list:
    try:
        return re.findall("/ip_(.*)_end", str(subprocess.run(["ros2" , "node" , "list"], capture_output=True).stdout))[0].split("_end\\n/ip_")
    except:
        return []

def loop():
    global ip_list
    global srv_class_list
    
    ip_list = get_ip_list()
        
    # append ip_list to srv_list
    if(len(ip_list) > len(srv_class_list)):
        srv_class_list.clear()
        for i in ip_list:
            srv_class_list.append(srv_main(i))

    srv_class_list, ip_list = get_from_srv(srv_class_list, ip_list)

    show_data()
    global_data.clear()

def input_timeout(timeout=10):
    (ready, _, _) = select.select([sys.stdin], [], [], timeout)
    if ready:
        return sys.stdin.readline().rstrip('\n')
    else:
        return ''

def ros_main(args = None):
    global ip_list
    global srv_list
    rclpy.init(args=args)
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    while rclpy.ok():
        
        t = threading.Thread(target=loop,args=())
        t.setDaemon(True)
        t.start()
        t.join(timeout=5.0)

        if t.is_alive():
            ip_list.clear()
            for srv in srv_class_list:
                del srv
            exit(1)
        if input_timeout(0.1) == 'q':
            exit(1)
            
        del t
    rclpy.shutdown()

if __name__=='__main__':
    ros_main()