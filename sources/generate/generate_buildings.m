#include <generate/generate_buildings.h>

#include <mesh/mesh_building.h>
#include <pipeline_index.h>

#include <metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <rand_clean.h>
#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void generate_buildings(
  struct metil* metil,
  id<MTLDevice> metal_device,
  struct metil_group* metil_group_buildings,
  unsigned short int length_buildings,
  unsigned short int index_target_building,
  id<MTLTexture> texture
) {
  signed int size = 2500;

  struct metil_object* object = (void*) 0;
  struct metil_object* object_starting_point = (void*) 0;

  metil_group_destroy(
    metil,
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
    6,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  for (
    unsigned char index_building = 1;
    index_building < length_buildings;
    ++index_building
  ) {
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
      struct metil_object* metil_object_building_random;

      unsigned char colliding = (
        0
      );

      do {
        rand_get(
          &rand_source,
          &rand_result,
          &rand_parameters
        );

        metil_object_building_random = metil_group_buildings->renderables[
          (
            rand_result.bytes[
              0
            ] *
            rand_result.bytes[
              1
            ]
          ) %
          index_building +
          1
        ]->renderable;

        object->position.x = (
          rand_result.bytes[
            2
          ] - (
            127.5f
          )
        );

        if (
          object->position.x > 0.0f
        ) {
          object->position.x = (
            object->position.x +
            metil_object_building_random->position.x +
            metil_object_building_random->mesh.size.x / 2.0f +
            object->mesh.size.x / 2.0f
          );
        } else {
          object->position.x = (
            object->position.x -
            metil_object_building_random->position.x -
            metil_object_building_random->mesh.size.x / 2.0f -
            object->mesh.size.x / 2.0f
          );
        }

        object->position.z = (
          rand_result.bytes[
            3
          ] - (
            127.5f
          )
        );

        if (
          object->position.z > 0.0f
        ) {
          object->position.z = (
            object->position.z +
            metil_object_building_random->position.z +
            metil_object_building_random->mesh.size.z / 2.0f +
            object->mesh.size.z / 2.0f
          );
        } else {
          object->position.z = (
            object->position.z -
            metil_object_building_random->position.z -
            metil_object_building_random->mesh.size.z / 2.0f -
            object->mesh.size.z / 2.0f
          );
        }

        colliding = 0;

        for (
          unsigned int index_building_collision = 1;
          index_building_collision < index_building;
          ++index_building_collision
        ) {
          struct metil_object* metil_object_building_collision_check = (
             metil_group_buildings->renderables[
              index_building_collision
            ]->renderable
          );

          if (
            object->position.x - object->mesh.size.x / 2.0f <= metil_object_building_collision_check->position.x + metil_object_building_collision_check->mesh.size.x / 2.0f &&
            object->position.x + object->mesh.size.x / 2.0f >= metil_object_building_collision_check->position.x - metil_object_building_collision_check->mesh.size.x / 2.0f &&
            object->position.z - object->mesh.size.z / 2.0f <= metil_object_building_collision_check->position.z + metil_object_building_collision_check->mesh.size.z / 2.0f &&
            object->position.z + object->mesh.size.z / 2.0f >= metil_object_building_collision_check->position.z - metil_object_building_collision_check->mesh.size.z / 2.0f
          ) {
            colliding = 1;
          }
        }
      } while (
        colliding == 1
      );

      if (
        index_building > 1
      ) {
        float height = (
          rand_result.bytes[
            4
          ] - (
            127.5f
          ) +
          metil_object_building_random->mesh.size.y
        );

        mesh_building_height_set(
          &object->mesh,
          height
        );
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
      index_building == index_target_building
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

  rand_clean(
    &rand_result,
    &rand_source
  );
}
