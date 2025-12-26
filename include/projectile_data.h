#ifndef __projectile_data_h
#define __projectile_data_h

#include <clic3_vector.h>

#include <simd/simd.h>

struct projectile_data {
  unsigned long int time_current;
  float time_delta_percent;
  unsigned long int time_fired;

  unsigned long int lifespan;

  simd_float4 translation;
  float speed; // metres per second

  struct clic3_vector3_float position_previous;

  struct clic3_vector3_float color;

  matrix_float4x4 view_model_matrix_projection;
};

#endif
