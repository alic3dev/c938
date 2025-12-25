#include <mesh/mesh_hud_item.h>

#include <metil_mesh/mesh.h>

#include <clic3_vector.h>

#include <stdlib.h>

void mesh_projectile_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_initialize(
    mesh
  );

  mesh->size.x = 0.00000001f;
  mesh->size.y = 0.00000001f;
  mesh->size.z = 0.00000001f;

  mesh->length_vertices = 2;
  mesh->length_indices = 2;

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

  mesh->vertices[0].x = 0.0f;
  mesh->vertices[0].y = 0.0f;
  mesh->vertices[0].z = 0.0f;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = 0.0f;
  mesh->vertices[1].y = 0.0f;
  mesh->vertices[1].z = 100000.0f;
  mesh->vertices[1].w = 1.0f;

  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
}
