#include <mesh/mesh_text.h>

#include <mesh/mesh.h>

#include <clic3_vector.h>

#include <stdlib.h>
#include <stdio.h>

void mesh_text_initialize(
  struct mesh* mesh,
  float width,
  float height,
  float scale
) {
  mesh_initialize(mesh);

  mesh->positioning = mesh_positioning_static;

  mesh->size.x = width * scale;
  mesh->size.y = height * scale;
  mesh->size.z = 1.0f;

  mesh->length_vertices = (
    4
  );

  mesh->length_indices = (
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

  float width_half = width / 2.0f * scale;
  float height_half = height / 2.0f * scale;

  mesh->vertices[0].x = -width_half;
  mesh->vertices[0].y = -height_half;
  mesh->vertices[0].z = 0;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = width_half;
  mesh->vertices[1].y = -height_half;
  mesh->vertices[1].z = 0;
  mesh->vertices[1].w = 1.0f;

  mesh->vertices[2].x = width_half;
  mesh->vertices[2].y = height_half;
  mesh->vertices[2].z = 0;
  mesh->vertices[2].w = 1.0f;

  mesh->vertices[3].x = -width_half;
  mesh->vertices[3].y = height_half;
  mesh->vertices[3].z = 0;
  mesh->vertices[3].w = 1.0f;

  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
  mesh->indices[2] = 3;
  mesh->indices[3] = 2;
  mesh->indices[4] = 1;
  mesh->indices[5] = 3;
}
