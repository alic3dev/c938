#include <scenes/scene_gameplay/scene_gameplay_group_enemies.h>

#include <objects/object_enemy.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>

void scene_gameplay_group_enemies_resize(
  struct metil* metil,
  struct metil_group* metil_group_enemies,
  unsigned int length_enemies
) {
  if (
    metil_group_enemies->length < length_enemies
  ) {
    unsigned int enemies_original = (
      metil_group_enemies->length
    );

    unsigned int enemies_new = (
      length_enemies -
      enemies_original
    );

    metil_group_add_length_initialize(
      metil_group_enemies,
      enemies_new,
      metil_renderable_type_object
    );

    for (
      unsigned int index_enemy_new = enemies_original;
      index_enemy_new < metil_group_enemies->length;
      ++index_enemy_new
    ) {
      struct metil_object* metil_object_enemy = (
        metil_group_enemies->renderables[
          index_enemy_new
        ]->renderable
      );
      
      object_enemy_initialize(
        metil_object_enemy,
        metil->renderer_interface.metal_device,
        (struct math_c_vector3_float) {
          .x = 0,
          .y = 0,
          .z = 0
        },
        4,
        0.0f
      );
    }
  } else {
    while (
      metil_group_enemies->length > length_enemies
    ) {
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_enemies,
        (
          metil_group_enemies->length -
          1
        )
      );
    }
  }
}
