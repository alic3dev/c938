#ifndef __c938_network_network_h
#define __c938_network_network_h

#define network_length_address_ipv4 4

#define network_offset_socket_address_data_ipv4 2

#define c938_network_port 3938
#define c938_network_data_transfer_limit 50000

enum network_command {
  network_command_initialize = 0x00,
  network_command_datamap = 0x01
};

#endif
