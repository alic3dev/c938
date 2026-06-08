#ifndef __c938_objects_object_projectile_h
#define __c938_objects_object_projectile_h

#include <data/projectile_data.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void object_projectile_initialize(
  struct metil_object* _Nonnull,
  id<MTLDevice> _Nonnull,
  id<MTLTexture> _Nonnull,
  struct math_c_vector3_float,
  struct math_c_vector3_float,
  unsigned long int,
  float
);

void object_projectile_travel(
  struct metil_object* _Nonnull metil_object,
  struct projectile_data* _Nonnull projectile_data
);

void object_projectile_poll(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif
