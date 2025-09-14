#ifndef __scene_controller_h
#define __scene_controller_h

#include <scenes/scene.h>

typedef void (*scene_controller_on_scene_change)(enum scene_id, void*);

struct scene_controller_structure {
  unsigned char length_on_scene_change;
  scene_controller_on_scene_change* on_scene_change;
  void** on_scene_change_data;
};

extern struct scene_controller_structure scene_controller;

void scene_controller_initialize();

void scene_controller_scene_change(
  enum scene_id scene_id
);

void scene_controller_on_scene_change_add(
  scene_controller_on_scene_change,
  void*
);

void scene_controller_destroy();

#endif
