#ifndef __scenes_scene_menu_main_h
#define __scenes_scene_menu_main_h

#include <metil_menus/menu.h>
#include <metil_scenes/scene.h>

#include <CoreAudio/CoreAudio.h>
#include <MetalKit/MetalKit.h>

extern const unsigned long int scene_menu_main_time_scene_transition;

enum textures_scene_menu_main {
  textures_scene_menu_main_title = 0,
  textures_scene_menu_main_menu_enter = 1,
  textures_scene_menu_main_menu_exit = 2
};

struct metil_scene_menu_main_data {
  struct metil_menu menu;
  unsigned long int time_started;
  float angle;
};

void scene_menu_main_initialize(
  struct metil_scene*,
  id<MTLDevice>
);

void scene_menu_main_poll(
  struct metil_scene*
);

void scene_menu_main_poll_input(
  struct metil_scene*
);

void scene_menu_main_destroy(
  struct metil_scene*
);

OSStatus scene_menu_main_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);

#endif
