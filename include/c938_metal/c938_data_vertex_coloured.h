#ifndef __c938_metal_c938_data_vertex_coloured_h
#define __c938_metal_c938_data_vertex_coloured_h

struct c938_data_vertex_coloured {
  metal::float4 position [[position]];
  float brightness;
  metal::float4 colour;
};

#endif
