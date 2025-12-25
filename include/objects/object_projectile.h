#ifndef __object_projectile_h
#define __object_projectile_h

#include <clic3_vector.h>

#include <metil_object.h>

#include <Metal/MTLDevice.h>

void object_projectile_initialize(
  struct metil_object* _Nonnull,
  id<MTLDevice> _Nonnull,
  struct clic3_vector3_float,
  struct clic3_vector3_float
);

void object_projectile_poll(
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif
