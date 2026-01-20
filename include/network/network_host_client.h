#ifndef __network_network_host_client_h
#define __network_network_host_client_h

#include <network/network_client_status.h>
#include <network/network_command.h>

#include <pthread.h>

struct network_host_client {
  int socket;

  pthread_mutex_t mutex;
  pthread_mutex_t mutex_sending;

  enum network_client_status status;

  enum network_command command_sending;
};

void network_host_client_initialize(
  struct network_host_client*,
  int
);

void network_host_client_destroy(
  struct network_host_client*
);

#endif
