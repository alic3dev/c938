#ifndef __c938_network_network_command_h
#define __c938_network_network_command_h

enum network_command {
  network_command_no_operation    = 0x00,
  network_command_initialize      = 0x01,
  network_command_data_map        = 0x02,
  network_command_data_map_loaded = 0x03,
  network_command_poll            = 0x04,
  network_command_enemies         = 0x05,
  network_command_disconnecting   = 0x06,
  network_command_error           = 0xfe,
  network_command_unknown         = 0xff
};

#define network_command_maximum network_command_disconnecting

#endif
