#include <generate/generate_buildings.h>

#include <mesh/mesh_building.h>
#include <rendering/c938_pipeline_index.h>

#include <metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <math_c_absolute.h>
#include <math_c_maximum.h>

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
  unsigned int length_buildings,
  unsigned int index_target_building
) {
  struct metil_object* object = (
    0x00
  );

  struct metil_object* object_starting_point = (
    0x00
  );

  metil_group_destroy(
    metil,
    metil_group_buildings
  );

  metil_group_initialize(
    metil_group_buildings
  );

  metil_group_add_length_initialize(
    metil_group_buildings,
    length_buildings,
    metil_renderable_type_object
  );

  struct math_c_vector2_float size_maximum = {
    .x = (
      0x00
    ),
    .y = (
      0x00
    )
  };

  struct metil_renderer_data_object* data;

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    0x06,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  for (
    unsigned int index_building = (
      0x01
    );
    (
      index_building <
      length_buildings
    );
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

    object->index_pipeline_render = (
      c938_pipeline_index_building
    );

    mesh_building_initialize(
      &object->mesh,
      (
        0x53 +
        (
          (
            rand_result.bytes[
              0x00
            ] *
            rand_result.bytes[
              0x01
            ]
          ) %
          0x43
        )
      ),
      (
        0x03e8 +
        (
          (
            rand_result.bytes[
              0x02
            ] *
            rand_result.bytes[
              0x03
            ]
          ) %
          0x01f4
        )
      ),
      (
        0x53 +
        (
          (
            rand_result.bytes[
              0x04
            ] *
            rand_result.bytes[
              0x05
            ]
          ) %
          0x43
        )
      )
    );

    object->position.y = (
      0x00
    );

    if (
      index_building ==
      0x01
    ) {
      object_starting_point = metil_group_buildings->renderables[
        index_building
      ]->renderable;
    } else {
      struct metil_object* metil_object_building_random;

      unsigned char colliding = (
        0x00
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
              0x00
            ] *
            rand_result.bytes[
              0x01
            ]
          ) %
          index_building +
          0x01
        ]->renderable;

        object->position.x = (
          rand_result.bytes[
            0x02
          ] -
          127.5f
        );

        if (
          object->position.x >
          0x00
        ) {
          object->position.x = (
            object->position.x +
            metil_object_building_random->position.x +
            metil_object_building_random->mesh.size.x /
            0x02 +
            object->mesh.size.x /
            0x02
          );
        } else {
          object->position.x = (
            object->position.x -
            metil_object_building_random->position.x -
            metil_object_building_random->mesh.size.x /
            0x02 -
            object->mesh.size.x /
            0x02
          );
        }

        object->position.z = (
          rand_result.bytes[
            0x03
          ] -
          127.5f
        );

        if (
          object->position.z >
          0x00
        ) {
          object->position.z = (
            object->position.z +
            metil_object_building_random->position.z +
            metil_object_building_random->mesh.size.z /
            0x02 +
            object->mesh.size.z /
            0x02
          );
        } else {
          object->position.z = (
            object->position.z -
            metil_object_building_random->position.z -
            metil_object_building_random->mesh.size.z /
            0x02 -
            object->mesh.size.z /
            0x02
          );
        }

        colliding = (
          0x00
        );

        for (
          unsigned int index_building_collision = (
            0x01
          );
          (
            index_building_collision <
            index_building
          );
          ++index_building_collision
        ) {
          struct metil_object* metil_object_building_collision_check = (
             metil_group_buildings->renderables[
              index_building_collision
            ]->renderable
          );

          if (
            (
              (
                object->position.x -
                object->mesh.size.x /
                0x02
              ) <=
              (
                metil_object_building_collision_check->position.x +
                metil_object_building_collision_check->mesh.size.x /
                0x02
              )
            ) &&
            (
              (
                object->position.x +
                object->mesh.size.x /
                0x02
              ) >=
              (
                metil_object_building_collision_check->position.x -
                metil_object_building_collision_check->mesh.size.x /
                0x02
              )
            ) &&
            (
              (
                object->position.z -
                object->mesh.size.z /
                0x02
              ) <=
              (
                metil_object_building_collision_check->position.z +
                metil_object_building_collision_check->mesh.size.z /
                0x02
              )
            ) &&
            (
              (
                object->position.z +
                object->mesh.size.z /
                0x02
              ) >=
              (
                metil_object_building_collision_check->position.z -
                metil_object_building_collision_check->mesh.size.z /
                0x02
              )
            )
          ) {
            colliding = (
              0x01
            );
          }
        }
      } while (
        colliding ==
        0x01
      );

      if (
        index_building >
        0x01
      ) {
        float height = (
          rand_result.bytes[
            0x04
          ] -
          127.5f +
          metil_object_building_random->mesh.size.y
        );

        mesh_building_height_set(
          &object->mesh,
          height
        );
      }
    }

    object->type_primitive = (
      MTLPrimitiveTypeLine
    );

    metil_object_buffers_initialize(
      object,
      metal_device
    );

    data = object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents;

    if (
      index_building ==
      index_target_building
    ) {
      data->colour.x = (
        0x00
      );

      data->colour.y = (
        0x00
      );
    } else {
      data->colour.x = (
        0x01
      );

      data->colour.y = (
        0x01
      );
    }

    data->colour.z = (
      0x01
    );

    data->colour.w = (
      0x01
    );

    struct math_c_vector2_float limits = {
      .x = (
        math_c_maximum_float(
          (
            object->position.x +
            (
              object->mesh.size.x /
              0x02
            )
          ),
          math_c_absolute_float(
            object->position.x -
            (
              object->mesh.size.x /
              0x02
            )
          )
        )
      ),
      .y = (
        math_c_maximum_float(
          (
            object->position.z +
            (
              object->mesh.size.z /
              0x02
            )
          ),
          math_c_absolute_float(
            object->position.z -
            (
              object->mesh.size.z /
              0x02
            )
          )
        )
      )
    };

    if (
      limits.x > size_maximum.x
    ) {
      size_maximum.x = (
        limits.x
      );
    }

    if (
      limits.y > size_maximum.y
    ) {
      size_maximum.y = (
        limits.y
      );
    }
  }

  object = (
    metil_group_buildings->renderables[
      0x00
    ]->renderable
  );

  mesh_building_initialize(
    &object->mesh, (
      size_maximum.x *
      0x02 +
      0xc8
    ),
    0x01,
    (
      size_maximum.y *
      0x02 +
      0xc8
    )
  );

  object->type_primitive = (
    MTLPrimitiveTypeLine
  );

  object->index_pipeline_render = (
    c938_pipeline_index_ground
  );

  object->position.y = (
    0x00
  );

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  rand_clean(
    &rand_result,
    &rand_source
  );
}
