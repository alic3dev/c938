#include <mesh/mesh_building.h>

#include <metil_mesh/mesh.h>

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

  mesh->length_vertices = 8;
  mesh->length_indices = 36;

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

  mesh->vertices[0].x = -size_half.x;
  mesh->vertices[0].y = 0;
  mesh->vertices[0].z = -size_half.z;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = size_half.x;
  mesh->vertices[1].y = 0;
  mesh->vertices[1].z = -size_half.z;
  mesh->vertices[1].w = 1.0f;

  mesh->vertices[2].x = -size_half.x;
  mesh->vertices[2].y = 0;
  mesh->vertices[2].z = size_half.z;
  mesh->vertices[2].w = 1.0f;

  mesh->vertices[3].x = size_half.x;
  mesh->vertices[3].y = 0;
  mesh->vertices[3].z = size_half.z;
  mesh->vertices[3].w = 1.0f;

  mesh->vertices[4].x = -size_half.x;
  mesh->vertices[4].y = mesh->size.y;
  mesh->vertices[4].z = -size_half.z;
  mesh->vertices[4].w = 1.0f;

  mesh->vertices[5].x = size_half.x;
  mesh->vertices[5].y = mesh->size.y;
  mesh->vertices[5].z = -size_half.z;
  mesh->vertices[5].w = 1.0f;

  mesh->vertices[6].x = -size_half.x;
  mesh->vertices[6].y = mesh->size.y;
  mesh->vertices[6].z = size_half.z;
  mesh->vertices[6].w = 1.0f;

  mesh->vertices[7].x = size_half.x;
  mesh->vertices[7].y = mesh->size.y;
  mesh->vertices[7].z = size_half.z;
  mesh->vertices[7].w = 1.0f;

  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
  mesh->indices[2] = 2;

  mesh->indices[3] = 2;
  mesh->indices[4] = 3;
  mesh->indices[5] = 1;

  mesh->indices[6] = 1;
  mesh->indices[7] = 0;
  mesh->indices[8] = 4;

  mesh->indices[9] = 4;
  mesh->indices[10] = 5;
  mesh->indices[11] = 1;

  mesh->indices[12] = 1;
  mesh->indices[13] = 3;
  mesh->indices[14] = 5;

  mesh->indices[15] = 5;
  mesh->indices[16] = 7;
  mesh->indices[17] = 3;

  mesh->indices[18] = 3;
  mesh->indices[19] = 2;
  mesh->indices[20] = 7;

  mesh->indices[21] = 7;
  mesh->indices[22] = 6;
  mesh->indices[23] = 2;

  mesh->indices[24] = 2;
  mesh->indices[25] = 0;
  mesh->indices[26] = 4;

  mesh->indices[27] = 4;
  mesh->indices[28] = 2;
  mesh->indices[29] = 6;

  mesh->indices[30] = 6;
  mesh->indices[31] = 4;
  mesh->indices[32] = 5;

  mesh->indices[33] = 5;
  mesh->indices[34] = 6;
  mesh->indices[35] = 7;
}
