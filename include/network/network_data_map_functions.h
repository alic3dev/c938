#ifndef __network_network_data_map_h
#define __network_network_data_map_h

#include <data/network_data_map.h>
#include <data/parameters_gameplay.h>

#include <math_c_vector.h>

#include <metil_group.h>
#include <metil_object/metil_object.h>

void network_data_map_set(
  struct network_data_map* _Nonnull,
  struct parameters_gameplay* _Nonnull,
  struct metil_group* _Nonnull,
  struct metil_group* _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  unsigned int
);

#endif
