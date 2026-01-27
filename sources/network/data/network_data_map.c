#include <network/data/network_data_map.h>

#include <network/data/network_data_packet.h>
#include <network/network_command.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <pthread.h>

void network_data_map_initialize(
  struct network_data_map* network_data_map
) {
  network_data_map->packet = (
    clic3_memory_allocate_raw(
      sizeof(
        struct network_data_packet
      )
    )
  );

  network_data_packet_initialize(
    network_data_map->packet,
    network_command_data_map,
    0
  );

  pthread_mutex_init(
    &network_data_map->mutex,
    0
  );
}

void network_data_map_packet_set(
  struct network_data_map* network_data_map,
  struct network_data_packet* network_data_packet
) {
  pthread_mutex_lock(
    &network_data_map->mutex
  );

  clic3_memory_free_raw(
    network_data_map->packet
  );

  network_data_map->packet = (
    network_data_packet
  );
  
  pthread_mutex_unlock(
    &network_data_map->mutex
  );
}

void network_data_map_destroy(
  struct network_data_map* network_data_map
) {
  pthread_mutex_lock(
    &network_data_map->mutex
  );

  pthread_mutex_destroy(
    &network_data_map->mutex
  );

  network_data_packet_destroy(
    network_data_map->packet
  );

  clic3_memory_free_raw(
    network_data_map->packet
  );
}
