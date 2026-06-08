#ifndef __c938_c938_metal_c938_projectile_h
#define __c938_c938_metal_c938_projectile_h

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <data/projectile_data.h>

#include <metil_rendering/metil_renderer_data_frame.h>

[[vertex]] struct c938_data_vertex_textured_coloured c938_projectile_vertex(
  const device metal::float4*,
  constant struct metil_renderer_data_frame*,
  constant struct projectile_data*,
  unsigned int
);

[[fragment]] metal::float4 c938_projectile_fragment(
  struct c938_data_vertex_textured_coloured
);

#endif
