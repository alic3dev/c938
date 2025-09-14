#ifndef __rendering_camera_camera_h
#define __rendering_camera_camera_h

#include <rendering/camera/lens.h>
#include <rendering/camera/near_far.h>

#include <clic3_vector.h>

#include <simd/simd.h>

struct camera {
  struct lens lens;

  float ratio_aspect;

  struct clic3_vector2_float field_of_view;

  struct near_far distance_view;

  struct clic3_vector3_float vector_normalization;
  simd_float4x4 matrix_viewport_projection;
};

void camera_initialize(
  struct camera*
);

void camera_ratio_aspect_set(
  struct camera*,
  float
);

float camera_field_of_view_calculate(
  struct camera*
);

float camera_field_of_view_horizontal_calculate(
  struct camera*
);

void camera_field_of_view_set(
  struct camera*
);

#endif
