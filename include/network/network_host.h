#ifndef __network_host_h
#define __network_host_h

#include <data/network_data_map.h>

#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

enum network_host_notification_type {
  network_host_notification_type_default = 0,
  network_host_notification_type_error = 1
};

typedef void (*network_host_notification_on)(
  char*,
  void*,
  enum network_host_notification_type
);

enum network_host_client_command_sending {
  network_host_client_command_sending_quitting = 0,
  network_host_client_command_sending_none = 1,
  network_host_client_command_sending_data_map = 2
};

struct network_host {
  int socket;
  
  int* socket_clients;
  enum network_host_client_command_sending* clients_command_sending;
  unsigned int length_clients;

  struct sockaddr_in address_socket;

  unsigned char online;
  unsigned char connections_accept;
  unsigned char initialized;

  unsigned int length_threads;
  pthread_t* threads;

  network_host_notification_on* notification_on;
  void** notification_on_data;
  unsigned char length_notification_on;

  pthread_mutex_t* mutex_clients;
  pthread_mutex_t* mutex_clients_sending;
  pthread_mutex_t mutex_notification;
  pthread_mutex_t mutex_thread;

  fd_set file_descriptor_socket_set;

  struct network_data_map data_map;
};

struct network_host_client_thread_data {
  struct network_host* network_host;
  unsigned int index_client;
};

unsigned char network_host_listen_with_notification(
  struct network_host*,
  unsigned int,
  network_host_notification_on,
  void*
);

unsigned char network_host_listen(
  struct network_host*,
  unsigned int
);

void* network_host_routing_thread(
  void*
);

void* network_host_client_receiving_thread(
  void*
);

void* network_host_client_sending_thread(
  void*
);

void network_host_data_map_client_index_send(
  struct network_host*,
  unsigned int
);

void network_host_data_map_send(
  struct network_host*
);

void network_host_connections_accept(
  struct network_host*
);

void network_host_notification_on_add(
  struct network_host*,
  network_host_notification_on,
  void*
);

void network_host_notification_send(
  struct network_host*,
  char*,
  enum network_host_notification_type
);

void network_host_destroy(
  struct network_host*
);

#endif
