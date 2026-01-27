#include <network/network_host.h>

#include <data/data_length.h>
#include <network/data/network_data_packet.h>
#include <network/network.h>
#include <network/network_client_status.h>
#include <network/network_client_status_game.h>
#include <network/network_command.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <errno.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

unsigned char network_host_listen(
  struct network_host* network_host
) {
  return (
    network_host_listen_with_notification(
      network_host,
      0,
      0
    )
  );
}

unsigned char network_host_listen_with_notification(
  struct network_host* network_host,
  notification_manager_notification_on notification_on,
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

  pthread_mutex_init(
    &network_host->mutex_thread,
    0
  );

  pthread_mutex_init(
    &network_host->mutex_position,
    0
  );

  pthread_mutex_init(
    &network_host->mutex_shots_fired,
    0
  );

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

  network_host->length_shots_fired = 0;
  network_host->shots_fired = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_data_map_initialize(
    &network_host->data_map
  );

  network_host->clients = (
    clic3_memory_allocate_raw(
      0
    )
  );

  notification_manager_initialize(
    &network_host->notification_manager
  );

  if (
    notification_on != 0
  ) {
    notification_manager_notification_on_add(
      &network_host->notification_manager,
      notification_on,
      notification_on_data
    );
  }

  network_host->initialized = 1;
  network_host->connected_players = 0;

  notification_manager_send(
    &network_host->notification_manager,
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

void* network_host_routing_thread(
  void* data
) {
  struct network_host* network_host = (
    data
  );

  notification_manager_send(
    &network_host->notification_manager,
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

    notification_manager_send(
      &network_host->notification_manager,
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

    network_host->length_clients = (
      network_host->length_clients +
      1
    );

    clic3_memory_reallocate_raw(
      &network_host->clients,
      (
        sizeof(
          struct network_host_client*
        ) *
        network_host->length_clients
      )
    );

    network_host->clients[
      network_host_client_receiving_thread_data->index_client
    ] = (
      clic3_memory_allocate_raw(
        sizeof(
          struct network_host_client
        )
      )
    );

    struct network_host_client* network_host_client = (
      network_host->clients[
        network_host_client_receiving_thread_data->index_client
      ]
    );

    network_host_client_initialize(
      network_host_client,
      socket_client,
      network_host_client_receiving_thread_data->index_client
    );

    network_host_client_receiving_thread_data->network_host_client = (
      network_host_client
    );

    clic3_bytes_copy(
      network_host_client_sending_thread_data,
      network_host_client_receiving_thread_data,
      sizeof(
        struct network_host_client_thread_data
      )
    );

    pthread_create(
      &network_host->threads[
        network_host->length_threads -
        2
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

    network_host_client->status = (
      network_client_status_connected
    );

    network_host->connected_players = (
      network_host->connected_players +
      1
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

  struct network_host_client* network_host_client = (
    network_host_client_thread_data->network_host_client
  );

  while (
    network_host->online &&
    (
      network_host_client->status & (
        network_client_status_disconnected |
        network_client_status_disconnecting
      )
    ) == 0
  ) {
    char data_received_client[
      c938_network_data_transfer_limit
    ];
    
    long int length_data_received_client = (
      recv(
        network_host_client->socket,
        data_received_client,
        c938_network_data_transfer_limit,
        0
      )
    );

    if (
      length_data_received_client > c938_network_data_transfer_limit ||
      length_data_received_client <= 0
    ) {
      network_host_client->status = (
        network_client_status_disconnected
      );

      continue;
    }

    struct network_data_packet network_data_packet;

    network_data_packet_initialize_from_bytes(
      &network_data_packet,
      data_received_client,
      length_data_received_client
    );

    switch (
      network_data_packet.command
    ) {
      case network_command_disconnecting: {
        network_host_client->status_game = (
          network_client_status_game_disconnected
        );

        network_host_client->status = (
          network_client_status_disconnecting
        );

        char* notification_prefix = (
          clic3_char_arrays_concatenate(
            "network_host_client::disconnecting->{",
            network_host_client->char_array_index
          )
        );

        char* notification = (
          clic3_char_arrays_concatenate(
            notification_prefix,
            "};"
          )
        );

        notification_manager_send(
          &network_host->notification_manager,
          notification,
          network_host_notification_type_default
        );

        clic3_memory_free_raw(
          notification_prefix
        );

        clic3_memory_free_raw(
          notification
        );

        break;
      }
      case network_command_data_map_loaded: {
        network_host_client->status_game = (
          network_client_status_game_loaded
        );

        char* notification_prefix = (
          clic3_char_arrays_concatenate(
            "network_host_client::load_complete->{",
            network_host_client->char_array_index
          )
        );

        char* notification = (
          clic3_char_arrays_concatenate(
            notification_prefix,
            "};"
          )
        );

        notification_manager_send(
          &network_host->notification_manager,
          notification,
          network_host_notification_type_default
        );

        clic3_memory_free_raw(
          notification_prefix
        );

        clic3_memory_free_raw(
          notification
        );

        break;
      }
      case network_command_data_map: {
        network_host_client->status_game = (
          network_client_status_game_loading
        );

        char* notification_prefix = (
          clic3_char_arrays_concatenate(
            "network_host_client::requested_data_map->{",
            network_host_client->char_array_index
          )
        );

        char* notification = (
          clic3_char_arrays_concatenate(
            notification_prefix,
            "};"
          )
        );

        notification_manager_send(
          &network_host->notification_manager,
          notification,
          network_host_notification_type_default
        );

        clic3_memory_free_raw(
          notification_prefix
        );

        clic3_memory_free_raw(
          notification
        );

        break;
      }
      case network_command_poll: {
        pthread_mutex_lock(
          &network_host_client->mutex_position
        );

        unsigned long int length_data_received_client_expected = (
          1 + // network command byte
          data_length_math_c_vector3_float +
          data_length_unsigned_int
        );

        if (
          length_data_received_client >=
          length_data_received_client_expected
        ) {
          network_data_packet_read(
            &network_data_packet,
            &network_host_client->position,
            data_length_math_c_vector3_float
          );

          unsigned int length_shots_fired = 0;

          network_data_packet_read(
            &network_data_packet,
            &length_shots_fired,
            data_length_unsigned_int
          );

          length_data_received_client_expected = (
            length_data_received_client_expected +
            length_shots_fired * (
              data_length_network_data_shot_fired
            )
          );

          if (
            length_data_received_client ==
            length_data_received_client_expected
          ) {
            pthread_mutex_lock(
              &network_host_client->mutex_shots_fired
            );

            unsigned int index_shot_fired = (
              network_host_client->length_shots_fired
            );

            network_host_client_shots_fired_add(
              network_host_client,
              length_shots_fired
            );

            for (
              ;
              index_shot_fired < network_host_client->length_shots_fired;
              ++index_shot_fired
            ) {
              struct network_data_shot_fired* network_data_shot_fired = &(
                network_host_client->shots_fired[
                  index_shot_fired
                ]
              );

              network_data_packet_read(
                &network_data_packet,
                network_data_shot_fired,
                data_length_network_data_shot_fired
              );
            }

            pthread_mutex_unlock(
              &network_host_client->mutex_shots_fired
            );
          }
        }

        pthread_mutex_unlock(
          &network_host_client->mutex_position
        );

        break;
      }
      case network_command_no_operation:
      default: {
        break;
      }
    }

    network_data_packet_destroy(
      &network_data_packet
    );
  }

  network_host_client->status_game = (
    network_client_status_game_disconnected
  );

  network_host_client->status = (
    network_client_status_disconnected
  );

  network_host->connected_players = (
    network_host->connected_players -
    1
  );

  char* notification_prefix = (
    clic3_char_arrays_concatenate(
      "network_host_client::disconnected->{",
      network_host_client->char_array_index
    )
  );

  char* notification = (
    clic3_char_arrays_concatenate(
      notification_prefix,
      "};"
    )
  );

  notification_manager_send(
    &network_host->notification_manager,
    notification,
    network_host_notification_type_default
  );

  clic3_memory_free_raw(
    notification_prefix
  );

  clic3_memory_free_raw(
    notification
  );

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

  struct network_host_client* network_host_client = (
    network_host_client_thread_data->network_host_client
  );

  while (
    network_host->online == 1 &&
    (
      network_host_client->status & (
        network_client_status_disconnected |
        network_client_status_disconnecting
      )
    ) == 0
  ) {
    pthread_mutex_lock(
      &network_host_client->mutex_sending
    );

    if (
      (
        network_host->online == 0 && 
        network_host_client->command_sending != network_command_disconnecting
      ) ||
      (
        network_host_client->status & (
          network_client_status_disconnected |
          network_client_status_disconnecting
        )
      ) != 0
    ) {
      pthread_mutex_unlock(
        &network_host_client->mutex
      );

      break;
    }

    switch(
      network_host_client->command_sending
    ) {
      case network_command_disconnecting: {
        network_host_client->status = (
          network_client_status_disconnecting
        );

        struct network_data_packet network_data_packet_disconnecting;

        network_data_packet_initialize(
          &network_data_packet_disconnecting,
          network_command_disconnecting,
          0
        );

        network_data_packet_send(
          &network_data_packet_disconnecting,
          network_host_client->socket
        );

        network_data_packet_destroy(
          &network_data_packet_disconnecting
        );

        close(
          network_host_client->socket
        );
        
        break;
      }
      case network_command_data_map: {
        long int length_bytes_sent = (
          network_data_packet_send(
            network_host->data_map.packet,
            network_host_client->socket
          )
        );
        
        if (
          length_bytes_sent != network_host->data_map.packet->length
        ) {
          network_host_client->status = (
            network_client_status_disconnected
          );
        }

        break;
      }
      case network_command_no_operation:
      default: {
        break;
      }
    }

    pthread_mutex_unlock(
      &network_host_client->mutex
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
  struct network_host_client* network_host_client = (
    network_host->clients[
      index_client
    ]
  );

  pthread_mutex_lock(
    &network_host_client->mutex
  );

  network_host_client->status_game = (
    network_client_status_game_loading
  );

  network_host_client->command_sending = (
    network_command_data_map
  );

  pthread_mutex_unlock(
    &network_host_client->mutex_sending
  );
}

void network_host_data_map_send(
  struct network_host* network_host
) {
  pthread_mutex_lock(
    &network_host->mutex_thread
  );

  pthread_mutex_lock(
    &network_host->data_map.mutex
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
    &network_host->data_map.mutex
  );

  pthread_mutex_unlock(
    &network_host->mutex_thread
  );
}

void network_host_send_poll(
  struct network_host* network_host
) {
  pthread_mutex_lock(
    &network_host->mutex_thread
  );

  pthread_mutex_lock(
    &network_host->mutex_position
  );

  struct network_data_packet network_data_packet;

  network_data_packet_initialize(
    &network_data_packet,
    network_command_poll,
    (
      sizeof(
        unsigned int
      ) *
      2 +
      sizeof(
        struct math_c_vector3_float 
      ) *
      (
        network_host->connected_players +
        1
      )
    )
  );

  unsigned int index = (
    network_host->connected_players +
    1
  );

  network_data_packet_bytes_add(
    &network_data_packet,
    &index,
    data_length_unsigned_int
  );

  network_data_packet_bytes_add(
    &network_data_packet,
    &index,
    data_length_unsigned_int
  );

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    struct network_host_client* network_host_client = (
      network_host->clients[
        index_client
      ]
    );

    if (
      network_host_client->status &
      network_client_status_connected
    ) {
      pthread_mutex_lock(
        &network_host_client->mutex_position
      );

      network_data_packet_bytes_add(
        &network_data_packet,
        &network_host_client->position,
        data_length_math_c_vector3_float
      );

      pthread_mutex_unlock(
        &network_host_client->mutex_position
      );
    }
  }

  network_data_packet_bytes_add(
    &network_data_packet,
    &network_host->position,
    data_length_math_c_vector3_float
  );

  pthread_mutex_unlock(
    &network_host->mutex_position
  );

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    
    struct network_host_client* network_host_client = (
      network_host->clients[
        index_client
      ]
    );

    if (
      network_host_client->status &
      network_client_status_connected
    ) {
      clic3_bytes_copy(
        (
          network_data_packet.bytes +
          1
        ),
        &index_client,
        data_length_unsigned_int
      );

      network_data_packet_send(
        &network_data_packet,
        network_host_client->socket
      );
    }
  }

  network_data_packet_destroy(
    &network_data_packet
  );

  pthread_mutex_unlock(
    &network_host->mutex_thread
  );
}

void network_host_connections_accept(
  struct network_host* network_host
) {
  network_host->connections_accept = 1;

  notification_manager_send(
    &network_host->notification_manager,
    "network_host::accepting_connections",
    network_host_notification_type_default
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

  notification_manager_send(
    &network_host->notification_manager,
    "network_host::going_offline",
    network_host_notification_type_default
  );

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    struct network_host_client* network_host_client = (
      network_host->clients[
        index_client
      ]
    );

    if (
      (
        network_host_client->status &
        network_client_status_connected
      ) == 0
    ) {
      continue;
    }

    network_host_client->command_sending = (
      network_command_disconnecting
    );

    pthread_mutex_lock(
      &network_host_client->mutex
    );

    pthread_mutex_unlock(
      &network_host_client->mutex_sending
    );
  }

  for (
    unsigned int index_client = 0;
    index_client < network_host->length_clients;
    ++index_client
  ) {
    struct network_host_client* network_host_client = (
      network_host->clients[
        index_client
      ]
    );

    pthread_mutex_lock(
      &network_host_client->mutex
    );

    close(
      network_host_client->socket
    );
  }

  close(
    network_host->socket
  );

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
    struct network_host_client* network_host_client = (
      network_host->clients[
        index_client
      ]
    );

    network_host_client_destroy(
      network_host_client
    );

    clic3_memory_free_raw(
      network_host_client
    );
  }

  notification_manager_destroy(
    &network_host->notification_manager
  );

  pthread_mutex_destroy(
    &network_host->mutex_thread
  );

  pthread_mutex_destroy(
    &network_host->mutex_position
  );

  pthread_mutex_destroy(
    &network_host->mutex_shots_fired
  );

  network_data_map_destroy(
    &network_host->data_map
  );

  clic3_memory_free_raw(
    network_host->clients
  );

  clic3_memory_free_raw(
    network_host->threads
  );

  clic3_memory_free_raw(
    network_host->shots_fired
  );
}
