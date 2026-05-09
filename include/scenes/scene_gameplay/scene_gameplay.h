#ifndef __c938_scenes_scene_gameplay_scene_gameplay_h
#define __c938_scenes_scene_gameplay_scene_gameplay_h

#include <data/parameters_gameplay.h>
#include <data/scene_gameplay_data.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

#define scene_gameplay_length_renderables 0x0a

enum scene_gameplay_renderables_index {
  scene_gameplay_renderables_index_buildings             = 0x00,
  scene_gameplay_renderables_index_group_players         = 0x01,
  scene_gameplay_renderables_index_projectiles           = 0x02,
  scene_gameplay_renderables_index_enemies               = 0x03,
  scene_gameplay_renderables_index_hud_boosted           = 0x04,
  scene_gameplay_renderables_index_hud_jumping           = 0x05,
  scene_gameplay_renderables_index_hud_jumping_secondary = 0x06,
  scene_gameplay_renderables_index_group_hud_health      = 0x07,
  scene_gameplay_renderables_index_crosshair             = 0x08,
  scene_gameplay_renderables_index_group_logging         = 0x09
};

enum scene_gameplay_renderables_index_range {
  scene_gameplay_renderables_index_range_hud_start = 0x04,
  scene_gameplay_renderables_index_range_hud_end   = 0x06
};

enum scene_gameplay_group_buildings_index {
  scene_gameplay_group_buildings_index_starting = 0x01,
  scene_gameplay_group_buildings_index_target   = 0x03
};

enum scene_gameplay_textures {
  scene_gameplay_textures_index_player = 0x00,
  scene_gameplay_textures_index_buildings = 0x00
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

#endif
