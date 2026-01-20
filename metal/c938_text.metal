#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
  float4 colour;
};

[[vertex]] struct data_vertex c938_text_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct metil_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    positions[id_vertex]
  );

  data_vertex.brightness = (
    data_frame->brightness_text
  );

  data_vertex.colour.r = (
    data_object->colour.x
  );

  data_vertex.colour.g = (
    data_object->colour.y
  );

  data_vertex.colour.b = (
    data_object->colour.z
  );

  data_vertex.colour.a = (
    data_object->colour.w
  );

  data_vertex.position_texture.x = (
    id_vertex == 0 || id_vertex == 3
    ? 0
    : 1
  );

  data_vertex.position_texture.y = (
    id_vertex == 0 || id_vertex == 1
    ? 1
    : 0
  );

  return data_vertex;
}

[[fragment]] float4 c938_text_fragment(
  data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 colour_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  return float4(
    (
      colour_texture[0] *
      data_vertex.colour.r *
      data_vertex.brightness
    ),
    (
      colour_texture[1] *
      data_vertex.colour.g *
      data_vertex.brightness
    ),
    (
      colour_texture[2] *
      data_vertex.colour.b *
      data_vertex.brightness
    ),
    (
      colour_texture[3] *
      data_vertex.colour.a
    )
  );
}
