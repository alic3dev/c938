#ifndef __network_network_command_h
#define __network_network_command_h

enum network_command {
  network_command_no_operation = 0x00,
  network_command_initialize = 0x01,
  network_command_data_map = 0x02,
  network_command_disconnecting = 0x03,
  network_command_unknown = 0xff
};

#define network_command_maximum network_command_disconnecting

#endif
