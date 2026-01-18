#include <network/network_data_map_functions.h>

#include <data/network_data_map.h>
#include <data/parameters_gameplay.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <math_c_vector.h>

#include <metil_group.h>
#include <metil_object/metil_object.h>

#include <pthread.h>

void network_data_map_set(
  struct network_data_map* network_data_map,
  struct parameters_gameplay* parameters_gameplay,
  struct metil_group* metil_group_buildings,
  struct metil_group* metil_group_enemies,
  struct math_c_vector3_float* position_starting,
  unsigned int target_building
) {
  pthread_mutex_lock(
    &network_data_map->mutex
  );

  unsigned long int length_math_c_vector3_float = (
    sizeof(
      struct math_c_vector3_float
    )
  );

  unsigned long int length_parameters_gameplay = (
    sizeof(
      struct parameters_gameplay
    ) -
    1
  );
  
  unsigned long int length_unsigned_int = (
    sizeof(
      unsigned int
    )
  );

  unsigned long int length_bytes_buildings = (
    metil_group_buildings->length *
    length_math_c_vector3_float *
    2
  );

  unsigned long int length_bytes_enemies = (
    metil_group_enemies->length *
    length_math_c_vector3_float
  );

  network_data_map->length = (
    length_parameters_gameplay +
    length_unsigned_int +
    length_bytes_buildings +
    length_unsigned_int +
    length_bytes_enemies +
    length_math_c_vector3_float +
    length_unsigned_int
  );

  clic3_memory_reallocate_raw(
    &network_data_map->bytes,
    network_data_map->length
  );

  unsigned long int offset_bytes = 0;

  clic3_bytes_copy(
    network_data_map->bytes,
    parameters_gameplay,
    length_parameters_gameplay
  );

  offset_bytes = (
    offset_bytes +
    length_parameters_gameplay
  );

  clic3_bytes_copy(
    network_data_map->bytes,
    &metil_group_buildings->length,
    length_parameters_gameplay
  );

  offset_bytes = (
    offset_bytes +
    length_unsigned_int
  );

  for (
    unsigned int index_building = 0;
    index_building < metil_group_buildings->length;
    ++index_building
  ) {
    struct metil_object* metil_object_building = (
      metil_group_buildings->renderables[
        index_building
      ]->renderable
    );

    clic3_bytes_copy(
      (
        network_data_map->bytes +
        offset_bytes
      ),
      &metil_object_building->position,
      length_math_c_vector3_float
    );

    offset_bytes = (
      offset_bytes +
      length_math_c_vector3_float
    );

    clic3_bytes_copy(
      (
        network_data_map->bytes +
        offset_bytes
      ),
      &metil_object_building->mesh.size,
      length_math_c_vector3_float
    );

    offset_bytes = (
      offset_bytes +
      length_math_c_vector3_float
    );
  }

  clic3_bytes_copy(
    network_data_map->bytes,
    &metil_group_enemies->length,
    length_parameters_gameplay
  );

  offset_bytes = (
    offset_bytes +
    length_unsigned_int
  );

  for (
    unsigned int index_enemy = 0;
    index_enemy < metil_group_enemies->length;
    ++index_enemy
  ) {
    struct metil_object* metil_object_enemy = (
      metil_group_enemies->renderables[
        index_enemy
      ]->renderable
    );

    clic3_bytes_copy(
      (
        network_data_map->bytes +
        offset_bytes
      ),
      &metil_object_enemy->position,
      length_math_c_vector3_float
    );

    offset_bytes = (
      offset_bytes +
      length_math_c_vector3_float
    );
  }

  clic3_bytes_copy(
    (
      network_data_map->bytes +
      offset_bytes
    ),
    position_starting,
    length_math_c_vector3_float
  );

  offset_bytes = (
    offset_bytes +
    length_math_c_vector3_float
  );

  clic3_bytes_copy(
    (
      network_data_map->bytes +
      offset_bytes
    ),
    &target_building,
    length_unsigned_int
  );

  offset_bytes = (
    offset_bytes +
    length_unsigned_int
  );

  pthread_mutex_unlock(
    &network_data_map->mutex
  );
}
