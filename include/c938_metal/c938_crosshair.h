#ifndef __c938_c938_metal_c938_crosshair_h
#define __c938_c938_metal_c938_crosshair_h

#include <c938_metal/c938_data_vertex_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

[[vertex]] struct c938_data_vertex_coloured c938_crosshair_vertex(
  const device metal::float4*,
  constant struct metil_renderer_data_frame*,
  constant struct metil_renderer_data_object*,
  unsigned int
);

[[fragment]] metal::float4 c938_crosshair_fragment(
  c938_data_vertex_coloured
);

#endif
