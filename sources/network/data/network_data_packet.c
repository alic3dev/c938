#include <network/data/network_data_packet.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <sys/socket.h>

void network_data_packet_initialize(
  struct network_data_packet* network_data_packet,
  enum network_command network_command,
  unsigned int length
) {
  network_data_packet->command = (
    network_command
  );

  network_data_packet->length = (
    length +
    1
  );

  network_data_packet->bytes = (
    clic3_memory_allocate_raw(
      network_data_packet->length
    )
  );

  (
    (unsigned char*)
    network_data_packet->bytes
  )[0] = (
    network_command
  );

  network_data_packet->offset = (
    1
  );

  network_data_packet->filled = (
    length == 0
    ? 1
    : 0
  );
}

void network_data_packet_initialize_from_bytes(
  struct network_data_packet* network_data_packet,
  void* data,
  unsigned int length
) {
  if (
    length == 0
  ) {
    network_data_packet_initialize(
      network_data_packet,
      network_command_unknown,
      0
    );

    return;
  }

  enum network_command network_command = (
    (
      (unsigned char*)
      data
    )[
      0
    ]
  );

  if (
    network_command > network_command_maximum
  ) {
    network_command = (
      network_command_unknown
    );
  }

  network_data_packet_initialize(
    network_data_packet,
    network_command,
    (
      length -
      // minus the network_command byte
      1
    )
  );

  network_data_packet_bytes_add(
    network_data_packet,
    // again, adding a 1 byte offset to the data and subtracting 1 byte from length to account for `network_command`
    (
      data +
      1
    ),
    (
      length -
      1
    )
  );
}

void network_data_packet_reallocate(
  struct network_data_packet* network_data_packet,
  unsigned int length
) {
  clic3_memory_free_raw(
    network_data_packet->bytes
  );

  network_data_packet_initialize(
    network_data_packet,
    network_data_packet->command,
    length
  );
}

unsigned char network_data_packet_bytes_add(
  struct network_data_packet* network_data_packet,
  void* bytes,
  unsigned int length
) {
  if (
    network_data_packet->filled == 1 ||
    (
      network_data_packet->offset +
      length
    ) >
    network_data_packet->length
  ) {
    return 1;
  }

  clic3_bytes_copy(
    (
      network_data_packet->bytes +
      network_data_packet->offset
    ),
    bytes,
    length
  );

  network_data_packet->offset = (
    network_data_packet->offset +
    length
  );

  network_data_packet->filled = (
    (
      network_data_packet->offset ==
      network_data_packet->length
    )
    ? 1
    : 0
  );

  return 0;
}
#include <stdio.h>
unsigned char network_data_packet_read(
  struct network_data_packet* network_data_packet,
  void* to,
  unsigned int length
) {
  if (
    network_data_packet->offset ==
    network_data_packet->length
  ) {
    network_data_packet->offset = 0;
  }

  if (
    (
      network_data_packet->offset +
      length
    ) > network_data_packet->length
  ) {
    return 2;
  }

  clic3_bytes_copy(
    to,
    (
      network_data_packet->bytes +
      network_data_packet->offset
    ),
    length
  );

  for (
    unsigned int i = 0; i < length; ++i
  ) {
    printf("%.2x ", ((unsigned char*) network_data_packet->bytes)[i]);
  }

  network_data_packet->offset = (
    network_data_packet->offset +
    length
  );

  if (
    network_data_packet->offset ==
    network_data_packet->length
  ) {
    return 1;
  }

  return 0;
}

long int network_data_packet_send(
  struct network_data_packet* network_data_packet,
  int socket
) {
  long int length_bytes_sent = (
    send(
      socket,
      network_data_packet->bytes,
      network_data_packet->length,
      0
    )
  );

  return (
    length_bytes_sent
  );
}

void network_data_packet_destroy(
  struct network_data_packet* network_data_packet
) {
  clic3_memory_free_raw(
    network_data_packet->bytes
  );
}
