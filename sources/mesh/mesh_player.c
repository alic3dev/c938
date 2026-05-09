#include <mesh/mesh_player.h>

#include <metil_mesh/metil_mesh.h>
#include <metil_player/metil_player_defaults.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

void mesh_player_initialize(
  struct metil_mesh* mesh,
  struct metil_player_defaults* metil_player_defaults
) {
  metil_mesh_initialize_with_lengths(
    mesh,
    0x0e,
    0x27
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

  mesh->vertices[
    0x00
  ].x = (
    0x00
  );

  mesh->vertices[
    0x00
  ].y = (
    metil_player_defaults->size.y
  );

  mesh->vertices[
    0x00
  ].z = (
    0x00
  );

  mesh->vertices[
    0x00
  ].w = (
    0x01
  );

  for (
    unsigned char index_vertex = (
      0x01
    );
    (
      index_vertex <
      mesh->length_vertices
    );
    ++index_vertex
  ) {
    float angle = (
      (float)
      (
        index_vertex -
        0x01
      ) /
      (float)
      (
        mesh->length_vertices -
        0x02
      ) *
      math_c_pi_doubled
    );

    mesh->vertices[
      index_vertex
    ].x = (
      math_c_cosine(
        angle,
        math_c_pi
      ) *
      metil_player_defaults->size.x
    );

    mesh->vertices[
      index_vertex
    ].y = (
      0x00
    );

    mesh->vertices[
      index_vertex
    ].z = (
      math_c_sine(
        angle,
        math_c_pi
      ) *
      metil_player_defaults->size.z
    );

    mesh->vertices[
      index_vertex
    ].w = (
      0x01
    );
  }

  for (
    unsigned char index_index = (
      0x00
    );
    (
      index_index <
      (
        mesh->length_indices /
        0x03
      )
    );
    ++index_index
  ) {
    mesh->indices[
      index_index *
      0x03
    ] = (
      0x00
    );

    mesh->indices[
      index_index *
      0x03 +
      0x01
    ] = (
      index_index
    );

    mesh->indices[
      index_index *
      0x03 +
      0x02
    ] = (
      index_index +
      0x01
    );
  }
}
