#ifndef __network_host_h
#define __network_host_h

#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

#define c938_network_host_port 3938

typedef void (*network_host_notification_on)(char*);

struct network_host {
  int socket;

  struct sockaddr_in address_socket;

  unsigned int online;

  unsigned int length_threads;
  pthread_t* threads;

  network_host_notification_on* notification_on;
  unsigned char length_notification_on;

  fd_set file_descriptor_socket_set;
};

unsigned char network_host_listen(
  struct network_host*,
  unsigned int
);

void* network_host_thread(
  void*
);

void network_host_notification_on_add(
  struct network_host*,
  network_host_notification_on
);

void network_host_notification_send(
  struct network_host*,
  char*
);

#endif
