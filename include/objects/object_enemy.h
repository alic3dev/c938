#ifndef __object_enemy_h
#define __object_enemy_h

#include <data/enemy_data.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_object.h>

#include <Metal/MTLDevice.h>

#define enemy_distance_speed_boost 400.0f
#define enemy_distance_speed_boost_half (enemy_distance_speed_boost / 2.0f)

void object_enemy_initialize(
  struct metil_object* _Nonnull,
  id<MTLDevice> _Nonnull,
  struct math_c_vector3_float,
  unsigned char,
  float
);

void object_enemy_travel(
  struct metil_object* _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  struct enemy_data* _Nonnull,
  unsigned long int* _Nonnull,
  float
);

void object_enemy_poll(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif
