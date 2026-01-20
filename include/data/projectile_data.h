#ifndef __projectile_data_h
#define __projectile_data_h

#include <math_c_vector.h>

#include <simd/simd.h>

struct projectile_data {
  unsigned long int time_current;
  float time_delta_percent;
  unsigned long int time_fired;

  unsigned long int lifespan;

  simd_float4 translation;
  float speed; // metres per second

  struct math_c_vector3_float position_previous;

  struct math_c_vector3_float colour;

  matrix_float4x4 view_model_matrix_projection;
};

#endif
