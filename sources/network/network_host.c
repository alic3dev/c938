#include <network/network_host.h>

#include <network/data/network_data_packet.h>
#include <network/network.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <errno.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

#include <stdio.h>

unsigned char network_host_listen_with_notification(
  struct network_host* network_host,
  unsigned int length_threads,
  network_host_notification_on notification_on,
  void* notification_on_data
) {
  network_host->socket = (
    socket(
      AF_INET,
      SOCK_STREAM,
      0
    )
  );

  if (
    network_host->socket < 0
  ) {
    return 1;
  }

  network_host->address_socket.sin_family = (
    AF_INET
  );
  
  network_host->address_socket.sin_port = (
    htons(
      c938_network_port
    )
  );

  network_host->address_socket.sin_addr.s_addr = (
    htonl(
      INADDR_ANY
    )
  );

  int status_bind = (
    bind(
      network_host->socket,
      (
        (struct sockaddr*)
        &network_host->address_socket
      ),
      sizeof(
        network_host->address_socket
      )
    )
  );

  if (
    status_bind < 0
  ) {
    return 2;
  }

  int status_listen = (
    listen(
      network_host->socket,
      1
    )
  );

  if (
    status_listen < 0
  ) {
    return 3;
  }

  FD_ZERO(
    &network_host->file_descriptor_socket_set
  );

  FD_SET(
    network_host->socket,
    &network_host->file_descriptor_socket_set
  );

  network_host->connections_accept = 0;
  network_host->online = 1;

  network_host->length_threads = (
    1
  );

  network_host->threads = (
    clic3_memory_allocate_raw(
      sizeof(
        pthread_t
      ) *
      network_host->length_threads
    )
  );

  network_host->length_notification_on = 0;

  network_host->notification_on = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_host->notification_on_data = (
    clic3_memory_allocate_raw(
      0
    )
  );

  pthread_mutex_init(
    &network_host->mutex_notification,
    0
  );

  if (
    notification_on != 0
  ) {
    network_host_notification_on_add(
      network_host,
      notification_on,
      notification_on_data
    );
  }

  network_data_map_initialize(
    &network_host->data_map
  );

  network_host->socket_clients = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_host->clients_command_sending = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_host->mutex_clients = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_host->mutex_clients_sending = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_host->initialized = 1;

  network_host_notification_send(
    network_host,
    "network_host::online_and_active",
    network_host_notification_type_default
  );

  pthread_create(
    &network_host->threads[
      network_host->length_threads -
      1
    ],
    0,
    network_host_routing_thread,
    network_host
  );
  
  return 0;
}

unsigned char network_host_listen(
  struct network_host* network_host,
  unsigned int length_threads
) {
  return (
    network_host_listen_with_notification(
      network_host,
      length_threads,
      0,
      0
    )
  );
}

