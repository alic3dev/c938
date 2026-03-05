#include <mesh/mesh_building.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void mesh_building_initialize(
  struct metil_mesh* mesh,
  float width,
  float height,
  float depth
) {
  metil_mesh_initialize(
    mesh
  );

  struct math_c_vector3_float size_half = {
    .x = (
      width /
      2.0f
    ),
    .y = (
      height /
      2.0f
    ),
    .z = (
      depth /
      2.0f
    )
  };

  mesh->size.x = (
    width
  );

  mesh->size.y = (
    height
  );

  mesh->size.z = (
    depth
  );

  unsigned char layers = (
    2
  );

  mesh->length_vertices = (
    layers *
    4
  );

  mesh->length_indices = (
    (
      layers -
      1
    ) *
    16 +
    8
  );

  clic3_memory_reallocate_raw(
    &mesh->indices,
    (
      sizeof(
        unsigned int
      ) *
      mesh->length_indices
    )
  );

  clic3_memory_reallocate_raw(
    &mesh->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      mesh->length_vertices
    )
  );

  unsigned int index_index = (
    0
  );

  for (
    unsigned char index_layer = 0;
    index_layer < layers;
    ++index_layer
  ) {
    unsigned int index_vertex = (
      index_layer *
      4
    );

    float position_y = (
      (
        (float)
        index_layer /
        (float)
        (
          layers -
          1
        )
      ) *
      mesh->size.y
    );

    mesh->vertices[
      index_vertex
    ].x = (
      -size_half.x
    );

    mesh->vertices[
      index_vertex
    ].y = (
      position_y
    );

    mesh->vertices[
      index_vertex
    ].z = (
      -size_half.z
    );

    mesh->vertices[
      index_vertex
    ].w = (
      1.0f
    );

    mesh->vertices[
      index_vertex +
      1
    ].x = (
      size_half.x
    );

    mesh->vertices[
      index_vertex +
      1
    ].y = (
      position_y
    );

    mesh->vertices[
      index_vertex +
      1
    ].z = (
      -size_half.z
    );

    mesh->vertices[
      index_vertex +
      1
    ].w = (
      1.0f
    );

    mesh->vertices[
      index_vertex +
      2
    ].x = (
      size_half.x
    );

    mesh->vertices[
      index_vertex +
      2
    ].y = (
      position_y
    );

    mesh->vertices[
      index_vertex +
      2
    ].z = (
      size_half.z
    );

    mesh->vertices[
      index_vertex +
      2
    ].w = (
      1.0f
    );

    mesh->vertices[
      index_vertex +
      3
    ].x = (
      -size_half.x
    );

    mesh->vertices[
      index_vertex +
      3
    ].y = (
      position_y
    );

    mesh->vertices[
      index_vertex +
      3
    ].z = (
      size_half.z
    );

    mesh->vertices[
      index_vertex +
      3
    ].w = (
      1.0f
    );

    mesh->indices[
      index_index
    ] = (
      index_vertex
    );

    mesh->indices[
      index_index +
      1
    ] = (
      index_vertex +
      1
    );

    mesh->indices[
      index_index +
      2
    ] = (
      index_vertex +
      1
    );

    mesh->indices[
      index_index +
      3
    ] = (
      index_vertex +
      2
    );

    mesh->indices[
      index_index +
      4
    ] = (
      index_vertex +
      2
    );

    mesh->indices[
      index_index +
      5
    ] = (
      index_vertex +
      3
    );

    mesh->indices[
      index_index +
      6
    ] = (
      index_vertex +
      3
    );

    mesh->indices[
      index_index +
      7
    ] = (
      index_vertex
    );

    if (
      index_layer > 0
    ) {
      mesh->indices[
        index_index +
        8
      ] = (
        index_vertex
      );

      mesh->indices[
        index_index +
        9
      ] = (
        index_vertex -
        4
      );

      mesh->indices[
        index_index +
        10
      ] = (
        index_vertex +
        1
      );

      mesh->indices[
        index_index +
        11
      ] = (
        index_vertex -
        3
      );

      mesh->indices[
        index_index +
        12
      ] = (
        index_vertex +
        2
      );

      mesh->indices[
        index_index +
        13
      ] = (
        index_vertex -
        2
      );

      mesh->indices[
        index_index +
        14
      ] = (
        index_vertex +
        3
      );

      mesh->indices[
        index_index +
        15
      ] = (
        index_vertex -
        1
      );

      index_index = (
        index_index +
        16
      );
    } else {
      index_index = (
        index_index +
        8
      );
    }
  }
}

void mesh_building_height_set(
  struct metil_mesh* metil_mesh,
  float height
) {
  unsigned char layers = 2;

  metil_mesh->size.y = (
    height
  );

  for (
    unsigned short int index_layer = 0;
    index_layer < layers;
    ++index_layer
  ) {
    unsigned short int index_vertex = (
      index_layer * 4
    );

   float position_y = (
      (
        (float) index_layer /
        (float) (
          layers -
          1
        )
      ) *
      metil_mesh->size.y
    );

    metil_mesh->vertices[
      index_vertex
    ].y = (
      position_y
    );

    metil_mesh->vertices[
      index_vertex +
      1
    ].y = (
      position_y
    );

    metil_mesh->vertices[
      index_vertex +
      2
    ].y = (
      position_y
    );

    metil_mesh->vertices[
      index_vertex +
      3
    ].y = (
      position_y
    );
  }
}
