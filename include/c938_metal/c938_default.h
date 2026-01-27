#ifndef __c938_c938_metal_c938_default_h
#define __c938_c938_metal_c938_default_h

#include <c938_metal/c938_data_vertex_textured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured c938_vertex(
  const device metal::float4*,
  constant struct metil_renderer_data_frame*,
  constant struct metil_renderer_data_object*,
  unsigned int
);

[[fragment]] metal::float4 c938_fragment(
  c938_data_vertex_textured,
  metal::texture2d<half>
);

#endif
