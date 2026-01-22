#ifndef __c938_c938_metal_c938_text_backing_menu_h
#define __c938_c938_metal_c938_text_backing_menu_h

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_text_backing_menu_vertex(
  const device metal::float4*,
  constant struct metil_renderer_data_frame*,
  constant struct metil_renderer_data_object*,
  unsigned int
);

[[fragment]] metal::float4 c938_text_backing_menu_fragment(
  struct c938_data_vertex_textured_coloured,
  metal::texture2d<half>
);

#endif
