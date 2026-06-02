#ifndef __c938_metal_c938_data_vertex_textured_coloured_h
#define __c938_metal_c938_data_vertex_textured_coloured_h

struct c938_data_vertex_textured_coloured {
  metal::float4 position [[position]];
  metal::float2 position_texture;
  float brightness;
  metal::float4 colour;
  float offset;
};

#endif
