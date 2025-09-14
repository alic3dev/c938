#ifndef __mesh_ground_h
#define __mesh_ground_h

#include <mesh/mesh.h>

#include <clic3_vector.h>

#define length_vertices_ground_x 100
#define length_vertices_ground_y 100

extern const struct clic3_vector2_unsigned_int length_vertices_ground;

void mesh_ground_initialize(
  struct mesh*,
  float,
  float,
  float
);

#endif
