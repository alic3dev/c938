#include <objects/object_gun.h>

#include <mesh/mesh_gun.h>
#include <rendering/c938_pipeline_index.h>

void object_gun_initialize(
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
}
