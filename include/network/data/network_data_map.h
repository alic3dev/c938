#ifndef __c938_network_data_network_map_h
#define __c938_network_data_network_map_h

#include <network/data/network_data_packet.h>

#include <pthread.h>

struct network_data_map {
  struct network_data_packet* packet;

  pthread_mutex_t mutex;
};

void network_data_map_initialize(
  struct network_data_map*
);

void network_data_map_packet_set(
  struct network_data_map*,
  struct network_data_packet*
);

void network_data_map_destroy(
  struct network_data_map*
);

#endif
