#include <c938_metal/c938_text_backing_menu.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_text_backing_menu_vertex(
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
    data_frame->brightness_text *
    (
      (
        1.0f -
        (
          (
            vertices[
              index_vertex
            ].z +
            0.25f
          ) *
          0x02
        )
      ) *
      0.6f +
      0.1f
    )
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
    (
      (
        index_vertex >
        0x04
      ) ==
      0x00
    )
    ? 1.7f
    : -0.1f
  );

  c938_data_vertex_textured_coloured.position_texture.y = (
    (
      (
        index_vertex %
        0x02
      ) ==
      0x00
    )
    ? 1.1f
    : -0.1f
  );

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_text_backing_menu_fragment(
  c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[
    stage_in
  ]],
  metal::texture2d<float> texture [[
    texture(
      0x00
    )
  ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::t_address::clamp_to_border,
    metal::r_address::clamp_to_border,
    metal::s_address::clamp_to_border,
    metal::border_color::opaque_white
  );

  metal::float4 colour_texture = metal::float4(
    texture.sample(
      sampler_texture,
      c938_data_vertex_textured_coloured.position_texture
    )
  );

  return (
    float4(
      (
        0x01 -
        (
          colour_texture[
            0x00
          ] *
          c938_data_vertex_textured_coloured.colour.r *
          c938_data_vertex_textured_coloured.brightness
        )
      ),
      (
        0x01 -
        (
          colour_texture[
            0x01
          ] *
          c938_data_vertex_textured_coloured.colour.g *
          c938_data_vertex_textured_coloured.brightness
        )
      ),
      (
        0x01 -
        (
          colour_texture[
            0x02
          ] *
          c938_data_vertex_textured_coloured.colour.b *
          c938_data_vertex_textured_coloured.brightness
        )
      ),
      (
        colour_texture[
          0x03
        ] *
        c938_data_vertex_textured_coloured.colour.a *
        0.8f
      )
    )
  );
}
