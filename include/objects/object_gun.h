#ifndef __c938_objects_object_gun_h
#define __c938_objects_object_gun_h

#include <metil.h>
#include <metil_object.h>

#include <Metal/MTLTexture.h>

void c938_object_gun_initialize(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  unsigned char,
  id<MTLTexture> _Nonnull
);

void c938_object_gun_poll(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void c938_object_gun_destroy(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull
);

#endif
