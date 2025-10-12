#include <generate/generate_buildings.h>

#include <mesh/mesh_building.h>
#include <mode_texture.h>

#include <metil_object.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void generate_buildings(
  id<MTLDevice> metal_kit_device,
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
  }

  mesh_building_initialize(
    &objects[0]->mesh,
    size * 2,
    1.0f,
    size * 2
  );

  objects[0]->position.y = 0.0f;

  metil_object_buffers_initialize(
    objects[0],
    metal_kit_device
  );

  objects[0]->texture = textures[
    0
  ];

  objects[0]->texture_secondary = textures[
    1
  ];

  unsigned short int iterator_id = offset_id;

  struct metil_renderer_data_object* data = objects[0]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_ground;

  for (
    unsigned char index_object = 1;
    index_object < length_objects;
    ++index_object
  ) {
    mesh_building_initialize(
      &objects[index_object]->mesh,
      83.0f + (rand() % 67),
      1000.0f + (rand() % 500),
      83.0f + (rand() % 67)
    );

    objects[index_object]->position.y = 0.0f;

    if (index_object != 1) {
      while (
        objects[index_object]->position.x - objects[index_object]->mesh.size.x / 2.0f <= objects[1]->mesh.size.x / 2.0f &&
        objects[index_object]->position.x + objects[index_object]->mesh.size.x / 2.0f >= -objects[1]->mesh.size.x / 2.0f &&
        objects[index_object]->position.z - objects[index_object]->mesh.size.z / 2.0f <= objects[1]->mesh.size.z / 2.0f &&
        objects[index_object]->position.z + objects[index_object]->mesh.size.z / 2.0f >= -objects[1]->mesh.size.z / 2.0f
      ) {
        objects[index_object]->position.x = -size / 2 + (rand() % size);
        objects[index_object]->position.z = -size / 2 + (rand() % size);
      }
    }

    metil_object_buffers_initialize(
      objects[index_object],
      metal_kit_device
    );

    objects[index_object]->texture = textures[
      (rand() % (length_textures - 1))
    ];

    data = objects[index_object]->data.contents;
    data->id = iterator_id++;
    data->mode_texture = mode_texture_building;
  }
}
