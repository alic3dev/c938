#include <mesh/mesh_player.h>

#include <metil_mesh/metil_mesh.h>
#include <metil_player/metil_player_defaults.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

#include <math.h>

void mesh_player_initialize(
  struct metil_mesh* mesh,
  struct metil_player_defaults* metil_player_defaults
) {
  metil_mesh_initialize(
    mesh
  );

  mesh->size.x = (
    metil_player_defaults->size.x
  );

  mesh->size.y = (
    metil_player_defaults->size.y
  );

  mesh->size.z = (
    metil_player_defaults->size.z
  );

  mesh->length_vertices = 14;

  mesh->length_indices = (
    (
      mesh->length_vertices -
      1
    ) *
    3
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

  mesh->vertices[0].x = 0;
  
  mesh->vertices[0].y = (
    metil_player_defaults->size.y
  );
  
  mesh->vertices[0].z = 0;

  mesh->vertices[0].w = 1.0f;

  for (
    unsigned char index_vertex = 1;
    index_vertex < mesh->length_vertices;
    ++index_vertex
  ) {
    float angle = (
      (
        (float)
        (
          index_vertex -
          1
        )
      ) /
      (
        (float)
        (
          mesh->length_vertices -
          2
        )
      ) *
      M_PI *
      2.0f
    );
    
    mesh->vertices[
      index_vertex
    ].x = (
      cos(
        angle
      ) *
      metil_player_defaults->size.x
    );
    
    mesh->vertices[
      index_vertex
    ].y = 0;
    
    mesh->vertices[
      index_vertex
    ].z = (
      sin(
        angle
      ) *
      metil_player_defaults->size.z
    );
    
    mesh->vertices[
      index_vertex
    ].w = 1.0f;
  }

  for (
    unsigned char index_index = 0;
    index_index < (
      mesh->length_indices /
      3
    );
    ++index_index
  ) {
    mesh->indices[
      index_index *
      3
    ] = 0;

    mesh->indices[
      index_index *
      3 +
      1
    ] = (
      index_index
    );

    mesh->indices[
      index_index *
      3 +
      2
    ] = (
      index_index +
      1
    );
  }
}
