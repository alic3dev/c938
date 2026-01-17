#ifndef __scenes_scene_menu_main_h
#define __scenes_scene_menu_main_h

#include <data/parameters_gameplay.h>
#include <menus/menu_main.h>
#include <menus/menu_main_custom.h>
#include <menus/menu_main_network.h>
#include <network/network_host.h>

#include <metil.h>
#include <metil_object.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

#define scene_menu_main_length_buildings_default 200
#define scene_menu_main_time_scene_transition 333

#define scene_menu_main_length_renderables 9

#define scene_menu_main_length_group_renderables_text_main menus_menu_main_length
#define scene_menu_main_length_group_renderables_text_main_backing scene_menu_main_length_group_renderables_text_main

#define scene_menu_main_length_group_renderables_text_menu_custom 10
#define scene_menu_main_length_group_renderables_text_menu_custom_backing scene_menu_main_length_group_renderables_text_menu_custom

#define scene_menu_main_length_group_renderables_text_menu_network menus_menu_main_network_length
#define scene_menu_main_length_group_renderables_text_menu_network_backing scene_menu_main_length_group_renderables_text_menu_network

enum scene_menu_main_renderables_index {
  scene_menu_main_renderables_index_group_buildings = 0,
  scene_menu_main_renderables_index_text_title = 1,
  scene_menu_main_renderables_index_group_text_menu_main_backing = 2,
  scene_menu_main_renderables_index_group_text_menu_main = 3,
  scene_menu_main_renderables_index_group_text_menu_custom_backing = 4,
  scene_menu_main_renderables_index_group_text_menu_custom = 5,
  scene_menu_main_renderables_index_group_text_menu_network_backing = 6,
  scene_menu_main_renderables_index_group_text_menu_network = 7,
  scene_menu_main_renderables_index_group_logging = 8
};

enum scene_menu_main_renderables_group_text_main_index {
  scene_menu_main_renderables_group_text_main_index_menu_start = (
    menus_menu_main_index_start
  ),
  scene_menu_main_renderables_group_text_main_index_menu_custom = (
    menus_menu_main_index_custom
  ),
  scene_menu_main_renderables_group_text_main_index_menu_network = (
    menus_menu_main_index_network
  ),
  scene_menu_main_renderables_group_text_main_index_menu_exit = (
    menus_menu_main_index_exit
  )
};

enum scene_menu_main_renderables_group_text_menu_custom_index {
  scene_menu_main_renderables_group_text_menu_custom_index_start = 0,
  scene_menu_main_renderables_group_text_menu_custom_index_mode_target = 1,
  scene_menu_main_renderables_group_text_menu_custom_index_mode_enemies = 2,
  scene_menu_main_renderables_group_text_menu_custom_index_length_buildings = 3,
  scene_menu_main_renderables_group_text_menu_custom_index_multiplier_buildings = 4,
  scene_menu_main_renderables_group_text_menu_custom_index_length_enemies = 5,
  scene_menu_main_renderables_group_text_menu_custom_index_multiplier_enemies = 6,
  scene_menu_main_renderables_group_text_menu_custom_index_speed_movement = 7,
  scene_menu_main_renderables_group_text_menu_custom_index_multiplier_speed_movement = 8,
  scene_menu_main_renderables_group_text_menu_custom_index_menu_back = 9
};

enum scene_menu_main_renderables_group_text_main_network_index {
  scene_menu_main_renderables_group_text_main_index_menu_network_host = (
    menus_menu_main_network_index_host
  ),
  scene_menu_main_renderables_group_text_main_index_menu_network_join = (
    menus_menu_main_network_index_join
  ),
  scene_menu_main_renderables_group_text_main_index_menu_network_back = (
    menus_menu_main_network_index_back
  )
};

#define scene_menu_main_length_textures 2

enum scene_menu_main_textures_index {
  scene_menu_main_textures_index_title = 0,
  scene_menu_main_textures_index_buildings = 1,
  scene_menu_main_textures_index_text_backing = 1
};

void scene_menu_main_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_poll_custom_menu_item(
  struct metil* _Nonnull,
  struct parameters_gameplay* _Nonnull,
  struct metil_object* _Nonnull,
  struct metil_object* _Nonnull,
  struct metil_menu* _Nonnull,
  unsigned char,
  unsigned char
);

void scene_menu_main_poll_input(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void network_host_notification(
  char* _Nonnull,
  void* _Nullable,
  enum network_host_notification_type
);

#if target_os_ios
int scene_menu_main_io_proc(
  unsigned char,
  const AudioTimeStamp* _Nonnull,
  unsigned int,
  AudioBufferList* _Nonnull,
  void* _Nonnull
);
#else
OSStatus scene_menu_main_io_proc(
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
