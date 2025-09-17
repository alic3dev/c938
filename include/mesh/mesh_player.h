#ifndef __mesh_player_h
#define __mesh_player_h

#include <metil_mesh/mesh.h>

#include <clic3_vector.h>

extern const struct clic3_vector3_float mesh_player_size;
extern const struct clic3_vector3_float mesh_player_size_half;

void mesh_player_initialize(
  struct metil_mesh*
);

#endif
