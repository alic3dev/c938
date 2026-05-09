#ifndef __c938_network_network_client_status_game_h
#define __c938_network_network_client_status_game_h

enum network_client_status_game {
  network_client_status_game_disconnected = 0x00,
  network_client_status_game_loading      = 0x01,
  network_client_status_game_loaded       = 0x02,
  network_client_status_game_playing      = 0x03
};

#endif
