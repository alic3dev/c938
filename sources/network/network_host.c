#include <network/network_host.h>

#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <errno.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

unsigned char network_host_listen(
  struct network_host* network_host,
  unsigned int length_threads
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
      c938_network_host_port
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
    length_threads
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

  network_host->initialized = 1;

  for (
    unsigned int index_thread = 0;
    index_thread < network_host->length_threads;
    ++index_thread
  ) {
    pthread_create(
      &network_host->threads[
        index_thread
      ],
      0,
      network_host_thread,
      network_host
    );
  }

  return 0;
}

void* network_host_thread(
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
    socklen_t length_socket_client;

    int socket_client = (
      accept(
        network_host->socket,
        &address_socket_client,
        &length_socket_client
      )
    );

    char* char_array_address_client = (
      clic3_memory_allocate_raw(
        address_socket_client.sa_len +
        1
      )
    );

    for (
      unsigned char index_char_array_address_client = 0;
      index_char_array_address_client < address_socket_client.sa_len;
      ++index_char_array_address_client
    ) {
      char_array_address_client[
        index_char_array_address_client
      ] = (
        address_socket_client.sa_data[
          index_char_array_address_client
        ]
      );
    }

    char_array_address_client[
      address_socket_client.sa_len
    ] = '\0';

    if (
      socket_client < 0
    ) {
      continue;
    }

    char* notification_prefix = (
      clic3_char_arrays_concatenate(
        "client_connected->{",
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

    close(
      socket_client
    );
  }

  return 0;
}

void network_host_connections_accept(
  struct network_host* network_host
) {
  network_host->connections_accept = 1;
}

void network_host_notification_send(
  struct network_host* network_host,
  char* notification,
  enum network_host_notification_type network_host_notification_type
) {
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
}

void network_host_notification_on_add(
  struct network_host* network_host,
  network_host_notification_on notification_on,
  void* notification_on_data
) {
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
