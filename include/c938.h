#ifndef __c938_h
#define __c938_h

#include <metil.h>

#if target_os_ios
extern char* _Nonnull c938_executable_path;
#endif

int main(
  int,
  #if target_os_ios
  char* _Nonnull * _Nonnull
  #else
  const char* _Nonnull * _Nonnull
  #endif
);

#if target_os_ios
void c938_view_controller_on_view_did_load();
#endif

void c938_renderer_on_initialize(
  struct metil* _Nonnull,
  void* _Nullable
);

void c938_on_scene_change(
  struct metil* _Nonnull,
  int id_scene,
  void* _Nullable
);

void c938_termination(
  void* _Nonnull
);

#endif
