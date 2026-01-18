#include <network/network_client.h>

#include <data/network_data_map.h>
#include <network/network.h>

#include <clic3_memory.h>

#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

unsigned char network_client_connect(
  struct network_client* network_client
) {
  network_client->status = (
    network_client_status_none
  );

  network_client->command_sending = (
    network_client_command_sending_none
  );

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
    close(
      network_client->socket
    );

    return 2;
  }

  network_data_map_initialize(
    &network_client->data_map
  );

  network_client->status = (
    network_client->status |
    network_client_status_initialized |
    network_client_status_connected
  );

  static struct network_client_thread_data* network_client_receiving_thread_data;
  static struct network_client_thread_data* network_client_sending_thread_data;

  network_client_receiving_thread_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct network_client_thread_data
      )
    )
  );

  network_client_sending_thread_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct network_client_thread_data
      )
    )
  );

  network_client_receiving_thread_data->network_client = (
    network_client
  );

  network_client_sending_thread_data->network_client = (
    network_client
  );

  pthread_mutex_init(
    &network_client->mutex,
    0
  );

  pthread_mutex_init(
    &network_client->mutex_sending,
    0
  );

  pthread_mutex_lock(
    &network_client->mutex_sending
  );

  pthread_create(
    &network_client->thread_receiving,
    0,
    network_client_receiving_thread,
    network_client_receiving_thread_data
  );

  pthread_create(
    &network_client->thread_receiving,
    0,
    network_client_sending_thread,
    network_client_sending_thread_data
  );

  return 0;
}

void* network_client_receiving_thread(
  void* data
) {
  struct network_client_thread_data* network_client_thread_data = (
    data
  );

  struct network_client* network_client = (
    network_client_thread_data->network_client
  );

  while (
    network_client->status != network_client_status_quitting
  ) {
    pthread_mutex_lock(
      &network_client->mutex
    );

    unsigned char data_host[
      c938_network_data_transfer_limit
    ];

    long int length_data_received = (
      recv(
        network_client->socket,
        data_host,
        c938_network_data_transfer_limit,
        0
      )
    );

    if (
      length_data_received > c938_network_data_transfer_limit ||
      length_data_received < 1
    ) {
      return 0;
    }

    enum network_command network_command = (
      data_host[0]
    );

    switch (
      network_command
    ) {
      case network_command_initialize: {
        break;
      }
      case network_command_datamap: {
        network_data_map_bytes_set(
          &network_client->data_map,
          data_host,
          length_data_received
        );

        break;
      }
      default: {
        break;
      }
    }

    pthread_mutex_unlock(
      &network_client->mutex
    );
  }

  clic3_memory_free(
    network_client_thread_data
  );

  return 0;
}

void* network_client_sending_thread(
  void* data
) {
  struct network_client_thread_data* network_client_thread_data = (
    data
  );

  struct network_client* network_client = (
    network_client_thread_data->network_client
  );

  unsigned int quitting = 0;

  while (
    network_client->status != network_client_status_quitting &&
    quitting == 0
  ) {
    pthread_mutex_lock(
      &network_client->mutex_sending
    );

    switch (
      network_client->command_sending
    ) {
      case network_client_command_sending_quitting: {
        quitting = 1;

        break;
      }
      case network_client_command_sending_none:
      default: {
        break;
      }
    }
  }
  
  clic3_memory_free(
    network_client_thread_data
  );

  return 0;
}

void network_client_destroy(
  struct network_client* network_client
) {
  if (
    network_client->status == network_client_status_none
  ) {
    return;
  }

  network_client->status = network_client_status_quitting;

  pthread_mutex_unlock(
    &network_client->mutex_sending
  );

  close(
    network_client->socket
  );

  pthread_join(
    network_client->thread_receiving,
    0
  );

  pthread_join(
    network_client->thread_sending,
    0
  );

  pthread_mutex_destroy(
    &network_client->mutex
  );

  pthread_mutex_destroy(
    &network_client->mutex_sending
  );

  network_data_map_destroy(
    &network_client->data_map
  );
}
