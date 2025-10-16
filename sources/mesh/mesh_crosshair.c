#include <mesh/mesh_hud_item.h>

#include <metil_mesh/mesh.h>

#include <clic3_vector.h>

#include <stdlib.h>

void mesh_crosshair_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_initialize(mesh);

  mesh->positioning = metil_mesh_positioning_static;

  mesh->size.x = 0.02f;
  mesh->size.y = 0.02f;
  mesh->size.z = 0.0f;

  mesh->length_vertices = 4;
  mesh->length_indices = 4;

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

  //     0
  //     |
  // 2 --+-- 3
  //     |
  //     1

  mesh->vertices[0].x = 0.0f;
  mesh->vertices[0].y = 0.01f;
  mesh->vertices[0].z = 0.0f;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = 0.0f;
  mesh->vertices[1].y = -0.01f;
  mesh->vertices[1].z = 0.0f;
  mesh->vertices[1].w = 1.0f;

  mesh->vertices[2].x = -0.01f;
  mesh->vertices[2].y = 0.0f;
  mesh->vertices[2].z = 0.0f;
  mesh->vertices[2].w = 1.0f;

  mesh->vertices[3].x = 0.01f;
  mesh->vertices[3].y = 0.0f;
  mesh->vertices[3].z = 0.0f;
  mesh->vertices[3].w = 1.0f;

  mesh->indices[0] = 0;
  mesh->indices[2] = 2;
  mesh->indices[1] = 1;
  mesh->indices[3] = 3;
}
  