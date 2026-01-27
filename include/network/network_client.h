#ifndef __c938_network_network_client_h
#define __c938_network_network_client_h

#include <network/data/network_data_map.h>
#include <network/network.h>
#include <network/network_client_status.h>
#include <network/network_client_status_game.h>
#include <network/network_command.h>
#include <notification/notification_manager.h>

#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

enum network_client_notification_type {
  network_client_notification_type_default = 0,
  network_client_notification_type_error = 1,
  network_client_notification_type_data_map_sent = 2,
  network_client_notification_type_poll = 3
};

struct network_client {
  int socket;

  enum network_client_status status;
  enum network_client_status_game status_game;

  unsigned char address_ipv4[
    network_length_address_ipv4
  ];

  struct sockaddr_in address_host;

  struct notification_manager notification_manager;

  struct network_data_map data_map;

  pthread_t thread_receiving;
  pthread_t thread_sending;

  pthread_mutex_t mutex;
  pthread_mutex_t mutex_sending;
  pthread_mutex_t mutex_thread_sending;
  pthread_mutex_t mutex_network_data_packets_outgoing;
  pthread_mutex_t mutex_poll;
  pthread_mutex_t mutex_shots_fired;

  struct network_data_packet** network_data_packets_outgoing;
  unsigned int length_network_data_packets_outgoing;

  unsigned int connected_players;

  struct network_data_packet* network_data_packet_poll;

  struct network_data_shot_fired* shots_fired;
  unsigned int length_shots_fired;
};

struct network_client_thread_data {
  struct network_client* network_client;
};

unsigned char network_client_connect(
  struct network_client*
);

unsigned char network_client_connect_with_notification(
  struct network_client*,
  notification_manager_notification_on,
  void*
);

void* network_client_receiving_thread(
  void*
);

void* network_client_sending_thread(
  void*
);

void network_client_send(
  struct network_client*,
  struct network_data_packet*
);

void network_client_destroy(
  struct network_client*
);

#endif
