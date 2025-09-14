#ifndef __scenes_scene_h
#define __scenes_scene_h

#include <object.h>
#include <player.h>

#include <MetalKit/MetalKit.h>

struct scene;

typedef void (*function_scene_poll)(struct scene*);
typedef void (*function_scene_poll_input)(struct scene*);
typedef void (*function_scene_destroy)(struct scene*);

enum scene_type {
  scene_type_unknown,
  scene_type_menu,
  scene_type_game
};

enum scene_id {
  scene_id_unknown,
  scene_id_menu_main,
  scene_id_gameplay
};

struct scene_rendering_properties {
  float brightness;
  float brightness_text;
};

struct scene {
  id<MTLDevice> metal_kit_device;

  struct player player;
  enum scene_type type;
  enum scene_id id;

  struct object** objects;
  unsigned short int length_objects;

  id<MTLTexture>* textures;
  unsigned short int length_textures;

  unsigned char loading;

  unsigned long int time;
  unsigned long int time_previous;
  unsigned long int time_delta;

  unsigned long int time_input;
  unsigned long int time_input_previous;
  unsigned long int time_input_delta;

  function_scene_poll poll;
  function_scene_poll_input poll_input;
  function_scene_destroy destroy;

  struct scene_rendering_properties rendering_properties;

  void* data;
};

void scene_initialize(
  struct scene*,
  id<MTLDevice>
);

void scene_poll_input(
  struct scene*,
  unsigned long int
);

void scene_poll(
  struct scene*,
  unsigned long int
);

void scene_destroy(
  struct scene*
);

void scene_poll_input_default(
  struct scene*
);

void scene_poll_default(
  struct scene*
);

void scene_destroy_default(
  struct scene*
);

#endif
