#include <network/network_client.h>

#include <network/network.h>

#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

unsigned char network_client_connect(
  struct network_client* network_client
) {
  network_client->socket = (
    socket(
      AF_INET,
      SOCK_STREAM,
      0
    )
  );

  if (
    network_client->socket < 0
  ) {
    return 1;
  }

  network_client->address_ipv4[0] = 0x7f;
  network_client->address_ipv4[1] = 0x00;
  network_client->address_ipv4[2] = 0x00;
  network_client->address_ipv4[3] = 0x01;

  network_client->address_host.sin_family = (
    AF_INET
  );

  network_client->address_host.sin_port = (
    htons(
      c938_network_port
    )
  );

  unsigned char* bytes_ipv4_address = (
    (unsigned char*)
    &network_client->address_host.sin_addr.s_addr
  );

  for (
    unsigned char index_byte_address_ipv4 = 0;
    index_byte_address_ipv4 < network_length_address_ipv4;
    ++index_byte_address_ipv4
  ) {
    bytes_ipv4_address[
      index_byte_address_ipv4
    ] = (
      network_client->address_ipv4[
        index_byte_address_ipv4
      ]
    );
  }

  int status_connect = (
    connect(
      network_client->socket,
      (
        (struct sockaddr*)
        &network_client->address_host
      ),
      sizeof(
        network_client->address_host
      )
    )
  );

  if (
    status_connect < 0
  ) {
    printf("failed_to_connect\n");

    close(
      network_client->socket
    );

    return 2;
  }

  printf("connected\n");

  close(
    network_client->socket
  );

  return 0;
}
