#ifndef __data_network_map_h
#define __data_network_map_h

#include <pthread.h>

struct network_data_map {
  unsigned char* bytes;
  unsigned int length;

  pthread_mutex_t mutex;
};

void network_data_map_initialize(
  struct network_data_map*
);

void network_data_map_destroy(
  struct network_data_map*
);

#endif
