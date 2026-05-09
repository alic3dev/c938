#include <objects/object_projectile.h>

#include <mesh/mesh_projectile.h>
#include <rendering/c938_pipeline_index.h>
#include <data/projectile_data.h>
#include <data/projectile_lifespan.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>

void object_projectile_initialize(
  struct metil_object* object,
  id<MTLDevice> metal_device,
  struct math_c_vector3_float position,
  struct math_c_vector3_float angle,
  unsigned long int time_fired,
  float speed
) {
  mesh_projectile_initialize(
    &object->mesh
  );

  object->type_primitive = (
    MTLPrimitiveTypeLineStrip
  );

  object->poll = (
    object_projectile_poll
  );

  object->index_pipeline_render = (
    c938_pipeline_index_projectile
  );

  metil_object_buffers_initialize_with_data_size(
    object,
    metal_device,
    sizeof(
      struct projectile_data
    )
  );

  object->position.x = (
    position.x
  );

  object->position.y = (
    position.y
  );

  object->position.z = (
    position.z
  );

  object->rotation.x = (
    angle.x
  );

  object->rotation.y = (
    angle.y
  );

  object->rotation.z = (
    angle.z
  );

  struct projectile_data* projectile_data = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  projectile_data->colour.x = (
    0.1f
  );

  projectile_data->colour.y = (
    0.7f
  );

  projectile_data->colour.z = (
    0.8f
  );

  projectile_data->time_fired = (
    time_fired
  );

  projectile_data->time_current = (
    time_fired
  );

  projectile_data->lifespan = (
    projectile_lifespan
  );

  matrix_float4x4 matrix_projection_object_with_rotation =
    (matrix_float4x4)
    {{
      {
        math_c_cosine(
          object->rotation.y,
          math_c_pi
        ),
        0x00,
        -math_c_sine(
          object->rotation.y,
          math_c_pi
        ),
        0x00
      },
      {
        0x00,
        0x01,
        0x00,
        0x00
      },
      {
        math_c_sine(
          object->rotation.y,
          math_c_pi
        ),
        0x00,
        math_c_cosine(
          object->rotation.y,
          math_c_pi
        ),
        0x00
      },
      {
        0x00,
        0x00,
        0x00,
        0x01
      }
    }};

  matrix_projection_object_with_rotation = matrix_multiply(
    matrix_projection_object_with_rotation,
    (matrix_float4x4)
    {{
      {
        0x01,
        0x00,
        0x00,
        0x00
      },
      {
        0x00,
        math_c_cosine(
          object->rotation.x,
          math_c_pi
        ),
        -math_c_sine(
          object->rotation.x,
          math_c_pi
        ),
        0x00
      },
      {
        0x00,
        math_c_sine(
          object->rotation.x,
          math_c_pi
        ),
        math_c_cosine(
          object->rotation.x,
          math_c_pi
        ),
        0x00
      },
      {
        0x00,
        0x00,
        0x00,
        0x01
      }
    }}
  );

  projectile_data->translation = matrix_multiply(
    matrix_projection_object_with_rotation,
    (simd_float4)
    {
      0x00,
      0x00,
      0x01,
      0x00
    }
  );

  projectile_data->speed = (
    speed
  );

  projectile_data->time_delta_percent = (
    0.1f
  );

  float distance = (
    0x14
  );

  object->position.x = (
    object->position.x +
    projectile_data->translation.x *
    distance
  );

  object->position.y = (
    object->position.y +
    projectile_data->translation.y *
    distance
  );

  object->position.z = (
    object->position.z +
    projectile_data->translation.z *
    distance
  );
}

void object_projectile_travel(
  struct metil_object* metil_object,
  struct projectile_data* projectile_data
) {
  projectile_data->position_previous.x = (
    metil_object->position.x
  );

  projectile_data->position_previous.y = (
    metil_object->position.y
  );

  projectile_data->position_previous.z = (
    metil_object->position.z
  );

  float distance = (
    projectile_data->time_delta_percent *
    projectile_data->speed
  );

  metil_object->position.x = (
    metil_object->position.x +
    projectile_data->translation.x *
    distance
  );

  metil_object->position.y = (
    metil_object->position.y +
    projectile_data->translation.y *
    distance
  );

  metil_object->position.z = (
    metil_object->position.z +
    projectile_data->translation.z *
    distance
  );
}

void object_projectile_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct projectile_data* projectile_data = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  object_projectile_travel(
    metil_object,
    projectile_data
  );

  metil_positioning_view_model_matrix_projection_set(
    metil_object->positioning,
    &projectile_data->view_model_matrix_projection,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    &metil_object->position,
    &metil_object->rotation,
    &(
      (struct metil_scene_controller*)
      metil->scene_controller
    )->scene.player.position,
    metil_camera
  );
}
