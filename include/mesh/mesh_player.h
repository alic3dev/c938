#ifndef __c938_mesh_mesh_player_h
#define __c938_mesh_mesh_player_h

#include <metil_mesh/metil_mesh.h>
#include <metil_player/metil_player_defaults.h>

#include <math_c_vector.h>

extern const struct math_c_vector3_float mesh_player_size;
extern const struct math_c_vector3_float mesh_player_size_half;

void mesh_player_initialize(
  struct metil_mesh*,
  struct metil_player_defaults*
);

#endif
