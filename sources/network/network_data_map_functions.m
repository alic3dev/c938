#include <network/network_data_map_functions.h>

#include <c938_pipeline_index.h>
#include <data/enemy_data.h>
#include <data/network_data_map.h>
#include <data/parameters_gameplay.h>
#include <mesh/mesh_building.h>
#include <network/network.h>
#include <objects/object_enemy.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <Metal/MTLTexture.h>

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

  unsigned long int length_float = (
    sizeof(
      float
    )
  );

  unsigned long int length_bytes_buildings = (
    metil_group_buildings->length *
    length_math_c_vector3_float *
    2
  );

  unsigned long int length_bytes_enemies = (
    (
      metil_group_enemies->length *
      length_math_c_vector3_float
    ) + (
      metil_group_enemies->length *
      length_float
    )
  );

  network_data_map->length = (
    1 +
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

  unsigned long int offset_bytes = 1;

  network_data_map->bytes[0] = (
    network_command_datamap
  );

  clic3_bytes_copy(
    (
      network_data_map->bytes +
      offset_bytes
    ),
    parameters_gameplay,
    length_parameters_gameplay
  );

  offset_bytes = (
    offset_bytes +
    length_parameters_gameplay
  );

  clic3_bytes_copy(
    (
      network_data_map->bytes +
      offset_bytes
    ),
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
    (
      network_data_map->bytes +
      offset_bytes
    ),
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

    struct enemy_data* enemy_data = (
      metil_object_enemy->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    clic3_bytes_copy(
      (
        network_data_map->bytes +
        offset_bytes
      ),
      &enemy_data->speed,
      length_float
    );

    offset_bytes = (
      offset_bytes +
      length_float
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

void network_data_map_parse(
  struct metil* metil,
  struct network_data_map* network_data_map,
  struct parameters_gameplay* parameters_gameplay,
  struct metil_group* metil_group_buildings,
  struct metil_group* metil_group_enemies,
  struct math_c_vector3_float* position_starting,
  unsigned int* target_building,
  id<MTLTexture> texture_building
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

  unsigned long int length_float = (
    sizeof(
      float
    )
  );

  metil_group_destroy(
    metil,
    metil_group_buildings
  );

  metil_group_destroy(
    metil,
    metil_group_enemies
  );

  metil_group_initialize(
    metil_group_buildings
  );

  metil_group_initialize(
    metil_group_enemies
  );

  unsigned long int offset_bytes = 1;

  clic3_bytes_copy(
    parameters_gameplay,
    (
      network_data_map->bytes +
      offset_bytes
    ),
    length_parameters_gameplay
  );

  offset_bytes = (
    offset_bytes +
    length_parameters_gameplay
  );

  unsigned int length_buildings;
  unsigned int length_enemies;

  clic3_bytes_copy(
    &length_buildings,
    (
      network_data_map->bytes +
      offset_bytes
    ),
    length_unsigned_int
  );

  offset_bytes = (
    offset_bytes +
    length_unsigned_int
  );

  metil_group_add_length_initialize(
    metil_group_buildings,
    length_buildings,
    metil_renderable_type_object
  );

  for (
    unsigned int index_building = 0;
    index_building < length_buildings;
    ++index_building
  ) {
    struct metil_object* metil_object_building = (
      metil_group_buildings->renderables[
        index_building
      ]->renderable
    );

    struct math_c_vector3_float size_building;

    clic3_bytes_copy(
      &metil_object_building->position,
      (
        network_data_map->bytes +
        offset_bytes
      ),
      length_math_c_vector3_float
    );

    offset_bytes = (
      offset_bytes +
      length_math_c_vector3_float
    );

    clic3_bytes_copy(
      &size_building,
      (
        network_data_map->bytes +
        offset_bytes
      ),
      length_math_c_vector3_float
    );

    offset_bytes = (
      offset_bytes +
      length_math_c_vector3_float
    );

    metil_object_building->index_pipeline_render = (
      c938_pipeline_index_building
    );

    mesh_building_initialize(
      &metil_object_building->mesh,
      size_building.x,
      size_building.y,
      size_building.z
    );

    metil_object_texture_add(
      metil_object_building,
      texture_building
    );

    metil_object_buffers_initialize(
      metil_object_building,
      metil->renderer_interface.metal_device
    );

    struct metil_renderer_data_object* metil_object_building_data = (
      metil_object_building->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );
    
    metil_object_building_data->color.x = 1.0f;
    metil_object_building_data->color.y = 1.0f;
    metil_object_building_data->color.z = 1.0f;
    metil_object_building_data->color.w = 1.0f;
  }

  clic3_bytes_copy(
    &length_enemies,
    (
      network_data_map->bytes +
      offset_bytes
    ),
    length_unsigned_int
  );

  offset_bytes = (
    offset_bytes +
    length_unsigned_int
  );

  metil_group_add_length_initialize(
    metil_group_enemies,
    length_enemies,
    metil_renderable_type_object
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

    struct math_c_vector3_float position_enemy;
    float speed_enemy;

    clic3_bytes_copy(
      &position_enemy,
      (
        network_data_map->bytes +
        offset_bytes
      ),
      length_math_c_vector3_float
    );

    offset_bytes = (
      offset_bytes +
      length_math_c_vector3_float
    );

    clic3_bytes_copy(
      &speed_enemy,
      (
        network_data_map->bytes +
        offset_bytes
      ),
      length_float
    );

    offset_bytes = (
      offset_bytes +
      length_float
    );

    object_enemy_initialize(
      metil_object_enemy,
      metil->renderer_interface.metal_device,
      position_enemy,
      4,
      speed_enemy
    );
  }

  clic3_bytes_copy(
    position_starting,
    (
      network_data_map->bytes +
      offset_bytes
    ),
    length_math_c_vector3_float
  );

  offset_bytes = (
    offset_bytes +
    length_math_c_vector3_float
  );

  clic3_bytes_copy(
    target_building,
    (
      network_data_map->bytes +
      offset_bytes
    ),
    length_unsigned_int
  );

  offset_bytes = (
    offset_bytes +
    length_unsigned_int
  );

  if (
    *target_building < metil_group_buildings->length
  ) {
    struct metil_object* metil_object_building = (
      metil_group_buildings->renderables[
        *target_building
      ]->renderable
    );

    struct metil_renderer_data_object* metil_object_building_data = (
      metil_object_building->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_object_building_data->color.x = 0.0f;
    metil_object_building_data->color.y = 0.0f;
    metil_object_building_data->color.z = 1.0f;
    metil_object_building_data->color.w = 1.0f;
  }

  pthread_mutex_unlock(
    &network_data_map->mutex
  );
}
