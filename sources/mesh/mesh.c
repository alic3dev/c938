#include <mesh/mesh.h>

#include <clic3.h>

#include <stdlib.h>

void mesh_initialize(
  struct mesh* mesh
) {
  mesh->length_indices = 0;
  mesh->length_vertices = 0;

  mesh->size.x = 0.0f;
  mesh->size.y = 0.0f;
  mesh->size.z = 0.0f;

  mesh->indices = malloc(
    sizeof(unsigned int) *
    mesh->length_indices
  );

  mesh->vertices = malloc(
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );

  mesh->positioning = mesh_positioning_normal;

  mesh->data = (void*)0;
}

void mesh_destroy(
  struct mesh* mesh
) {
  free(mesh->indices);
  free(mesh->vertices);
}
