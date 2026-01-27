#ifndef __c938_objects_object_player_h
#define __c938_objects_object_player_h

#include <metil.h>
#include <metil_object/metil_object.h>

#include <Metal/MTLTexture.h>

void object_player_initialize(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  id<MTLTexture> _Nonnull,
  unsigned char
);

#endif
