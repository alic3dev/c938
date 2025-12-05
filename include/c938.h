#ifndef __c938_h
#define __c938_h

#include <metil_rendering/metil_renderer_interface.h>

int main(
  int,
  #if target_os_ios
  char* _Nonnull * _Nonnull
  #else
  const char* _Nonnull * _Nonnull
  #endif
);

void c938_renderer_on_initialize(
  struct metil_renderer_interface* _Nonnull,
  void* _Nullable
);

void c938_on_scene_change(
  int,
  void* _Nonnull
);

#endif
