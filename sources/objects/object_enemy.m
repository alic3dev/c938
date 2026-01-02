#include <objects/object_enemy.h>

#include <mesh/mesh_enemy.h>
#include <pipeline_index.h>
#include <data/enemy_data.h>

#include <clic3_vector.h>

#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

void object_enemy_initialize(
  struct metil_object* object,
  id<MTLDevice> metal_device,
  struct clic3_vector3_float position,
  unsigned char life
) {
  mesh_enemy_initialize(
    &object->mesh
  );

  object->poll = object_enemy_poll;

  object->index_pipeline_render = (
    c938_pipeline_index_enemy
  );

  metil_object_buffers_initialize_with_data_size(
    object,
    metal_device,
    sizeof(struct enemy_data)
  );

  object->position.x = position.x;
  object->position.y = position.y;
  object->position.z = position.z;

  object->rotation.x = 0.0f;
  object->rotation.y = 0.0f;
  object->rotation.z = 0.0f;

  struct enemy_data* enemy_data = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  enemy_data->color.x = 1.0f;
  enemy_data->color.y = 1.0f;
  enemy_data->color.z = 1.0f;

  enemy_data->life_maximum = life;
  enemy_data->life = (
    enemy_data->life_maximum
  );
}

void object_enemy_travel(
  struct metil_object* metil_object,
  struct enemy_data* enemy_data
) {
  enemy_data->position_previous.x = metil_object->position.x;
  enemy_data->position_previous.y = metil_object->position.y;
  enemy_data->position_previous.z = metil_object->position.z;

  // float distance = (
  //   enemy_data->time_delta_percent *
  //   enemy_data->speed
  // );

  // metil_object->position.x = (
  //   metil_object->position.x +
  //   enemy_data->translation.x * distance
  // );

  // metil_object->position.y = (
  //   metil_object->position.y +
  //   enemy_data->translation.y * distance
  // );

  // metil_object->position.z = (
  //   metil_object->position.z +
  //   enemy_data->translation.z * distance
  // );
}

void object_enemy_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct enemy_data* enemy_data = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  object_enemy_travel(
    metil_object,
    enemy_data
  );

  metil_positioning_view_model_matrix_projection_set(
    metil_object->positioning,
    &enemy_data->view_model_matrix_projection,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    &metil_object->position,
    &metil_object->rotation,
    &((struct metil_scene_controller*) metil->scene_controller)->scene.player.position,
    metil_camera
  );
}
