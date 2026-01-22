#ifndef __c938_mesh_mesh_building_h
#define __c938_mesh_mesh_building_h

#include <metil_mesh/metil_mesh.h>

void mesh_building_initialize(
  struct metil_mesh*,
  float,
  float,
  float
);

void mesh_building_height_set(
  struct metil_mesh*,
  float
);

#endif
