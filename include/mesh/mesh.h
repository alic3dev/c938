#ifndef __mesh_h
#define __mesh_h

#include <clic3_vector.h>

enum mesh_positioning {
  mesh_positioning_normal = 0,
  mesh_positioning_player = 1,
  mesh_positioning_static = 2
};

struct mesh {
  unsigned int* indices;
  struct clic3_vector4_float* vertices;
  struct clic3_vector3_float size;

  unsigned int length_indices;
  unsigned int length_vertices;

  enum mesh_positioning positioning;

  void* data;
};

void mesh_initialize(
  struct mesh*
);

void mesh_destroy(
  struct mesh*
);

#endif
