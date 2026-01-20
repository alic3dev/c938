#ifndef __c938_network_network_client_h
#define __c938_network_network_client_h

#include <network/data/network_data_map.h>
#include <network/network.h>
#include <network/network_client_status.h>
#include <network/network_client_status_game.h>
#include <network/network_command.h>

#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

struct network_client {
  int socket;

  enum network_client_status status;
  enum network_client_status_game status_game;

  unsigned char address_ipv4[
    network_length_address_ipv4
  ];

  struct sockaddr_in address_host;

  struct network_data_map data_map;

  pthread_t thread_receiving;
  pthread_t thread_sending;

  pthread_mutex_t mutex;
  pthread_mutex_t mutex_sending;

  enum network_command command_sending;
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
