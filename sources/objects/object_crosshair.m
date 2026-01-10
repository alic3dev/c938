#include <objects/object_crosshair.h>

#include <mesh/mesh_crosshair.h>
#include <c938_pipeline_index.h>

#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

void object_crosshair_initialize(
  struct metil_object* object,
  id<MTLDevice> metal_device
) {
  metil_object_initialize(
    object
  );

  mesh_crosshair_initialize(
    &object->mesh
  );

  object->positioning = metil_positioning_static;

  object->type_primitive = (
    MTLPrimitiveTypeLine
  );

  object->index_pipeline_render = (
    c938_pipeline_index_crosshair
  );

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  object->position.x = 0.0f;
  object->position.y = 0.0f;
  object->position.z = 0.0f;

  struct metil_renderer_data_object* data = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data->color.x = 1.0f;
  data->color.y = 1.0f;
  data->color.z = 1.0f;
  data->color.w = 1.0f;
}