void* network_host_routing_thread(
  void* data
) {
  struct network_host* network_host = (
    data
  );

  network_host_notification_send(
    network_host,
    "network_thread::started",
    network_host_notification_type_default
  );

  while (
    network_host->online == 1
  ) {
    int status_select = (
      select(
        FD_SETSIZE,
        &network_host->file_descriptor_socket_set,
        0,
        0,
        0
      )
    );

    if (
      status_select != 1 ||
      network_host->connections_accept != 1
    ) {
      continue;
    }

    struct sockaddr address_socket_client;
    socklen_t length_socket_client = (
      sizeof(
        struct sockaddr
      )
    );

    int socket_client = (
      accept(
        network_host->socket,
        &address_socket_client,
        &length_socket_client
      )
    );

    if (
      socket_client < 0
    ) {
      continue;
    }

    char* char_array_address_client = (
      clic3_memory_allocate_raw(
        1
      )
    );

    char_array_address_client[0] = '\0';

    for (
      unsigned char index_char_array_address_client = 0;
      index_char_array_address_client < network_length_address_ipv4;
      ++index_char_array_address_client
    ) {
      char* char_array_address_client_part = (
        clic3_char_array_from_unsigned_long_int(
          address_socket_client.sa_data[
            network_offset_socket_address_data_ipv4 +
            index_char_array_address_client
          ]
        )
      );

      if (
        index_char_array_address_client > 0
      ) {
        char* char_array_address_client_part_prefixed = (
          clic3_char_arrays_concatenate(
            ".",
            char_array_address_client_part
          )
        );

        clic3_memory_free_raw(
          char_array_address_client_part
        );

        char_array_address_client_part = (
          char_array_address_client_part_prefixed
        );
      }

      char* char_array_address_client_part_joined = (
        clic3_char_arrays_concatenate(
          char_array_address_client,
          char_array_address_client_part
        )
      );

      clic3_memory_free_raw(
        char_array_address_client_part
      );

      clic3_memory_free_raw(
        char_array_address_client
      );

      char_array_address_client = (
        char_array_address_client_part_joined
      );
    }

    char_array_address_client[
      address_socket_client.sa_len
    ] = '\0';

    char* notification_prefix = (
      clic3_char_arrays_concatenate(
        "network_host::client_connected->{",
        char_array_address_client
      )
    );

    clic3_memory_free_raw(
      char_array_address_client
    );

    char* notification = (
      clic3_char_arrays_concatenate(
        notification_prefix,
        "};"
      )
    );

    clic3_memory_free_raw(
      notification_prefix
    );

    network_host_notification_send(
      network_host,
      notification,
      network_host_notification_type_default
    );

    clic3_memory_free_raw(
      notification
    );

    pthread_mutex_lock(
      &network_host->mutex_thread
    );

    network_host->length_threads = (
      network_host->length_threads +
      2
    );

    clic3_memory_reallocate_raw(
      &network_host->threads,
      (
        sizeof(
          pthread_t
        ) *
        network_host->length_threads
      )
    );

    static struct network_host_client_thread_data* network_host_client_receiving_thread_data;
    static struct network_host_client_thread_data* network_host_client_sending_thread_data;

    network_host_client_receiving_thread_data = (
      clic3_memory_allocate_raw(
        sizeof(
          struct network_host_client_thread_data
        )
      )
    );

    network_host_client_sending_thread_data = (
      clic3_memory_allocate_raw(
        sizeof(
          struct network_host_client_thread_data
        )
      )
    );

    network_host_client_receiving_thread_data->network_host = (
      network_host
    );

    network_host_client_receiving_thread_data->index_client = (
      network_host->length_clients
    );

    clic3_bytes_copy(
      network_host_client_sending_thread_data,
      network_host_client_receiving_thread_data,
      sizeof(
        struct network_host_client_thread_data
      )
    );

    network_host->length_clients = (
      network_host->length_clients +
      1
    );

    clic3_memory_reallocate_raw(
      &network_host->socket_clients,
      (
        sizeof(
          int
        ) *
        network_host->length_clients
      )
    );

    clic3_memory_reallocate_raw(
      &network_host->clients_command_sending,
      (
        sizeof(
          enum network_host_client_command_sending
        ) *
        network_host->length_clients
      )
    );

    clic3_memory_reallocate_raw(
      &network_host->mutex_clients,
      (
        sizeof(
          pthread_mutex_t
        ) *
        network_host->length_clients
      )
    );

    clic3_memory_reallocate_raw(
      &network_host->mutex_clients_sending,
      (
        sizeof(
          pthread_mutex_t
        ) *
        network_host->length_clients
      )
    );

    network_host->socket_clients[
      network_host_client_sending_thread_data->index_client
    ] = (
      socket_client
    );

    network_host->clients_command_sending[
      network_host_client_sending_thread_data->index_client
    ] = (
      network_host_client_command_sending_none
    );

    pthread_mutex_init(
      &network_host->mutex_clients[
        network_host_client_sending_thread_data->index_client
      ],
      0
    );

    pthread_mutex_init(
      &network_host->mutex_clients_sending[
        network_host_client_sending_thread_data->index_client
      ],
      0
    );

    pthread_mutex_lock(
      &network_host->mutex_clients_sending[
        network_host_client_sending_thread_data->index_client
      ]
    );

    pthread_create(
      &network_host->threads[
        network_host->length_threads -
        1
      ],
      0,
      network_host_client_receiving_thread,
      network_host_client_receiving_thread_data
    );

    pthread_create(
      &network_host->threads[
        network_host->length_threads -
        1
      ],
      0,
      network_host_client_sending_thread,
      network_host_client_sending_thread_data
    );

    pthread_mutex_unlock(
      &network_host->mutex_thread
    );

    network_host_data_map_client_index_send(
      network_host,
      network_host_client_sending_thread_data->index_client
    );
  }

  return 0;
}

void* network_host_client_receiving_thread(
  void* data
) {
  struct network_host_client_thread_data* network_host_client_thread_data = (
    data
  );

  struct network_host* network_host = (
    network_host_client_thread_data->network_host
  );

  unsigned int index_client = (
    network_host_client_thread_data->index_client
  );

  while (
    network_host->online
  ) {
    char data_client[
      c938_network_data_transfer_limit
    ];
    
    long int length_data_client = (
      recv(
        network_host->socket_clients[
          index_client
        ],
        data_client,
        c938_network_data_transfer_limit,
        0
      )
    );
  }

  clic3_memory_free_raw(
    network_host_client_thread_data
  );

  return 0;
}

