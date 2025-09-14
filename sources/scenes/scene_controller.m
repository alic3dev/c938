#include <scenes/scene_controller.h>

#include <stdlib.h>

struct scene_controller_structure scene_controller = {
  .length_on_scene_change = 0,
  .on_scene_change = (void*)0,
  .on_scene_change_data = (void*)0
};

void scene_controller_initialize() {
  scene_controller.on_scene_change = malloc(
    sizeof(scene_controller_on_scene_change) *
    scene_controller.length_on_scene_change
  );
  scene_controller.on_scene_change_data = malloc(
    sizeof(void*) *
    scene_controller.length_on_scene_change
  );
}

void scene_controller_scene_change(
  enum scene_id scene_id
) {
  for (
    unsigned short int index_on_scene_change = 0;
    index_on_scene_change < scene_controller.length_on_scene_change;
    ++index_on_scene_change
  ) {
    scene_controller.on_scene_change[
      index_on_scene_change
    ](
      scene_id,
      scene_controller.on_scene_change_data[
        index_on_scene_change
      ]
    );
  }
}

void scene_controller_on_scene_change_add(
  scene_controller_on_scene_change on_scene_change,
  void* on_scene_change_data
) {
  scene_controller.length_on_scene_change = (
    scene_controller.length_on_scene_change + 1
  );

  scene_controller.on_scene_change = realloc(
    scene_controller.on_scene_change,
    sizeof(scene_controller_on_scene_change) *
    scene_controller.length_on_scene_change
  );

  scene_controller.on_scene_change_data = realloc(
    scene_controller.on_scene_change_data,
    sizeof(void*) *
    scene_controller.length_on_scene_change
  );

  scene_controller.on_scene_change[
    scene_controller.length_on_scene_change - 1
  ] = on_scene_change;

  scene_controller.on_scene_change_data[
    scene_controller.length_on_scene_change - 1
  ] = on_scene_change_data;
}

void scene_controller_destroy() {
  free(scene_controller.on_scene_change);
  free(scene_controller.on_scene_change_data);
}
