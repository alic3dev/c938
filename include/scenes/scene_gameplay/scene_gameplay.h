#ifndef __scenes_scene_gameplay_scene_gameplay_h
#define __scenes_scene_gameplay_scene_gameplay_h

#include <data/parameters_gameplay.h>
#include <data/scene_gameplay_data.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

#define scene_gameplay_length_renderables 9

enum scene_gameplay_renderables_index {
  scene_gameplay_renderables_index_buildings = 0,
  scene_gameplay_renderables_index_group_players = 1,
  scene_gameplay_renderables_index_projectiles = 2,
  scene_gameplay_renderables_index_enemies = 3,
  scene_gameplay_renderables_index_hud_boosted = 4,
  scene_gameplay_renderables_index_hud_jumping = 5,
  scene_gameplay_renderables_index_hud_jumping_secondary = 6,
  scene_gameplay_renderables_index_crosshair = 7,
  scene_gameplay_renderables_index_group_logging = 8
};

enum scene_gameplay_renderables_index_range {
  scene_gameplay_renderables_index_range_hud_start = 4,
  scene_gameplay_renderables_index_range_hud_end = 6
};

enum scene_gameplay_group_buildings_index {
  scene_gameplay_group_buildings_index_starting = 1,
  scene_gameplay_group_buildings_index_target = 3
};

enum scene_gameplay_textures {
  scene_gameplay_textures_index_player = 0,
  scene_gameplay_textures_index_buildings = 0
};

void scene_gameplay_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_gameplay_network_client_notification_on(
  char* _Nonnull,
  unsigned char,
  void* _Nonnull
);

void scene_gameplay_network_host_notification_on(
  char* _Nonnull,
  unsigned char,
  void* _Nonnull
);

void scene_gameplay_populate(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char
);

void scene_gameplay_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_gameplay_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

float scene_gameplay_io_proc_value_get(
  struct scene_gameplay_data* _Nonnull,
  unsigned long int,
  unsigned long int,
  unsigned long int
);

#if target_os_ios
int scene_gameplay_io_proc(
  unsigned char,
  const AudioTimeStamp* _Nonnull,
  unsigned int,
  AudioBufferList* _Nonnull,
  void* _Nonnull
);
#else
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
