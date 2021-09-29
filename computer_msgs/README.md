# computer_msgs (v1.0.0)

For rclshark

## Message

### PcStatus.msg

- cpu_percent (uint8) : CPU Usage (0 ~ 100%)
- mem_percent (uint8) :  Memory Usage (0 ~ 100%)
- disk_percent (uint8) :  Disk Usage (0 ~ 100%)

- process_count (uint16) : Number of running processes on the computer.
- core_temp (uint8) : CPU temperature
- ip_address (string) : IP address (as string) -> e.g. :  '192.168.10.33'
- local_tag (uint8) : Used for sorting in rclshark-smi, but can be used as a variable for expansion.

## Service

### PcStatus.srv

#### Send by client

- system_ctrl (int8) : Extended variables for controlling the computer (reboot, shutdown, etc.).
- ctrl_param (int16) : Arguments for system_ctrl.

#### Callback

- callback_status (computer_msgs/PcStatus) : Status of the target server computer.

