#include <mesh/ground/mesh_ground.h>

#include <metil_mesh/mesh.h>

#include <clic3.h>

#include <stdlib.h>
#include <stdio.h>

const struct clic3_vector2_unsigned_int mesh_ground_length_vertices = {
  .x = length_vertices_ground_x,
  .y = length_vertices_ground_y
};

void mesh_ground_initialize(
  struct metil_mesh* mesh,
  float width,
  float height,
  float depth
) {
  metil_mesh_initialize(mesh);

  mesh->size.x = width;
  mesh->size.y = height;
  mesh->size.z = depth;

  mesh->length_vertices = (
    mesh_ground_length_vertices.x *
    mesh_ground_length_vertices.y
  );

  mesh->length_indices = (
    (mesh_ground_length_vertices.x - 1) *
    (mesh_ground_length_vertices.y - 1) *
    6
  );

  mesh->vertices = realloc(
    mesh->vertices,
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );

  mesh->indices = realloc(
    mesh->indices,
    sizeof(unsigned int) *
    mesh->length_indices
  );

  const struct clic3_vector2_float increment_ground = {
    .x = width / (float)(mesh_ground_length_vertices.x),
    .y = depth / (float)(mesh_ground_length_vertices.y)
  };

  unsigned int index_vertex_ground = 0;
  for (
    unsigned int index_x = 0;
    index_x < mesh_ground_length_vertices.x;
    ++index_x
  ) {
    for (
      unsigned int index_z = 0;
      index_z < mesh_ground_length_vertices.y;
      ++index_z
    ) {
      mesh->vertices[index_vertex_ground].x = (
        index_x * increment_ground.x
      ) - (mesh->size.x / 2.0f);

      mesh->vertices[index_vertex_ground].z = (
        index_z * increment_ground.y
      ) - (mesh->size.z / 2.0f);

      mesh->vertices[index_vertex_ground].y = (float)(rand() % 1000) / 1000.0f * 4.0f - 2.0f;
      mesh->vertices[index_vertex_ground].w = 1.0f;

      index_vertex_ground = (
        index_vertex_ground + 1
      );
    }
  }

  unsigned int index_index_ground = 0;
  for (
    unsigned char index_x = 0;
    index_x < mesh_ground_length_vertices.x - 1;
    ++index_x
  ) {
    for (
      unsigned char index_z = 0;
      index_z < mesh_ground_length_vertices.y - 1;
      ++index_z
    ) {
      mesh->indices[index_index_ground] = (
        index_x * mesh_ground_length_vertices.y + (
          index_z
        )
      );

      index_index_ground = (
        index_index_ground + 1
      );

      mesh->indices[index_index_ground] = (
        index_x * mesh_ground_length_vertices.y + (
          index_z + 1
        )
      );

      index_index_ground = (
        index_index_ground + 1
      );

      mesh->indices[index_index_ground] = (
        (index_x + 1) * mesh_ground_length_vertices.y + (
          index_z
        )
      );

      index_index_ground = (
        index_index_ground + 1
      );

      mesh->indices[index_index_ground] = (
        index_x * mesh_ground_length_vertices.y + (
          index_z + 1
        )
      );

      index_index_ground = (
        index_index_ground + 1
      );

      mesh->indices[index_index_ground] = (
        (index_x + 1) * mesh_ground_length_vertices.y + (
          index_z
        )
      );

      index_index_ground = (
        index_index_ground + 1
      );

      mesh->indices[index_index_ground] = (
        (index_x + 1) * mesh_ground_length_vertices.y + (
          index_z + 1
        )
      );

      index_index_ground = (
        index_index_ground + 1
      );
    }
  }
}
