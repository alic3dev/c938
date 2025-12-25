#ifndef __scenes_scene_gameplay_h
#define __scenes_scene_gameplay_h

#include <metil_menus/menu.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/scene.h>

#if !target_os_ios
#include <CoreAudio/CoreAudio.h>
#endif
#include <MetalKit/MetalKit.h>

#define scene_gameplay_length_buildings_default 200

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
