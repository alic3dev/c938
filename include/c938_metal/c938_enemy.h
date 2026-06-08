#ifndef __c938_c938_metal_c938_enemy_h
#define __c938_c938_metal_c938_enemy_h

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <data/enemy_data.h>

#include <metil_rendering/metil_renderer_data_frame.h>

[[vertex]] struct c938_data_vertex_textured_coloured c938_enemy_vertex(
  const device metal::float4*,
  constant struct metil_renderer_data_frame*,
  constant struct enemy_data*,
  unsigned int
);

[[fragment]] metal::float4 c938_enemy_fragment(
  struct c938_data_vertex_textured_coloured
);

#endif
