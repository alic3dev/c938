#ifndef __object_enemy_h
#define __object_enemy_h

#include <data/enemy_data.h>

#include <clic3_vector.h>

#include <metil.h>
#include <metil_object.h>

#include <Metal/MTLDevice.h>

void object_enemy_initialize(
  struct metil_object* _Nonnull,
  id<MTLDevice> _Nonnull,
  struct clic3_vector3_float,
  unsigned char
);

void object_enemy_travel(
  struct metil_object* _Nonnull,
  struct clic3_vector3_float* _Nonnull,
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
