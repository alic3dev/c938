#include <data/network_data_map.h>

#include <clic3_bytes.h>
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

void network_data_map_bytes_set(
  struct network_data_map* network_data_map,
  unsigned char* bytes,
  unsigned int length
) {
  pthread_mutex_lock(
    &network_data_map->mutex
  );

  network_data_map->length = (
    length
  );

  clic3_memory_reallocate_raw(
    &network_data_map->bytes,
    network_data_map->length
  );

  clic3_bytes_copy(
    network_data_map->bytes,
    bytes,
    network_data_map->length
  );

  pthread_mutex_unlock(
    &network_data_map->mutex
  );
}

void network_data_map_destroy(
  struct network_data_map* network_data_map
) {
  clic3_memory_free_raw(
    network_data_map->bytes
  );
}
