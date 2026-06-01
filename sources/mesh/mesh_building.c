#include <mesh/mesh_building.h>

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

void mesh_building_initialize(
  struct metil_mesh* mesh,
  float width,
  float height,
  float depth
) {
  unsigned int layers = (
    0x0a
  );

  metil_mesh_initialize_with_lengths(
    mesh,
    (
      layers *
      0x04
    ),
    (
      (
        layers -
        0x01
      ) *
      0x18 +
      0x0c
    )
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

  unsigned int index_index = (
    0x00
  );

  for (
    unsigned char index_layer = (
      0x00
    );
    (
      index_layer <
      layers
    );
    ++index_layer
  ) {
    unsigned int index_vertex = (
      index_layer *
      0x04
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
      position_y +
      (float)
      (
        (
          (
            index_layer +
            0x01
          ) *
          (
            index_vertex +
            0x01
          )
        ) %
        0x0a
      ) /
      0x09 *
      0x01 -
      0.5f
    );

    mesh->vertices[
      index_vertex
    ].z = (
      -size_half.z
    );

    mesh->vertices[
      index_vertex
    ].w = (
      0x01
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
      position_y +
      (float)
      (
        (
          (
            index_layer +
            0x04
          ) *
          (
            index_vertex +
            0x05
          )
        ) %
        0x0a
      ) /
      0x09 *
      0x01 -
      0.5f
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
      0x01
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
      position_y +
      (float)
      (
        (
          (
            index_layer +
            0x0a
          ) *
          (
            index_vertex +
            0x05
          )
        ) %
        0x0a
      ) /
      0x09 *
      0x01 -
      0.5f
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
      0x01
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
      position_y +
      (float)
      (
        (
          (
            index_layer +
            0x0c
          ) *
          (
            index_vertex +
            0x0d
          )
        ) %
        0x0a
      ) /
      0x09 *
      0x01 -
      0.5f
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
      0x01
    );
  }
  
  for (
    unsigned int index_index = 0;
    index_index < mesh->length_indices;
    ++index_index
  ) { mesh->indices[index_index] = 0; }
  
  mesh->indices[
    0x00
  ] = (
    0x00
  );
  
  mesh->indices[
    0x01
  ] = (
    0x01
  );
  
  mesh->indices[
    0x02
  ] = (
    0x02
  );
  
  mesh->indices[
    0x03
  ] = (
    0x02
  );
  
  mesh->indices[
    0x04
  ] = (
    0x03
  );
  
  mesh->indices[
    0x05
  ] = (
    0x00
  );
  
  for (
    unsigned int index_index = (
      0x06
    );
    (
      index_index <
      (
        mesh->length_indices -
        0x06
      )
    );
    index_index = (
      index_index +
      0x18
    )
  ) {
    unsigned char index_layer = (
      (
        index_index -
        0x06
      ) /
      0x18
    );
    
    unsigned int index_vertex = (
      index_layer *
      0x04
    );
  
    mesh->indices[
      index_index
    ] = (
      index_vertex
    );
    
    mesh->indices[
      index_index +
      0x01
    ] = (
      index_vertex +
      0x01    );
    
    mesh->indices[
      index_index +
      0x02
    ] = (
      index_vertex +
      0x04
    );
    
    mesh->indices[
      index_index +
      0x03
    ] = (
      index_vertex +
      0x04
    );
    
    mesh->indices[
      index_index +
      0x04
    ] = (
      index_vertex +
      0x05
    );
    
    mesh->indices[
      index_index +
      0x05
    ] = (
      index_vertex +
      0x01
    );
    
    mesh->indices[
      index_index +
      0x06
    ] = (
      index_vertex +
      0x01
    );
    
    mesh->indices[
      index_index +
      0x07
    ] = (
      index_vertex +
      0x02
    );
    
    mesh->indices[
      index_index +
      0x08
    ] = (
      index_vertex +
      0x05
    );
    
    mesh->indices[
      index_index +
      0x09
    ] = (
      index_vertex +
      0x05
    );
    
    mesh->indices[
      index_index +
      0x0a
    ] = (
      index_vertex +
      0x06
    );
    
    mesh->indices[
      index_index +
      0x0b
    ] = (
      index_vertex +
      0x02
    );
    
    mesh->indices[
      index_index +
      0x0c
    ] = (
      index_vertex +
      0x02
    );
    
    mesh->indices[
      index_index +
      0x0d
    ] = (
      index_vertex +
      0x03
    );
    
    mesh->indices[
      index_index +
      0x0e
    ] = (
      index_vertex +
      0x06
    );
    
    mesh->indices[
      index_index +
      0x0f
    ] = (
      index_vertex +
      0x06
    );
    
    mesh->indices[
      index_index +
      0x10
    ] = (
      index_vertex +
      0x07
    );
    
    mesh->indices[
      index_index +
      0x11
    ] = (
      index_vertex +
      0x03
    );
    
    mesh->indices[
      index_index +
      0x12
    ] = (
      index_vertex +
      0x03
    );
    
    mesh->indices[
      index_index +
      0x13
    ] = (
      index_vertex +
      0x07
    );
    
    mesh->indices[
      index_index +
      0x14
    ] = (
      index_vertex +
      0x04
    );
    
    mesh->indices[
      index_index +
      0x15
    ] = (
      index_vertex +
      0x04
    );
    
    mesh->indices[
      index_index +
      0x16
    ] = (
      index_vertex +
      0x00
    );
    
    mesh->indices[
      index_index +
      0x17
    ] = (
      index_vertex +
      0x03
    );
  }
  
  mesh->indices[
    mesh->length_indices -
    0x06
  ] = (
    mesh->length_vertices -
    0x04
  );
  
  mesh->indices[
    mesh->length_indices -
    0x05
  ] = (
    mesh->length_vertices -
    0x03
  );
  
  mesh->indices[
    mesh->length_indices -
    0x04
  ] = (
    mesh->length_vertices -
    0x02
  );
  
  mesh->indices[
    mesh->length_indices -
    0x03
  ] = (
    mesh->length_vertices -
    0x02
  );
  
  mesh->indices[
    mesh->length_indices -
    0x02
  ] = (
    mesh->length_vertices -
    0x04
  );
  
  mesh->indices[
    mesh->length_indices -
    0x01
  ] = (
    mesh->length_vertices -
    0x01
  );}

void mesh_building_height_set(
  struct metil_mesh* metil_mesh,
  float height
) {
  unsigned char layers = (
    0x0a
  );

  metil_mesh->size.y = (
    height
  );

  for (
    unsigned short int index_layer = (
      0x00
    );
    (
      index_layer <
      layers
    );
    ++index_layer
  ) {
    unsigned short int index_vertex = (
      index_layer *
      0x04
    );

   float position_y = (
      (
        (float)
        index_layer /
        (float) (
          layers -
          0x01
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
      0x01
    ].y = (
      position_y
    );

    metil_mesh->vertices[
      index_vertex +
      0x02
    ].y = (
      position_y
    );

    metil_mesh->vertices[
      index_vertex +
      0x03
    ].y = (
      position_y
    );
  }
}
