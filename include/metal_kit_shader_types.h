#ifndef __metal_kit_shader_types_h
#define __metal_kit_shader_types_h

#include <clic3_vector.h>

#include <simd/simd.h>

#ifndef __METAL_VERSION__
#define constant
#endif

enum mode_texture {
  mode_texture_default,
  mode_texture_ground,
  mode_texture_building,
  mode_texture_player,
  mode_texture_text,
};

typedef enum {
  metal_kit_vertex_input_index_positions = 2,
  metal_kit_vertex_input_index_frame_data = 1,
  metal_kit_vertex_input_index_data = 0
} metal_kit_vertex_input_index;

typedef struct {
  matrix_float4x4 view_model_matrix_projection;
  struct clic3_vector3_float position;
  float width;
  float height;
  float depth;
  unsigned int noise;
  unsigned int id;
  enum mode_texture mode_texture;
} metal_kit_data_frame_object;

typedef struct {
  unsigned int frame;
  struct clic3_vector3_float rotation_camera;
  struct clic3_vector3_float position_player;
  float brightness;
  float brightness_text;
} metal_kit_data_frame;

#endif
