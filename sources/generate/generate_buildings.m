#include <generate/generate_buildings.h>

#include <mesh/mesh_building.h>
#include <pipeline_index.h>

#include <metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void generate_buildings(
  id<MTLDevice> metal_device,
  struct metil_renderable* renderables,
  unsigned short int length_renderables,
  id<MTLTexture> texture,
  unsigned short int offset_id
) {
  signed int size = 2500;

  struct metil_object* object = (void*)0;
  struct metil_object* object_target = (void*)0;

  for (
    unsigned int index_renderable = 0;
    index_renderable < length_renderables;
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      renderables,
      index_renderable,
      metil_renderable_type_object
    );

    object = renderables[
      index_renderable
    ].renderable;

    object->index_pipeline_render = (
      c938_pipeline_index_building
    );
  }

  object = renderables[
    0
  ].renderable;

  mesh_building_initialize(
    &object->mesh,
    size * 2,
    1.0f,
    size * 2
  );

  object->index_pipeline_render = (
    c938_pipeline_index_ground
  );

  object->position.y = 0.0f;

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  metil_object_texture_add(
    object,
    texture
  );

  unsigned short int iterator_id = offset_id;

  struct metil_renderer_data_object* data = (
    object->data.contents
  );
  data->id = iterator_id++;

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    30,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  unsigned char offset_index_bytes = 0;

  for (
    unsigned char index_renderable = 1;
    index_renderable < length_renderables;
    ++index_renderable
  ) {
    offset_index_bytes = 0;

    rand_get(
      &rand_source,
      &rand_result,
      &rand_parameters
    );

    object = renderables[
      index_renderable
    ].renderable;

    mesh_building_initialize(
      &object->mesh,
      83.0f + ((
        rand_result.bytes[0] *
        rand_result.bytes[1]
      ) % 67),
      1000.0f + ((
        rand_result.bytes[2] *
        rand_result.bytes[3]
      ) % 500),
      83.0f + ((
        rand_result.bytes[4] *
        rand_result.bytes[5]
      ) % 67)
    );

    object->position.y = 0.0f;

    if (
      index_renderable == 1
    ) {
      object_target = renderables[
        index_renderable
      ].renderable;
    } else {
      while (
        object->position.x - object->mesh.size.x / 2.0f <= object_target->mesh.size.x / 2.0f &&
        object->position.x + object->mesh.size.x / 2.0f >= -object_target->mesh.size.x / 2.0f &&
        object->position.z - object->mesh.size.z / 2.0f <= object_target->mesh.size.z / 2.0f &&
        object->position.z + object->mesh.size.z / 2.0f >= -object_target->mesh.size.z / 2.0f
      ) {
        object->position.x = (
          (size / -2) + ((
            rand_result.bytes[
              offset_index_bytes + 10
            ] *
            rand_result.bytes[
              offset_index_bytes + 11
            ]
          ) % size)
        );
        object->position.z = (
          (size / -2) + ((
            rand_result.bytes[
              offset_index_bytes + 12
            ] *
            rand_result.bytes[
              offset_index_bytes + 13
            ]
          ) % size)
        );

        offset_index_bytes = (
          offset_index_bytes + 4
        );

        if (
          offset_index_bytes == 16
        ) {
          offset_index_bytes = 0;

          rand_get(
            &rand_source,
            &rand_result,
            &rand_parameters
          );
        }
      }
    }

    metil_object_texture_add(
      object,
      texture
    );

    metil_object_buffers_initialize(
      object,
      metal_device
    );

    data = object->data.contents;
    data->id = iterator_id++;

    if (
      index_renderable == 2
    ) {
      data->color.x = 1.0f;
      data->color.y = 1.0f;
      data->color.z = 1.0f;
      data->color.w = 1.0f;
    } else {
      data->color.x = 1.0f;
      data->color.y = 1.0f;
      data->color.z = 1.0f;
      data->color.w = 1.0f;
    }
  }
}
