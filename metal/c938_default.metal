#include <c938_metal/c938_default.h>

#include <c938_metal/c938_data_vertex_textured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured c938_vertex(
  const device metal::float4* positions [[
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
  struct c938_data_vertex_textured c938_data_vertex_textured;

  c938_data_vertex_textured.position = (
    data_object->view_model_matrix_projection *
    positions[id_vertex]
  );

  c938_data_vertex_textured.brightness = data_frame->brightness;

  c938_data_vertex_textured.position_texture.x = id_vertex % 2;
  c938_data_vertex_textured.position_texture.y = id_vertex % 2;

  return c938_data_vertex_textured;
}

[[fragment]] metal::float4 c938_fragment(
  c938_data_vertex_textured c938_data_vertex_textured [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  metal::float4 colour_texture = metal::float4(
    texture.sample(
      sampler_texture,
      c938_data_vertex_textured.position_texture
    )
  );

  return metal::float4(
    colour_texture[0] * c938_data_vertex_textured.brightness,
    colour_texture[1] * c938_data_vertex_textured.brightness,
    colour_texture[2] * c938_data_vertex_textured.brightness,
    colour_texture[3]
  );
}
