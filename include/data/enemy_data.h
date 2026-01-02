#ifndef __enemy_data_h
#define __enemy_data_h

#include <clic3_vector.h>

#include <simd/simd.h>

struct enemy_data {
  unsigned char life_maximum;
  unsigned char life;

  simd_float4 translation;
  float speed; // metres per second

  struct clic3_vector3_float position_previous;

  struct clic3_vector3_float color;

  matrix_float4x4 view_model_matrix_projection;
};

#endif
