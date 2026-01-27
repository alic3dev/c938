#ifndef __c938_network_data_network_data_map_h
#define __c938_network_data_network_data_map_h

#include <network/data/network_data_map.h>
#include <data/parameters_gameplay.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>

#include <Metal/MTLTexture.h>

void network_data_map_set(
  struct network_data_map* _Nonnull,
  struct parameters_gameplay* _Nonnull,
  struct metil_group* _Nonnull,
  struct metil_group* _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  unsigned int
);

void network_data_map_parse(
  struct metil* _Nonnull,
  struct network_data_map* _Nonnull,
  struct parameters_gameplay* _Nonnull,
  struct metil_group* _Nonnull,
  struct metil_group* _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  unsigned int* _Nonnull,
  id<MTLTexture> _Nonnull
);

#endif
