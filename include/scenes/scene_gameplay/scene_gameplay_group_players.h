#ifndef __c938_scenes_scene_gameplay_scene_gameplay_group_players_h
#define __c938_scenes_scene_gameplay_scene_gameplay_group_players_h

#include <metil.h>
#include <metil_group.h>

#include <Metal/MTLTexture.h>

void scene_gameplay_group_players_resize(
  struct metil* _Nonnull,
  struct metil_group* _Nonnull,
  unsigned int,
  id<MTLTexture> _Nonnull
);

#endif
