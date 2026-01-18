#ifndef __c938_network_network_client_h
#define __c938_network_network_client_h

#include <network/network.h>

#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

struct network_client {
  int socket;

  unsigned char address_ipv4[
    network_length_address_ipv4
  ];

  struct sockaddr_in address_host;
};

unsigned char network_client_connect(
  struct network_client*
);

#endif
