#include <mesh/mesh_hud_item.h>

#include <metil_mesh/metil_mesh.h>

void mesh_crosshair_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_initialize_with_lengths(
    mesh,
    0x04,
    0x04
  );

  mesh->size.x = 0.02f;
  mesh->size.y = 0.02f;
  mesh->size.z = 0.0f;

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
