#include <network/data/network_data_map_functions.h>

#include <rendering/c938_pipeline_index.h>
#include <data/data_length.h>
#include <data/enemy_data.h>
#include <network/data/network_data_map.h>
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

  unsigned long int length_bytes_buildings = (
    metil_group_buildings->length *
    data_length_math_c_vector3_float *
    2
  );

  unsigned long int length_bytes_enemies = (
    (
      metil_group_enemies->length *
      data_length_math_c_vector3_float
    ) + (
      metil_group_enemies->length *
      data_length_float
    )
  );

  unsigned int length = (
    data_length_parameters_gameplay +  // gameplay parameters
    data_length_unsigned_int +         // length of buildings
    length_bytes_buildings +           // building positions + sizes
    data_length_unsigned_int +         // length of enemies
    length_bytes_enemies +             // enemy positions + speeds
    data_length_math_c_vector3_float + // starting position
    data_length_unsigned_int           // target building index
  );

  struct network_data_packet* network_data_packet = (
    network_data_map->packet
  );

  network_data_packet_reallocate(
    network_data_packet,
    length
  );

  network_data_packet_bytes_add(
    network_data_packet,
    parameters_gameplay,
    data_length_parameters_gameplay
  );

  network_data_packet_bytes_add(
    network_data_packet,
    &metil_group_buildings->length,
    data_length_unsigned_int
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

    network_data_packet_bytes_add(
      network_data_packet,
      &metil_object_building->position,
      data_length_math_c_vector3_float
    );

    network_data_packet_bytes_add(
      network_data_packet,
      &metil_object_building->mesh.size,
      data_length_math_c_vector3_float
    );
  }

  network_data_packet_bytes_add(
    network_data_packet,
    &metil_group_enemies->length,
    data_length_unsigned_int
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

    struct enemy_data* enemy_data = (
      metil_object_enemy->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    network_data_packet_bytes_add(
      network_data_packet,
      &metil_object_enemy->position,
      data_length_math_c_vector3_float
    );

    network_data_packet_bytes_add(
      network_data_packet,
      &enemy_data->speed,
      data_length_float
    );
  }

  network_data_packet_bytes_add(
    network_data_packet,
    position_starting,
    data_length_math_c_vector3_float
  );

  network_data_packet_bytes_add(
    network_data_packet,
    &target_building,
    data_length_unsigned_int
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

  struct network_data_packet* network_data_packet = (
    network_data_map->packet
  );

  network_data_packet_read(
    network_data_packet,
    parameters_gameplay,
    data_length_parameters_gameplay
  );

  unsigned int length_buildings;
  unsigned int length_enemies;

  network_data_packet_read(
    network_data_packet,
    &length_buildings,
    data_length_unsigned_int
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

    network_data_packet_read(
      network_data_packet,
      &metil_object_building->position,
      data_length_math_c_vector3_float
    );

    network_data_packet_read(
      network_data_packet,
      &size_building,
      data_length_math_c_vector3_float
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

    metil_object_building->type_primitive = (
      MTLPrimitiveTypeLine
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

    metil_object_building_data->colour.x = 1.0f;
    metil_object_building_data->colour.y = 1.0f;
    metil_object_building_data->colour.z = 1.0f;
    metil_object_building_data->colour.w = 1.0f;
  }

  network_data_packet_read(
    network_data_packet,
    &length_enemies,
    data_length_unsigned_int
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

    network_data_packet_read(
      network_data_packet,
      &position_enemy,
      data_length_math_c_vector3_float
    );

    network_data_packet_read(
      network_data_packet,
      &speed_enemy,
      data_length_float
    );

    object_enemy_initialize(
      metil_object_enemy,
      metil->renderer_interface.metal_device,
      position_enemy,
      4,
      speed_enemy
    );
  }

  network_data_packet_read(
    network_data_packet,
    position_starting,
    data_length_math_c_vector3_float
  );

  network_data_packet_read(
    network_data_packet,
    target_building,
    data_length_unsigned_int
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

    metil_object_building_data->colour.x = 0.0f;
    metil_object_building_data->colour.y = 0.0f;
    metil_object_building_data->colour.z = 1.0f;
    metil_object_building_data->colour.w = 1.0f;
  }

  pthread_mutex_unlock(
    &network_data_map->mutex
  );
}
