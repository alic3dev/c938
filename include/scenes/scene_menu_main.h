#ifndef __scenes_scene_menu_main_h
#define __scenes_scene_menu_main_h

#include <menus/menu.h>
#include <scenes/scene.h>

#include <CoreAudio/CoreAudio.h>
#include <MetalKit/MetalKit.h>

extern const unsigned long int scene_menu_main_time_scene_transition;

enum textures_scene_menu_main {
  textures_scene_menu_main_ground = 0,
  textures_scene_menu_main_title = 1,
  textures_scene_menu_main_menu_enter = 2,
  textures_scene_menu_main_menu_exit = 3
};

struct scene_menu_main_data {
  struct menu menu;
  unsigned long int time_started;
};

void scene_menu_main_initialize(
  struct scene*,
  id<MTLDevice>
);

void scene_menu_main_poll(
  struct scene*
);

void scene_menu_main_poll_input(
  struct scene*
);

void scene_menu_main_destroy(
  struct scene*
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
