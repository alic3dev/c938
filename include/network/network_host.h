#ifndef __network_host_h
#define __network_host_h

#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

#define c938_network_host_port 3938

enum network_host_notification_type {
  network_host_notification_type_default = 0,
  network_host_notification_type_error = 1
};

typedef void (*network_host_notification_on)(
  char*,
  void*,
  enum network_host_notification_type
);

struct network_host {
  int socket;

  struct sockaddr_in address_socket;

  unsigned char online;
  unsigned char connections_accept;
  unsigned char initialized;

  unsigned int length_threads;
  pthread_t* threads;

  network_host_notification_on* notification_on;
  void** notification_on_data;
  unsigned char length_notification_on;

  pthread_mutex_t mutex_notification;

  fd_set file_descriptor_socket_set;
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

void* network_host_thread(
  void*
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
