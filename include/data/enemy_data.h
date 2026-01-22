#ifndef __c938_data_enemy_data_h
#define __c938_data_enemy_data_h

#include <math_c_vector.h>

#include <simd/simd.h>

struct enemy_data {
  unsigned char life_maximum;
  unsigned char life;

  simd_float4 translation;
  float speed; // metres per second

  struct math_c_vector3_float position_previous;

  struct math_c_vector3_float colour;

  matrix_float4x4 view_model_matrix_projection;
};

#endif
