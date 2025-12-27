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
  struct metil_group* metil_group_buildings,
  unsigned short int length_buildings,
  id<MTLTexture> texture
) {
  signed int size = 2500;

  struct metil_object* object = (void*) 0;
  struct metil_object* object_starting_point = (void*) 0;

  metil_group_destroy(
    metil_group_buildings
  );

  metil_group_initialize(
    metil_group_buildings
  );

  for (
    unsigned short int index_building = metil_group_buildings->length;
    index_building < length_buildings;
    ++index_building
  ) {
    metil_group_add_initialize(
      metil_group_buildings,
      metil_renderable_type_object
    );

    object = metil_group_buildings->renderables[
      index_building
    ]->renderable;

    object->index_pipeline_render = (
      c938_pipeline_index_building
    );
  }

  object = (
    metil_group_buildings->renderables[
      0
    ]->renderable
  );

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

  struct metil_renderer_data_object* data = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

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
    unsigned char index_building = 1;
    index_building < length_buildings;
    ++index_building
  ) {
    offset_index_bytes = 0;

    rand_get(
      &rand_source,
      &rand_result,
      &rand_parameters
    );

    object = (
      metil_group_buildings->renderables[
        index_building
      ]->renderable
    );

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
      index_building == 1
    ) {
      object_starting_point = metil_group_buildings->renderables[
        index_building
      ]->renderable;
    } else {
      while (
        object->position.x - object->mesh.size.x / 2.0f <= object_starting_point->mesh.size.x / 2.0f &&
        object->position.x + object->mesh.size.x / 2.0f >= -object_starting_point->mesh.size.x / 2.0f &&
        object->position.z - object->mesh.size.z / 2.0f <= object_starting_point->mesh.size.z / 2.0f &&
        object->position.z + object->mesh.size.z / 2.0f >= -object_starting_point->mesh.size.z / 2.0f
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

    data = object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents;

    if (
      index_building == 2
    ) {
      data->color.x = 0.0f;
      data->color.y = 0.0f;
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
