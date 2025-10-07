#ifndef __c938_h
#define __c938_h

#include <metil_rendering/rendering_properties.h>

#include <Metal/MTLDevice.h>

int main(
  int,
  const char* _Nonnull * _Nonnull
);

void c938_renderer_on_initialize(
  _Nonnull id<MTLDevice>,
  struct metil_rendering_properties* _Nonnull,
  void* _Nullable
);

void c938_on_scene_change(
  int,
  void* _Nonnull
);

#endif
