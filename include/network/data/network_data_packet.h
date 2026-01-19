#ifndef __network_data_network_data_packet_h
#define __network_data_network_data_packet_h

#include <network/network_command.h>

struct network_data_packet {
  enum network_command command;

  unsigned int length;
  void* bytes;

  unsigned int offset;
  unsigned char filled;
};

void network_data_packet_initialize(
  struct network_data_packet*,
  enum network_command,
  unsigned int
);

void network_data_packet_initialize_from_bytes(
  struct network_data_packet*,
  void*,
  unsigned int
);

void network_data_packet_reallocate(
  struct network_data_packet*,
  unsigned int
);

unsigned char network_data_packet_bytes_add(
  struct network_data_packet*,
  void*,
  unsigned int
);

long int network_data_packet_send(
  struct network_data_packet*,
  int
);

unsigned char network_data_packet_read(
  struct network_data_packet*,
  void*,
  unsigned int
);

void network_data_packet_destroy(
  struct network_data_packet*
);

#endif
