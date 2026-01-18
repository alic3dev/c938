#include <data/network_data_map.h>

#include <clic3_memory.h>

#include <pthread.h>

void network_data_map_initialize(
  struct network_data_map* network_data_map
) {
  network_data_map->bytes = (
    clic3_memory_allocate_raw(
      0
    )
  );

  network_data_map->length = 0;

  pthread_mutex_init(
    &network_data_map->mutex,
    0
  );
}

void network_data_map_destroy(
  struct network_data_map* network_data_map
) {
  clic3_memory_free_raw(
    network_data_map->bytes
  );
}
