#include <mesh/mesh_hud_item.h>

#include <metil_mesh/metil_mesh.h>

void mesh_hud_item_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_initialize_with_lengths(
    mesh,
    0x04,
    0x08
  );

  mesh->size.x = (
    0.2f
  );

  mesh->size.y = (
    0.05f
  );

  mesh->size.z = (
    0x00
  );

  mesh->vertices[0].x = 0x00;
  mesh->vertices[0].y = 0x00;
  mesh->vertices[0].z = 0x00;
  mesh->vertices[0].w = 0x01;

  mesh->vertices[1].x = mesh->size.x;
  mesh->vertices[1].y = 0x00;
  mesh->vertices[1].z = 0x00;
  mesh->vertices[1].w = 0x01;

  mesh->vertices[2].x = mesh->size.x;
  mesh->vertices[2].y = mesh->size.y;
  mesh->vertices[2].z = 0x00;
  mesh->vertices[2].w = 0x01;

  mesh->vertices[3].x = 0x00;
  mesh->vertices[3].y = mesh->size.y;
  mesh->vertices[3].z = 0x00;
  mesh->vertices[3].w = 0x01;

  mesh->indices[0] = 0x00;
  mesh->indices[1] = 0x01;
  mesh->indices[2] = 0x01;
  mesh->indices[3] = 0x02;
  mesh->indices[4] = 0x02;
  mesh->indices[5] = 0x03;
  mesh->indices[6] = 0x03;
  mesh->indices[7] = 0x00;
}
