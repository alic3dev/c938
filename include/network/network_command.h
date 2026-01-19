#ifndef __network_network_command_h
#define __network_network_command_h

enum network_command {
  network_command_initialize = 0x00,
  network_command_datamap = 0x01,
  network_command_unknown = 0xff
};

#define network_command_maximum network_command_datamap

#endif
