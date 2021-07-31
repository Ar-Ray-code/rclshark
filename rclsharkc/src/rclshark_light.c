#include <stdio.h>
#include <unistd.h>

#include <rcl/rcl.h>
#include <rcl/error_handling.h>
#include <rclc/rclc.h>
#include <rclc/executor.h>

// computer_msgs
#include <computer_msgs/msg/pc_status.h>
#include <computer_msgs/srv/pc_status_srv.h>

//=================================================================

// computer_msgs__srv__PcStatusSrv_Request req;
// computer_msgs__srv__PcStatusSrv_Response res;

// void service_callback(const void * req, void * res)
// {
//   computer_msgs__srv__PcStatusSrv_Request * req_in =  (computer_msgs__srv__PcStatusSrv_Request *) req;
//   computer_msgs__srv__PcStatusSrv_Response * res_in = (computer_msgs__srv__PcStatusSrv_Response *) res;

//   res_in->callback_status.core_temp = 0;
//   res_in->callback_status.cpu_percent = 0;
//   res_in->callback_status.disk_percent = 0;
//   res_in->callback_status.local_tag = 0;
//   res_in->callback_status.mem_percent = 0;
//   res_in->callback_status.process_count = 0;
// }

int main(int argc, const char * const * argv)
{
  RCLC_UNUSED(argc);
  RCLC_UNUSED(argv);
  rcl_allocator_t allocator = rcl_get_default_allocator();
  rclc_support_t support;

  // create init_options
  rclc_support_init(&support, 0, NULL, &allocator);

  // create node
  rcl_node_t node = rcl_get_zero_initialized_node();
  rclc_node_init_default(&node, "rclshark_c_c", "", &support);

  // create service
  // rcl_service_t service = rcl_get_zero_initialized_service();
  
  //   rclc_service_init_default(
  //     &service, &node,
  //     ROSIDL_GET_SRV_TYPE_SUPPORT(computer_msgs, srv, PcStatusSrv), "/pc_status");

  // create executor
  rclc_executor_t executor = rclc_executor_get_zero_initialized_executor();
  rclc_executor_init(&executor, &support.context, 1, &allocator);

  unsigned int rcl_wait_timeout = 10;         // in ms
  rclc_executor_set_timeout(&executor, RCL_MS_TO_NS(rcl_wait_timeout));

  // rclc_executor_add_service(&executor, &service, &req, &res, service_callback);

  // Optional prepare for avoiding allocations during spin
  // rclc_executor_prepare(&executor);

  rclc_executor_spin(&executor);

  // rcl_service_fini(&service, &node);
  rcl_node_fini(&node);
}
