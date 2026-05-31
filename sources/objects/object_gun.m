#include <objects/object_gun.h>

#include <animations/animation_gun_idle.h>
#include <data/gun_data.h>
#include <mesh/mesh_gun.h>
#include <rendering/c938_pipeline_index.h>

#include <clic3_memory.h>

#include <metil_object/metil_object.h>

void c938_object_gun_initialize(
  struct metil* metil,
  struct metil_object* c938_object_gun,
  unsigned char handedness
) {
  mesh_gun_initialize(
    &c938_object_gun->mesh,
    handedness
  );
  
  c938_object_gun->type_primitive = (
    MTLPrimitiveTypeLine
  );
  
  c938_object_gun->index_pipeline_render = (
    c938_pipeline_index_gun
  );
  
  metil_object_buffers_initialize(
    c938_object_gun,
    metil->renderer_interface.metal_device
  );
  
  c938_object_gun->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct c938_data_gun_data
      )
    )
  );
  
  struct c938_data_gun_data* c938_data_gun_data = (
    c938_object_gun->data
  );
  
  c938_animation_gun_idle_initialize(
    &c938_data_gun_data->animation_idle,
    &c938_object_gun->position,
    &c938_object_gun->rotation
  );
  
  metil_animation_start(
    &c938_data_gun_data->animation_idle,
    metil_renderable_type_object,
    0x00
  );
  
  c938_object_gun->poll = (
    c938_object_gun_poll
  );
  
  c938_object_gun->destroy = (
    c938_object_gun_destroy
  );
}

void c938_object_gun_poll(
  struct metil* metil,
  struct metil_object* c938_object_gun,
  matrix_float3x4* matrix_projection_state,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct c938_data_gun_data* c938_data_gun_data = (
    c938_object_gun->data
  );
  
  metil_animation_poll(
    &c938_data_gun_data->animation_idle,
    metil_renderable_type_object,
    0x00
  );
  
  metil_object_poll(
    metil,
    c938_object_gun,
    matrix_projection_state,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );
}

void c938_object_gun_destroy(
  struct metil* metil,
  struct metil_object* c938_object_gun
) {
  struct c938_data_gun_data* c938_data_gun_data = (
    c938_object_gun->data
  );

  c938_animation_gun_idle_destroy(
    &c938_data_gun_data->animation_idle
  );
  
  metil_object_destroy(
    metil,
    c938_object_gun
  );  
}

