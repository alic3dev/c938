#include <scenes/scene.h>

#include <input/cursor.h>
#include <object.h>
#include <player.h>

#include <stdlib.h>

void scene_initialize(
  struct scene* scene,
  id<MTLDevice> metal_kit_device
) {
  scene->metal_kit_device = metal_kit_device;

  player_initialize(
    &scene->player
  );

  scene->length_objects = 0;
  scene->objects = malloc(
    sizeof(struct object*) *
    scene->length_objects
  );

  scene->type = scene_type_unknown;
  scene->id = scene_id_unknown;

  scene->player.position.x = 0.0f;
  scene->player.position.y = 0.0f;
  scene->player.position.z = 0.0f;

  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  input_delta_cursor.x = 0.0f;
  input_delta_cursor.y = 0.0f;

  scene->poll = scene_poll_default;
  scene->poll_input = scene_poll_input_default;
  scene->destroy = scene_destroy_default;

  scene->time = 0;
  scene->time_previous = 0;

  scene->time_input = 0;
  scene->time_input_previous = 0;

  scene->loading = 0;

  scene->rendering_properties.brightness = 1.0f;
  scene->rendering_properties.brightness_text = 1.0f;

  scene->data = (void*)0;
}

void scene_poll_input(
  struct scene* scene,
  unsigned long int time
) {
  scene->time_input_previous = scene->time;
  scene->time_input = time;
  scene->time_input_delta = scene->time_input_previous == 0 ? 0 : (
    scene->time_input -
    scene->time_input_previous
  );

  scene->poll_input(
    scene
  );
}

void scene_poll(
  struct scene* scene,
  unsigned long int time
) {
  scene->time_previous = scene->time;
  scene->time = time;
  scene->time_delta = scene->time_previous == 0 ? 0 : (
    scene->time -
    scene->time_previous
  );

  scene->poll(
    scene
  );
}

void scene_destroy(
  struct scene* scene
) {
  scene->destroy(
    scene
  );
}

void scene_poll_input_default(
  struct scene* scene
) {
  player_poll_input(
    &scene->player,
    scene->time
  );
}

void scene_poll_default(
  struct scene* scene
) {
  player_poll(
    &scene->player
  );
}

void scene_destroy_default(
  struct scene* scene
) {
  for (
    unsigned short int index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    object_destroy(
      scene->objects[index_object]
    );

    free(scene->objects[index_object]);
  }

  free(scene->objects);

  for (
    unsigned short int index_texture = 0;
    index_texture < scene->length_textures;
    ++index_texture
  ) {
    [scene->textures[index_texture] release];
  }
  free(scene->textures);

  player_destroy(
    &scene->player
  );

  if (
    scene->data != (void*)0
  ) {
    free(scene->data);
  }
}
