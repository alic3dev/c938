#include <generate/generate_buildings.h>

#include <mesh/mesh_building.h>
#include <pipeline_index.h>

#include <metil_object.h>
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
  struct metil_object** objects,
  unsigned short int length_objects,
  id<MTLTexture>* textures,
  unsigned short int length_textures,
  unsigned short int offset_id
) {
  signed int size = 2500;

  for (
    unsigned char index_object = 0;
    index_object < length_objects;
    ++index_object
  ) {
    objects[
      index_object
    ] = malloc(
      sizeof(struct metil_object)
    );

    metil_object_initialize(
      objects[index_object]
    );

    objects[index_object]->index_pipeline_render = c938_pipeline_index_building;
  }

  mesh_building_initialize(
    &objects[0]->mesh,
    size * 2,
    1.0f,
    size * 2
  );

  objects[0]->index_pipeline_render = c938_pipeline_index_ground;

  objects[0]->position.y = 0.0f;

  metil_object_buffers_initialize(
    objects[0],
    metal_device
  );

  metil_object_texture_add(
    objects[0],
    textures[
      0
    ]
  );

  unsigned short int iterator_id = offset_id;

  struct metil_renderer_data_object* data = objects[0]->data.contents;
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
    unsigned char index_object = 1;
    index_object < length_objects;
    ++index_object
  ) {
    offset_index_bytes = 0;

    rand_get(
      &rand_source,
      &rand_result,
      &rand_parameters
    );

    mesh_building_initialize(
      &objects[index_object]->mesh,
      83.0f + ((rand_result.bytes[0] * rand_result.bytes[1]) % 67),
      1000.0f + ((rand_result.bytes[2] * rand_result.bytes[3]) % 500),
      83.0f + ((rand_result.bytes[4] * rand_result.bytes[5]) % 67)
    );

    objects[index_object]->position.y = 0.0f;

    if (index_object != 1) {
      while (
        objects[index_object]->position.x - objects[index_object]->mesh.size.x / 2.0f <= objects[1]->mesh.size.x / 2.0f &&
        objects[index_object]->position.x + objects[index_object]->mesh.size.x / 2.0f >= -objects[1]->mesh.size.x / 2.0f &&
        objects[index_object]->position.z - objects[index_object]->mesh.size.z / 2.0f <= objects[1]->mesh.size.z / 2.0f &&
        objects[index_object]->position.z + objects[index_object]->mesh.size.z / 2.0f >= -objects[1]->mesh.size.z / 2.0f
      ) {
        objects[index_object]->position.x = (
          -size / 2 + (
            (rand_result.bytes[10 + offset_index_bytes] * rand_result.bytes[11 + offset_index_bytes]) % size
          )
        );
        objects[index_object]->position.z = (
          -size / 2 + (
            (rand_result.bytes[12 + offset_index_bytes] * rand_result.bytes[13 + offset_index_bytes]) % size
          )
        );

        offset_index_bytes = (
          offset_index_bytes + 4
        );

        if (offset_index_bytes == 16) {
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
      objects[index_object],
      textures[
        index_object == 2
        ? (((rand_result.bytes[6] * rand_result.bytes[7]) % 5) + 4) % length_textures
        : ((rand_result.bytes[8] * rand_result.bytes[9]) % length_textures) % 4
      ]
    );

    metil_object_buffers_initialize(
      objects[index_object],
      metal_device
    );

    data = objects[index_object]->data.contents;
    data->id = iterator_id++;

    if (index_object == 2) {
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
