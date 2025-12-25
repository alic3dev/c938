#ifndef __scenes_scene_gameplay_h
#define __scenes_scene_gameplay_h

#include <metil_menus/menu.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/scene.h>

#if !target_os_ios
#include <CoreAudio/CoreAudio.h>
#endif

#define scene_gameplay_length_buildings_default 200

enum scene_gameplay_renderables_index {
  scene_gameplay_renderables_index_buildings = 0,
  scene_gameplay_renderables_index_player = 1,
  scene_gameplay_renderables_index_projectiles = 2,
  scene_gameplay_renderables_index_hud_boosted = 3,
  scene_gameplay_renderables_index_hud_jumping = 4,
  scene_gameplay_renderables_index_hud_jumping_secondary = 5,
  scene_gameplay_renderables_index_crosshair = 6
};

enum scene_gameplay_renderables_index_range {
  scene_gameplay_renderables_index_range_hud_start = 3,
  scene_gameplay_renderables_index_range_hud_end = 5
};

enum scene_gameplay_group_buildings_index {
  scene_gameplay_group_buildings_index_starting = 1,
  scene_gameplay_group_buildings_index_target = 3
};

enum scene_gameplay_textures {
  scene_gameplay_textures_index_player = 0,
  scene_gameplay_textures_index_buildings = 0
};

struct scene_gameplay_data {
  struct metil_menu menu;
  unsigned char visible_menu;
};

void scene_gameplay_initialize(
  struct metil_scene* _Nonnull,
  struct metil_renderer_interface* _Nonnull
);

void scene_gameplay_populate(
  struct metil_scene* _Nonnull,
  unsigned short int
);

void scene_gameplay_poll(
  struct metil_scene* _Nonnull
);

void scene_gameplay_destroy(
  struct metil_scene* _Nonnull
);

#if !target_os_ios
OSStatus scene_gameplay_io_proc(
  AudioObjectID,
  const AudioTimeStamp* _Nonnull,
  const AudioBufferList* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  AudioBufferList* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  void* _Nonnull
);
#endif

#endif
