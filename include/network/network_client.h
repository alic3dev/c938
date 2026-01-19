#ifndef __c938_network_network_client_h
#define __c938_network_network_client_h

#include <network/data/network_data_map.h>
#include <network/network.h>

#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

enum network_client_status {
  network_client_status_none = 0b0000,
  network_client_status_quitting = 0b1111,
  network_client_status_initialized = 0b0001,
  network_client_status_connected = 0b0010
};

enum network_client_command_sending {
  network_client_command_sending_quitting = 0,
  network_client_command_sending_none = 1,
  network_client_command_sending_poll = 2
};

struct network_client {
  int socket;

  unsigned char status;

  unsigned char address_ipv4[
    network_length_address_ipv4
  ];

  struct sockaddr_in address_host;

  struct network_data_map data_map;

  pthread_t thread_receiving;
  pthread_t thread_sending;

  pthread_mutex_t mutex;
  pthread_mutex_t mutex_sending;

  enum network_client_command_sending command_sending;
};

struct network_client_thread_data {
  struct network_client* network_client;
};

unsigned char network_client_connect(
  struct network_client*
);

void* network_client_receiving_thread(
  void*
);

void* network_client_sending_thread(
  void*
);

void network_client_destroy(
  struct network_client*
);

#endif
