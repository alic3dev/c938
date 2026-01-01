#ifndef __mesh_player_h
#define __mesh_player_h

#include <metil_mesh/metil_mesh.h>
#include <metil_player/metil_player_defaults.h>

#include <clic3_vector.h>

extern const struct clic3_vector3_float mesh_player_size;
extern const struct clic3_vector3_float mesh_player_size_half;

void mesh_player_initialize(
  struct metil_mesh*,
  struct metil_player_defaults*
);

#endif
