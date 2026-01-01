#include <mesh/mesh_building.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_vector.h>

#include <stdlib.h>

void mesh_building_initialize(
  struct metil_mesh* mesh,
  float width,
  float height,
  float depth
) {
  metil_mesh_initialize(mesh);

  struct clic3_vector3_float size_half = {
    .x = width / 2.0f,
    .y = height / 2.0f,
    .z = depth / 2.0f
  };

  mesh->size.x = width;
  mesh->size.y = height;
  mesh->size.z = depth;

  unsigned char layers = 2;

  mesh->length_vertices = 4 * layers;

  mesh->length_indices = (
    (layers - 1) * 24
  ) + 12;

  mesh->indices = realloc(
    mesh->indices,
    sizeof(unsigned int) *
    mesh->length_indices
  );

  mesh->vertices = realloc(
    mesh->vertices,
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );

  //   6----7
  // 4/___5/|
  // |    | |
  // | 2__|_3
  // 0/___1/

  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
  mesh->indices[2] = 2;

  mesh->indices[3] = 2;
  mesh->indices[4] = 3;
  mesh->indices[5] = 1;

  for (
    unsigned short int index_layer = 0;
    index_layer < layers;
    ++index_layer
  ) {
    unsigned short int index_vertex = (
      index_layer * 4
    );

    float position_y = (
      (float) index_layer /
      (float) (layers - 1)
    ) * mesh->size.y;

    mesh->vertices[index_vertex].x = -size_half.x;
    mesh->vertices[index_vertex].y = position_y;
    mesh->vertices[index_vertex].z = -size_half.z;
    mesh->vertices[index_vertex].w = 1.0f;

    mesh->vertices[index_vertex + 1].x = size_half.x;
    mesh->vertices[index_vertex + 1].y = position_y;
    mesh->vertices[index_vertex + 1].z = -size_half.z;
    mesh->vertices[index_vertex + 1].w = 1.0f;

    mesh->vertices[index_vertex + 2].x = -size_half.x;
    mesh->vertices[index_vertex + 2].y = position_y;
    mesh->vertices[index_vertex + 2].z = size_half.z;
    mesh->vertices[index_vertex + 2].w = 1.0f;

    mesh->vertices[index_vertex + 3].x = size_half.x;
    mesh->vertices[index_vertex + 3].y = position_y;
    mesh->vertices[index_vertex + 3].z = size_half.z;
    mesh->vertices[index_vertex + 3].w = 1.0f;

    if (
      index_layer < layers - 1
    ) {
      unsigned short int offset_index_index = (
        index_layer * 24
      ) + 6;

      mesh->indices[
        offset_index_index
      ] = index_vertex;

      mesh->indices[
        offset_index_index + 1
      ] = index_vertex + 1;

      mesh->indices[
        offset_index_index + 2
      ] = index_vertex + 4;

      mesh->indices[
        offset_index_index + 3
      ] = index_vertex + 4;

      mesh->indices[
        offset_index_index + 4
      ] = index_vertex + 5;

      mesh->indices[
        offset_index_index + 5
      ] = index_vertex + 1;

      mesh->indices[
        offset_index_index + 6
      ] = index_vertex + 1;

      mesh->indices[
        offset_index_index + 7
      ] = index_vertex + 3;

      mesh->indices[
        offset_index_index + 8
      ] = index_vertex + 5;

      mesh->indices[
        offset_index_index + 9
      ] = index_vertex + 5;

      mesh->indices[
        offset_index_index + 10
      ] = index_vertex + 7;

      mesh->indices[
        offset_index_index + 11
      ] = index_vertex + 3;

      mesh->indices[
        offset_index_index + 12
      ] = index_vertex + 3;

      mesh->indices[
        offset_index_index + 13
      ] = index_vertex + 2;

      mesh->indices[
        offset_index_index + 14
      ] = index_vertex + 7;

      mesh->indices[
        offset_index_index + 15
      ] = index_vertex + 7;

      mesh->indices[
        offset_index_index + 16
      ] = index_vertex + 6;

      mesh->indices[
        offset_index_index + 17
      ] = index_vertex + 2;

      mesh->indices[
        offset_index_index + 18
      ] = index_vertex + 2;

      mesh->indices[
        offset_index_index + 19
      ] = index_vertex;

      mesh->indices[
        offset_index_index + 20
      ] = index_vertex + 6;

      mesh->indices[
        offset_index_index + 21
      ] = index_vertex + 6;

      mesh->indices[
        offset_index_index + 22
      ] = index_vertex + 4;

      mesh->indices[
        offset_index_index + 23
      ] = index_vertex;
    }
  }

  mesh->indices[
    mesh->length_indices - 6
  ] = (
    mesh->length_vertices - 2
  );

  mesh->indices[
    mesh->length_indices - 5
  ] = (
    mesh->length_vertices - 4
  );
  mesh->indices[
    mesh->length_indices - 4
  ] = (
    mesh->length_vertices - 3
  );

  mesh->indices[
    mesh->length_indices - 3
  ] = (
    mesh->length_vertices - 3
  );
  mesh->indices[
    mesh->length_indices - 2
  ] = (
    mesh->length_vertices - 2
  );
  mesh->indices[
    mesh->length_indices - 1
  ] = (
    mesh->length_vertices - 1
  );
}
