#include <animations/animation_gun_idle.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_animation/metil_animation.h>
#include <stdio.h>
void c938_animation_gun_idle_initialize(
  struct metil_animation* c938_animation_gun_idle,
  struct math_c_vector3_float* position,
  struct math_c_vector3_float* rotation
) {
  metil_animation_initialize(
    c938_animation_gun_idle
  );

  c938_animation_gun_idle->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct c938_animation_gun_idle_data
      )
    )
  );

  struct c938_animation_gun_idle_data* c938_animation_gun_idle_data = (
    c938_animation_gun_idle->data
  );

  c938_animation_gun_idle_data->position = (
    position
  );

  c938_animation_gun_idle_data->rotation = (
    rotation
  );

  c938_animation_gun_idle_data->position_offset.x = (
    0x00
  );

  c938_animation_gun_idle_data->position_offset.y = (
    0x00
  );

  c938_animation_gun_idle_data->position_offset.z = (
    0x00
  );

  c938_animation_gun_idle->loops = (
    metil_animation_loop_loops_mirrored
  );

  c938_animation_gun_idle->length = (
    0x1388
  );

  c938_animation_gun_idle->start = (
    c938_animation_gun_idle_start
  );

  c938_animation_gun_idle->poll = (
    c938_animation_gun_idle_poll
  );
}

void c938_animation_gun_idle_start(
  struct metil_animation* c938_animation_gun_idle,
  enum metil_renderable_type metil_renderable_type,
  void* data
) {
}

void c938_animation_gun_idle_poll(
  struct metil_animation* c938_animation_gun_idle,
  enum metil_renderable_type metl_renderable_type,
  void* data,
  float percentage
) {
  return;

  struct c938_animation_gun_idle_data* c938_animation_gun_idle_data = (
    c938_animation_gun_idle->data
  );

  c938_animation_gun_idle_data->position->x = (
    c938_animation_gun_idle_data->position->x -
    c938_animation_gun_idle_data->position_offset.x
  );

  c938_animation_gun_idle_data->position->y = (
    c938_animation_gun_idle_data->position->y -
    c938_animation_gun_idle_data->position_offset.y
  );

  c938_animation_gun_idle_data->position->z = (
    c938_animation_gun_idle_data->position->z -
    c938_animation_gun_idle_data->position_offset.z
  );

  c938_animation_gun_idle_data->position_offset.x = (
    (float)
    (
      (int)
      (
        math_c_sine(
          (
            percentage *
            math_c_pi *
            0x04
          ),
          math_c_pi
        ) *
        0x64
      )
    ) /
    0x64
  );

  c938_animation_gun_idle_data->position_offset.y = (
    (float)
    (
      (int)
      (
        math_c_sine(
          (
            percentage *
            math_c_pi *
            0x05
          ),
          math_c_pi
        ) *
        0x64
      )
    ) /
    0x64
  );

  c938_animation_gun_idle_data->position_offset.z = (
    (float)
    (
      (int)
      (
        math_c_sine(
          (
            percentage *
            math_c_pi *
            0x02
          ),
          math_c_pi
        ) *
        0x64
      )
    ) /
    0x64
  );

  c938_animation_gun_idle_data->position->x = (
    c938_animation_gun_idle_data->position->x +
    c938_animation_gun_idle_data->position_offset.x
  );

  c938_animation_gun_idle_data->position->y = (
    c938_animation_gun_idle_data->position->y +
    c938_animation_gun_idle_data->position_offset.y
  );

  c938_animation_gun_idle_data->position->z = (
    c938_animation_gun_idle_data->position->z +
    c938_animation_gun_idle_data->position_offset.z
  );
}

void c938_animation_gun_idle_destroy(
  struct metil_animation* c938_animation_gun_idle
) {
  clic3_memory_free_raw(
    c938_animation_gun_idle->data
  );
}
