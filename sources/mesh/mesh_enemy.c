#include <metil_mesh/metil_mesh.h>

#include <metil_mesh/metil_mesh_box.h>

#include <clic3_vector.h>

#include <stdlib.h>

void mesh_enemy_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_box_initialize(
    mesh,
    (struct clic3_vector3_float) {
      .x = 30.0f,
      .y = 30.0f,
      .z = 30.0f
    }
  );

  return;

  mesh->size.x = 0.00000001f;
  mesh->size.y = 0.00000001f;
  mesh->size.z = 0.00000001f;

  mesh->length_vertices = 6;
  mesh->length_indices = 24;

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

  //
  //   .
  // . . .
  //
  //   .
  //

  mesh->vertices[0].x = 0.0f;
  mesh->vertices[0].y = 0.0f;
  mesh->vertices[0].z = -10.0f;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = 1.0f;
  mesh->vertices[1].y = 0.0f;
  mesh->vertices[1].z = 0.0f;
  mesh->vertices[1].w = 1.0f;

  mesh->vertices[2].x = -1.0f;
  mesh->vertices[2].y = 0.0f;
  mesh->vertices[2].z = 0.0f;
  mesh->vertices[2].w = 1.0f;

  mesh->vertices[3].x = 0.0f;
  mesh->vertices[3].y = 1.0f;
  mesh->vertices[3].z = 0.0f;
  mesh->vertices[3].w = 1.0f;

  mesh->vertices[4].x = 0.0f;
  mesh->vertices[4].y = -1.0f;
  mesh->vertices[4].z = 0.0f;
  mesh->vertices[4].w = 1.0f;

  mesh->vertices[5].x = 0.0f;
  mesh->vertices[5].y = 0.0f;
  mesh->vertices[5].z = 1.0f;
  mesh->vertices[5].w = 1.0f;

  mesh->indices[0] = 1;
  mesh->indices[1] = 0;
  mesh->indices[2] = 3;

  mesh->indices[3] = 3;
  mesh->indices[4] = 0;
  mesh->indices[5] = 2;

  mesh->indices[6] = 2;
  mesh->indices[7] = 0;
  mesh->indices[8] = 4;

  mesh->indices[9] = 4;
  mesh->indices[10] = 0;
  mesh->indices[11] = 1;

  mesh->indices[12] = 1;
  mesh->indices[13] = 5;
  mesh->indices[14] = 3;

  mesh->indices[15] = 3;
  mesh->indices[16] = 5;
  mesh->indices[17] = 2;

  mesh->indices[18] = 2;
  mesh->indices[19] = 5;
  mesh->indices[20] = 4;

  mesh->indices[21] = 4;
  mesh->indices[22] = 5;
  mesh->indices[23] = 1;
}
