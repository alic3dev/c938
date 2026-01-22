#ifndef __c938_metal_c938_data_vertex_textured_h
#define __c938_metal_c938_data_vertex_textured_h

struct c938_data_vertex_textured {
  metal::float4 position [[position]];
  metal::float2 position_texture;
  float brightness;
};

#endif
