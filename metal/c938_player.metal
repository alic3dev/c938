#include <c938_metal/c938_player.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_textured_coloured c938_player_vertex(
  const device metal::float4* vertices [[
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
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured;

  c938_data_vertex_textured_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  c938_data_vertex_textured_coloured.brightness = (
    data_frame->brightness
  );

  unsigned char offset_frame = (
    (
      data_frame->frame /
      0x0a
    ) %
    0x64
  );

  c938_data_vertex_textured_coloured.colour.r = (
    (float)
    (
      (
        index_vertex -
        offset_frame
      ) %
      0x0a
    ) /
    0x09
  );

  c938_data_vertex_textured_coloured.colour.g = (
    (float)
    (
      (
        index_vertex -
        offset_frame +
        0x03
      ) %
      0x0a
    ) /
    0x09
  );

  c938_data_vertex_textured_coloured.colour.b = (
    (float)
    (
      (
        index_vertex -
        offset_frame +
        0x06
      ) %
      0x0a
    ) /
    0x09
  );

  c938_data_vertex_textured_coloured.colour.a = (
    0x01
  );

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] float4 c938_player_fragment(
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]]
) {
  return (
    float4(
      (
        c938_data_vertex_textured_coloured.colour.r *
        c938_data_vertex_textured_coloured.brightness *
        0.7f
      ),
      (
        c938_data_vertex_textured_coloured.colour.g *
        c938_data_vertex_textured_coloured.brightness *
        0.7f
      ),
      (
        c938_data_vertex_textured_coloured.colour.b *
        c938_data_vertex_textured_coloured.brightness *
        0.7f
      ),
      c938_data_vertex_textured_coloured.colour.a
    )
  );
}
