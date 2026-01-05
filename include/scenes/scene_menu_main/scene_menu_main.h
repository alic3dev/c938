#ifndef __scenes_scene_menu_main_h
#define __scenes_scene_menu_main_h

#include <metil.h>
#include <metil_menus/metil_menu.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

#define scene_menu_main_length_buildings_default 200
#define scene_menu_main_time_scene_transition 333

#define scene_menu_main_length_renderables 4

enum scene_menu_main_renderables_index {
  scene_menu_main_renderables_index_buildings = 0,
  scene_menu_main_renderables_index_text_title = 1,
  scene_menu_main_renderables_index_menu_enter = 2,
  scene_menu_main_renderables_index_menu_exit = 3
};

#define scene_menu_main_length_textures 4

enum scene_menu_main_textures_index {
  scene_menu_main_textures_index_title = 0,
  scene_menu_main_textures_index_menu_enter = 1,
  scene_menu_main_textures_index_menu_exit = 2,
  scene_menu_main_textures_index_buildings = 3
};

struct scene_menu_main_data {
  struct metil_menu menu;
  unsigned long int time_started;
  float angle;
};

void scene_menu_main_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_poll_input(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
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
