#ifndef __scenes_scene_gameplay_h
#define __scenes_scene_gameplay_h

#include <metil_scenes/scene.h>

#include <CoreAudio/CoreAudio.h>
#include <MetalKit/MetalKit.h>

#define scene_gameplay_length_buildings_default 200
#define scene_gameplay_length_objects_default scene_gameplay_length_buildings_default + 6

enum textures_scene_gameplay {
  textures_scene_gameplay_player = 0
};

void scene_gameplay_initialize(
  struct metil_scene*,
  id<MTLDevice>
);

void scene_gameplay_populate(
  struct metil_scene*,
  unsigned short int
);

void scene_gameplay_poll(
  struct metil_scene*
);

void scene_gameplay_destroy(
  struct metil_scene*
);

OSStatus scene_gameplay_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);

#endif
