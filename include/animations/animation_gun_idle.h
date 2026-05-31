#ifndef __c938_animations_animation_gun_idle_h
#define __c938_animations_animation_gun_idle_h

#include <math_c_vector.h>

#include <metil_animation/metil_animation.h>

struct c938_animation_gun_idle_data {
  struct math_c_vector3_float* position;
  struct math_c_vector3_float* rotation;

  struct math_c_vector3_float position_offset;
};

void c938_animation_gun_idle_initialize(
  struct metil_animation*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*
);

void c938_animation_gun_idle_start(
  struct metil_animation*,
  enum metil_renderable_type,
  void*
);

void c938_animation_gun_idle_poll(
  struct metil_animation*,
  enum metil_renderable_type,  void*,
  float
);

void c938_animation_gun_idle_destroy(
  struct metil_animation*
);

#endif
