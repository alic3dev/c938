#include <objects/object_projectile.h>

#include <mesh/mesh_projectile.h>
#include <pipeline_index.h>
#include <projectile_lifespan.h>

#include <clic3_vector.h>

#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

void object_projectile_initialize(
  struct metil_object* object,
  id<MTLDevice> metal_device,
  struct clic3_vector3_float position,
  struct clic3_vector3_float angle
) {
  mesh_projectile_initialize(
    &object->mesh
  );

  object->poll = object_projectile_poll;

  object->type_primitive = (
    MTLPrimitiveTypeLine
  );

  object->depth_disabled = 1;

  object->index_pipeline_render = (
    c938_pipeline_index_projectile
  );

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  object->position.x = position.x;
  object->position.y = position.y;
  object->position.z = position.z;

  object->rotation.x = angle.x;
  object->rotation.y = angle.y;
  object->rotation.z = angle.z;

  struct metil_renderer_data_object* data = (
    object->data.contents
  );

  data->color.x = 0.7f;
  data->color.y = 0.3f;
  data->color.z = 1.0f;
  data->color.w = 1.0f;

  data->noise = projectile_lifespan;
}

void object_projectile_poll(
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  metil_object_poll(
    metil_object,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );

  struct metil_renderer_data_object* metil_renderer_data_object = (
    metil_object->data.contents
  );

  metil_renderer_data_object->noise = (
    metil_renderer_data_object->noise -
    1
  );
}
