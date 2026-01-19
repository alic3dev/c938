#include <network/data/network_data_packet.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <sys/socket.h>

void network_data_packet_initialize(
  struct network_data_packet* network_data_packet,
  enum network_command network_command,
  unsigned int length
) {
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

unsigned char network_data_packet_bytes_add(
  struct network_data_packet* network_data_packet,
  void* bytes,
  unsigned int length
) {
  if (
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
