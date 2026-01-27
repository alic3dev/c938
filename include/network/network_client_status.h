#ifndef __c938_network_network_client_status_h
#define __c938_network_network_client_status_h

enum network_client_status {
  network_client_status_none          = 0b00000000,
  network_client_status_disconnected  = 0b10000000,
  network_client_status_disconnecting = 0b01000000,
  network_client_status_initializing  = 0b00000100,
  network_client_status_initialized   = 0b00000010,
  network_client_status_connected     = 0b00000001
};

#endif
