#include <c938_metal/c938_player.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_player_vertex(
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
    positions[
      id_vertex
    ]
  );

  c938_data_vertex_textured_coloured.brightness = (
    data_frame->brightness
  );

  unsigned char offset_frame = (
    (
      data_frame->frame /
      10
    ) %
    100
  );

  c938_data_vertex_textured_coloured.colour.r = (
    (float)
    (
      (
        id_vertex -
        offset_frame
      ) %
      10
    ) /
    10.0f
  );

  c938_data_vertex_textured_coloured.colour.g = (
    (float)
    (
      (
        id_vertex -
        offset_frame +
        3
      ) %
      10
    ) /
    10.0f
  );

  c938_data_vertex_textured_coloured.colour.b = (
    (float)
    (
      (
        id_vertex -
        offset_frame +
        6
      ) %
      10
    ) /
    10.0f
  );

  c938_data_vertex_textured_coloured.colour.a = (
    1.0f
  );

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_player_fragment(
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]]
) {
  return metal::float4(
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
    (
      c938_data_vertex_textured_coloured.colour.a
    )
  );
}