void* network_host_client_sending_thread(
  void* data
) {
  struct network_host_client_thread_data* network_host_client_thread_data = (
    data
  );

  struct network_host* network_host = (
    network_host_client_thread_data->network_host
  );

  unsigned int index_client = (
    network_host_client_thread_data->index_client
  );

  unsigned char quitting = 0;

  while (
    network_host->online &&
    quitting == 0
  ) {
    pthread_mutex_lock(
      &network_host->mutex_clients_sending[
        index_client
      ]
    );

    enum network_host_client_command_sending network_host_client_command_sending = (
      network_host->clients_command_sending[
        index_client
      ]
    );

    switch(
      network_host_client_command_sending
    ) {
      case network_host_client_command_sending_quitting: {
        quitting = 1;
        break;
      }
      case network_host_client_command_sending_data_map: {
        pthread_mutex_lock(
          &network_host->data_map.mutex
        );

        long int length_bytes_sent = (
          network_data_packet_send(
            network_host->data_map.packet,
            network_host->socket_clients[
              index_client
            ]
          )
        );
        
        if (
          length_bytes_sent != network_host->data_map.packet->length
        ) {
          // failed to send
        }

        pthread_mutex_unlock(
          &network_host->data_map.mutex
        );
      }
      case network_host_client_command_sending_none:
      default: {
        break;
      }
    }

    pthread_mutex_unlock(
      &network_host->mutex_clients[
        index_client
      ]
    );
  }

  clic3_memory_free_raw(
    network_host_client_thread_data
  );

  return 0;
}

void network_host_data_map_client_index_send(
  struct network_host* network_host,
  unsigned int index_client
) {
  pthread_mutex_lock(
    &network_host->mutex_clients[
      index_client
    ]
  );

  network_host->clients_command_sending[
    index_client
  ] = (
    network_host_client_command_sending_data_map
  );

  pthread_mutex_unlock(
    &network_host->mutex_clients_sending[
      index_client
    ]
  );
}

void network_host_data_map_send(
  struct network_host* network_host
) {
  pthread_mutex_lock(
    &network_host->mutex_thread
  );

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    network_host_data_map_client_index_send(
      network_host,
      index_client
    );
  }

  pthread_mutex_unlock(
    &network_host->mutex_thread
  );
}

void network_host_connections_accept(
  struct network_host* network_host
) {
  network_host->connections_accept = 1;

  network_host_notification_send(
    network_host,
    "network_host::accepting_connections",
    network_host_notification_type_default
  );
}

void network_host_notification_send(
  struct network_host* network_host,
  char* notification,
  enum network_host_notification_type network_host_notification_type
) {
  pthread_mutex_lock(
    &network_host->mutex_notification
  );

  for (
    unsigned char index_notification_on = 0;
    index_notification_on < network_host->length_notification_on;
    ++index_notification_on
  ) {
    network_host->notification_on[
      index_notification_on
    ](
      notification,
      network_host->notification_on_data[
        index_notification_on
      ],
      network_host_notification_type
    );
  }

  pthread_mutex_unlock(
    &network_host->mutex_notification
  );
}

void network_host_notification_on_add(
  struct network_host* network_host,
  network_host_notification_on notification_on,
  void* notification_on_data
) {
  pthread_mutex_lock(
    &network_host->mutex_notification
  );

  network_host->length_notification_on = (
    network_host->length_notification_on +
    1
  );

  clic3_memory_reallocate_raw(
    &network_host->notification_on,
    (
      sizeof(
        network_host_notification_on
      ) *
      network_host->length_notification_on
    )
  );

  clic3_memory_reallocate_raw(
    &network_host->notification_on_data,
    (
      sizeof(
        void*
      ) *
      network_host->length_notification_on
    )
  );

  network_host->notification_on[
    network_host->length_notification_on -
    1
  ] = (
    notification_on
  );

  network_host->notification_on_data[
    network_host->length_notification_on -
    1
  ] = (
    notification_on_data
  );

  pthread_mutex_unlock(
    &network_host->mutex_notification
  );
}

void network_host_destroy(
  struct network_host* network_host
) {
  if (
    network_host->initialized != 1
  ) {
    return;
  }

  network_host->connections_accept = 0;
  network_host->online = 0;

  close(
    network_host->socket
  );

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    network_host->clients_command_sending[
      index_client
    ] = (
      network_host_client_command_sending_quitting
    );

    pthread_mutex_unlock(
      &network_host->mutex_clients_sending[
        index_client
      ]
    );

    close(
      network_host->socket_clients[
        index_client
      ]
    );
  }

  for (
    unsigned char index_thread = 0;
    index_thread < network_host->length_threads;
    ++index_thread
  ) {
    pthread_join(
      network_host->threads[
        index_thread
      ],
      0
    );
  }

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    pthread_mutex_destroy(
      &network_host->mutex_clients[
        index_client
      ]
    );

    pthread_mutex_destroy(
      &network_host->mutex_clients_sending[
        index_client
      ]
    );
  }

  pthread_mutex_destroy(
    &network_host->mutex_notification
  );

  pthread_mutex_destroy(
    &network_host->mutex_thread
  );

  network_data_map_destroy(
    &network_host->data_map
  );

  clic3_memory_free_raw(
    network_host->socket_clients
  );

  clic3_memory_free_raw(
    network_host->clients_command_sending
  );

  clic3_memory_free_raw(
    network_host->mutex_clients
  );

  clic3_memory_free_raw(
    network_host->mutex_clients_sending
  );

  clic3_memory_free_raw(
    network_host->threads
  );

  clic3_memory_free_raw(
    network_host->notification_on
  );

  clic3_memory_free_raw(
    network_host->notification_on_data
  );
}
