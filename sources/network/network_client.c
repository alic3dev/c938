#include <network/network_client.h>

#include <network/data/network_data_map.h>
#include <network/network.h>
#include <notification/notification_manager.h>

#include <clic3_memory.h>

#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

unsigned char network_client_connect(
  struct network_client* network_client
) {
  return (
    network_client_connect_with_notification(
      network_client,
      0,
      0
    )
  );
}

unsigned char network_client_connect_with_notification(
  struct network_client* network_client,
  notification_manager_notification_on notification_on,
  void* notification_on_data
) {
  network_client->status = (
    network_client_status_initializing
  );

  network_client->status_game = (
    network_client_status_game_loading
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
    network_client->status = (
      network_client_status_disconnected
    );

    network_client->status_game = (
      network_client_status_game_disconnected
    );

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

    network_client->status = (
      network_client_status_disconnected
    );

    return 2;
  }

  network_data_map_initialize(
    &network_client->data_map
  );

  network_client->network_data_packet_enemies = 0;
  network_client->network_data_packet_poll = 0;

  network_client->status = (
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

  pthread_mutex_init(
    &network_client->mutex_network_data_packets_outgoing,
    0
  );

  pthread_mutex_init(
    &network_client->mutex_thread_sending,
    0
  );

  pthread_mutex_init(
    &network_client->mutex_enemies,
    0
  );

  pthread_mutex_init(
    &network_client->mutex_poll,
    0
  );

  pthread_mutex_init(
    &network_client->mutex_shots_fired,
    0
  );

  pthread_mutex_lock(
    &network_client->mutex_sending
  );

  pthread_mutex_lock(
    &network_client->mutex_thread_sending
  );

  network_client->network_data_packets_outgoing = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_client->length_network_data_packets_outgoing = (
    0
  );

  network_client->shots_fired = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_client->length_shots_fired = 0;

  network_client->connected_players = 0;

  notification_manager_initialize(
    &network_client->notification_manager
  );

  if (
    notification_on != 0
  ) {
    notification_manager_notification_on_add(
      &network_client->notification_manager,
      notification_on,
      notification_on_data
    );
  }

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
    (
      network_client->status & (
        network_client_status_disconnecting |
        network_client_status_disconnected
      )
    ) == 0
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

    static struct network_data_packet* network_data_packet;
    
    network_data_packet = (
      clic3_memory_allocate_raw(
        sizeof(
          struct network_data_packet
        )
      )
    );

    network_data_packet_initialize_from_bytes(
      network_data_packet,
      data_host,
      length_data_received
    );

    switch (
      network_data_packet->command
    ) {
      case network_command_disconnecting: {
        notification_manager_send(
          &network_client->notification_manager,
          "network_client::host::going_offline",
          network_client_notification_type_error
        );

        network_client->status = (
          network_client_status_disconnecting
        );

        network_client->status_game = (
          network_client_status_game_disconnected
        );

        network_data_packet_destroy(
          network_data_packet
        );

        clic3_memory_free_raw(
          network_data_packet
        );

        break;
      }
      case network_command_data_map: {
        network_data_map_packet_set(
          &network_client->data_map,
          network_data_packet
        );

        notification_manager_send(
          &network_client->notification_manager,
          "network_client::received_data_map",
          network_client_notification_type_data_map_sent
        );

        break;
      }
      case network_command_enemies: {
        pthread_mutex_lock(
          &network_client->mutex_enemies
        );

        if (
          network_client->network_data_packet_enemies != 0
        ) {
          network_data_packet_destroy(
            network_client->network_data_packet_enemies
          );

          clic3_memory_free_raw(
            network_client->network_data_packet_enemies
          );
        }

        network_client->network_data_packet_enemies = (
          network_data_packet
        );

        pthread_mutex_unlock(
          &network_client->mutex_enemies
        );

        notification_manager_send(
          &network_client->notification_manager,
          "network_client::enemies",
          network_client_notification_type_enemies
        );
        break;
      }
      case network_command_poll: {
        pthread_mutex_lock(
          &network_client->mutex_poll
        );

        if (
          network_client->network_data_packet_poll != 0
        ) {
          network_data_packet_destroy(
            network_client->network_data_packet_poll
          );

          clic3_memory_free_raw(
            network_client->network_data_packet_poll
          );
        }

        network_client->network_data_packet_poll = (
          network_data_packet
        );

        pthread_mutex_unlock(
          &network_client->mutex_poll
        );

        notification_manager_send(
          &network_client->notification_manager,
          "network_client::poll",
          network_client_notification_type_poll
        );
        break;
      }
      case network_command_initialize:
      case network_command_no_operation:
      default: {
        network_data_packet_destroy(
          network_data_packet
        );

        clic3_memory_free_raw(
          network_data_packet
        );

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

  while (
    (
      network_client->status & (
        network_client_status_disconnecting |
        network_client_status_disconnected
      )
    ) == 0
  ) {
    pthread_mutex_lock(
      &network_client->mutex_sending
    );

    unsigned int index_network_data_packet_outgoing = 0;

    for (
      ;
      (
        index_network_data_packet_outgoing <
        network_client->length_network_data_packets_outgoing
      );
      ++index_network_data_packet_outgoing
    ) {
      pthread_mutex_lock(
        &network_client->mutex_network_data_packets_outgoing
      );

      struct network_data_packet* network_data_packet_outgoing = (
        network_client->network_data_packets_outgoing[
          index_network_data_packet_outgoing
        ]
      );

      pthread_mutex_unlock(
        &network_client->mutex_network_data_packets_outgoing
      );

      switch (
        network_data_packet_outgoing->command
      ) {
        case network_command_data_map_loaded: {
          network_client->status_game = (
            network_client_status_game_loaded
          );

          break;
        }
        case network_command_disconnecting: {
          network_client->status = (
            network_client_status_disconnecting
          );

          break;
        }
        case network_command_no_operation:
        default: {
          break;
        }
      }

      if (
        (
          network_client->status &
          network_client_status_disconnected
        ) == 0
      ) {
        network_data_packet_send(
          network_data_packet_outgoing,
          network_client->socket
        );
      }

      network_data_packet_destroy(
        network_data_packet_outgoing
      );

      clic3_memory_free_raw(
        network_data_packet_outgoing
      );
    }

    pthread_mutex_lock(
      &network_client->mutex_network_data_packets_outgoing
    );

    network_client->length_network_data_packets_outgoing = (
      network_client->length_network_data_packets_outgoing -
      index_network_data_packet_outgoing
    );

    clic3_memory_reallocate_raw(
      &network_client->network_data_packets_outgoing,
      (
        sizeof(
          void*
        ) *
        network_client->length_network_data_packets_outgoing
      )
    );

    pthread_mutex_unlock(
      &network_client->mutex_network_data_packets_outgoing
    );
  }

  notification_manager_send(
    &network_client->notification_manager,
    "network_client::disconnected",
    network_client_notification_type_error
  );

  network_client->status = (
    network_client_status_disconnected
  );

  network_client->status_game = (
    network_client_status_game_disconnected
  );

  pthread_mutex_unlock(
    &network_client->mutex_thread_sending
  );
  
  clic3_memory_free(
    network_client_thread_data
  );

  return 0;
}

void network_client_send(
  struct network_client* network_client,
  struct network_data_packet* network_data_packet
) {
  pthread_mutex_lock(
    &network_client->mutex_network_data_packets_outgoing
  );

  network_client->length_network_data_packets_outgoing = (
    network_client->length_network_data_packets_outgoing +
    1
  );

  clic3_memory_reallocate_raw(
    &network_client->network_data_packets_outgoing,
    (
      sizeof(
        void*
      ) *
      network_client->length_network_data_packets_outgoing
    )
  );

  network_client->network_data_packets_outgoing[
    network_client->length_network_data_packets_outgoing -
    1
  ] = (
    network_data_packet
  );

  pthread_mutex_unlock(
    &network_client->mutex_network_data_packets_outgoing
  );

  pthread_mutex_unlock(
    &network_client->mutex_sending
  );
}

void network_client_destroy(
  struct network_client* network_client
) {
  if (
    network_client->status ==
    network_client_status_none
  ) {
    return;
  }

  network_client->status = (
    network_client_status_disconnecting
  );

  network_client->status_game = (
    network_client_status_game_disconnected
  );

  static struct network_data_packet* network_data_packet_outgoing;

  network_data_packet_outgoing = (
    clic3_memory_allocate_raw(
      sizeof(
        struct network_data_packet
      )
    )
  );

  network_data_packet_initialize(
    network_data_packet_outgoing,
    network_command_disconnecting,
    0
  );

  network_client_send(
    network_client,
    network_data_packet_outgoing
  );

  pthread_mutex_lock(
    &network_client->mutex_thread_sending
  );

  pthread_mutex_unlock(
    &network_client->mutex_network_data_packets_outgoing
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

  pthread_mutex_destroy(
    &network_client->mutex_thread_sending
  );

  pthread_mutex_destroy(
    &network_client->mutex_network_data_packets_outgoing
  );

  pthread_mutex_destroy(
    &network_client->mutex_enemies
  );

  pthread_mutex_destroy(
    &network_client->mutex_poll
  );

  network_data_map_destroy(
    &network_client->data_map
  );

  pthread_mutex_destroy(
    &network_client->mutex_shots_fired
  );

  if (
    network_client->network_data_packet_poll != 0
  ) {
    network_data_packet_destroy(
      network_client->network_data_packet_poll
    );

    clic3_memory_free_raw(
      network_client->network_data_packet_poll
    );
  }

  if (
    network_client->network_data_packet_enemies != 0
  ) {
    network_data_packet_destroy(
      network_client->network_data_packet_enemies
    );

    clic3_memory_free_raw(
      network_client->network_data_packet_enemies
    );
  }

  for (
    unsigned int index_network_data_packet_outgoing = 0;
    index_network_data_packet_outgoing < network_client->length_network_data_packets_outgoing;
    ++index_network_data_packet_outgoing
  ) {
    struct network_data_packet* network_data_packet_outgoing = (
      network_client->network_data_packets_outgoing[
        index_network_data_packet_outgoing
      ]
    );

    network_data_packet_destroy(
      network_data_packet_outgoing
    );

    clic3_memory_free_raw(
      network_data_packet_outgoing
    );
  }

  clic3_memory_free_raw(
    network_client->network_data_packets_outgoing
  );
  
  clic3_memory_free_raw(
    network_client->shots_fired
  );
}
