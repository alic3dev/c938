#include <mesh/mesh_hud_item.h>

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

#include <stdlib.h>

void mesh_hud_item_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_initialize(mesh);

  mesh->size.x = 0.2f;
  mesh->size.y = 0.05f;
  mesh->size.z = 0.0f;

  mesh->length_vertices = 4;
  mesh->length_indices = 6;

  mesh->indices = realloc(
    mesh->indices,
    sizeof(unsigned int) *
    mesh->length_indices
  );

  mesh->vertices = realloc(
    mesh->vertices,
    sizeof(struct math_c_vector4_float) *
    mesh->length_vertices
  );

  // 2___3
  // |   |
  // 0___1

  mesh->vertices[0].x = 0.0f;
  mesh->vertices[0].y = 0.0f;
  mesh->vertices[0].z = 0.0f;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = mesh->size.x;
  mesh->vertices[1].y = 0.0f;
  mesh->vertices[1].z = 0.0f;
  mesh->vertices[1].w = 1.0f;

  mesh->vertices[2].x = 0.0f;
  mesh->vertices[2].y = mesh->size.y;
  mesh->vertices[2].z = 0.0f;
  mesh->vertices[2].w = 1.0f;

  mesh->vertices[3].x = mesh->size.x;
  mesh->vertices[3].y = mesh->size.y;
  mesh->vertices[3].z = 0.0f;
  mesh->vertices[3].w = 1.0f;

  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
  mesh->indices[2] = 2;

  mesh->indices[3] = 2;
  mesh->indices[4] = 3;
  mesh->indices[5] = 1;
}
