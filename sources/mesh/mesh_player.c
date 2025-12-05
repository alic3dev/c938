#include <mesh/mesh_player.h>

#include <metil_mesh/mesh.h>
#include <metil_player.h>

#include <clic3_vector.h>

#include <math.h>
#include <stdlib.h>

const struct clic3_vector3_float mesh_player_size = {
  .x = __metil_player_size_default_x,
  .y = __metil_player_size_default_y * 13.0f / 16.0f,
  .z = __metil_player_size_default_z
};

void mesh_player_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_initialize(mesh);

  mesh->size.x = mesh_player_size.x;
  mesh->size.y = mesh_player_size.y;
  mesh->size.z = mesh_player_size.z;

  mesh->length_vertices = 14;
  mesh->length_indices = (
    (mesh->length_vertices - 1) * 3
  );

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

  mesh->vertices[0].x = 0;
  mesh->vertices[0].y = mesh_player_size.y;
  mesh->vertices[0].z = 0;
  mesh->vertices[0].w = 1.0f;

  for (
    unsigned char index_vertex = 1;
    index_vertex < mesh->length_vertices;
    ++index_vertex
  ) {
    float angle = (
      ((float) (index_vertex - 1)) /
      ((float) (mesh->length_vertices - 2)) *
      M_PI * 2.0f
    );
    
    mesh->vertices[index_vertex].x = cos(angle) * mesh_player_size.x;
    mesh->vertices[index_vertex].y = 0;
    mesh->vertices[index_vertex].z = sin(angle) * mesh_player_size.z;
    mesh->vertices[index_vertex].w = 1.0f;
  }

  for (
    unsigned char index_index = 0;
    index_index < mesh->length_indices / 3;
    ++index_index
  ) {
    mesh->indices[index_index * 3] = 0;
    mesh->indices[index_index * 3 + 1] = index_index;
    mesh->indices[index_index * 3 + 2] = index_index + 1;
  }
}
