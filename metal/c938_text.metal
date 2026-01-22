#include <c938_metal/c938_text.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_text_vertex(
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
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured;

  c938_data_vertex_textured_coloured.position = (
    data_object->view_model_matrix_projection *
    positions[id_vertex]
  );

  c938_data_vertex_textured_coloured.brightness = (
    data_frame->brightness_text
  );

  c938_data_vertex_textured_coloured.colour.r = (
    data_object->colour.x
  );

  c938_data_vertex_textured_coloured.colour.g = (
    data_object->colour.y
  );

  c938_data_vertex_textured_coloured.colour.b = (
    data_object->colour.z
  );

  c938_data_vertex_textured_coloured.colour.a = (
    data_object->colour.w
  );

  c938_data_vertex_textured_coloured.position_texture.x = (
    id_vertex == 0 || id_vertex == 3
    ? 0
    : 1
  );

  c938_data_vertex_textured_coloured.position_texture.y = (
    id_vertex == 0 || id_vertex == 1
    ? 1
    : 0
  );

  return c938_data_vertex_textured_coloured;
}

[[fragment]] metal::float4 c938_text_fragment(
  c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  metal::float4 colour_texture = metal::float4(
    texture.sample(
      sampler_texture,
      c938_data_vertex_textured_coloured.position_texture
    )
  );

  return metal::float4(
    (
      colour_texture[0] *
      c938_data_vertex_textured_coloured.colour.r *
      c938_data_vertex_textured_coloured.brightness
    ),
    (
      colour_texture[1] *
      c938_data_vertex_textured_coloured.colour.g *
      c938_data_vertex_textured_coloured.brightness
    ),
    (
      colour_texture[2] *
      c938_data_vertex_textured_coloured.colour.b *
      c938_data_vertex_textured_coloured.brightness
    ),
    (
      colour_texture[3] *
      c938_data_vertex_textured_coloured.colour.a
    )
  );
}
