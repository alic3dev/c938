#include <c938_metal/c938_building.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_building_vertex(
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

  c938_data_vertex_textured_coloured.position_texture.x = (
    positions[
      id_vertex
    ].x +
    positions[
      id_vertex
    ].z
  );

  c938_data_vertex_textured_coloured.position_texture.y = (
    positions[
      id_vertex
    ].y +
    positions[
      id_vertex
    ].x
  );

  float distance = metal::distance(
    metal::float4(
      metal::float4(
        data_object->position.x,
        data_object->position.y,
        data_object->position.z,
        1.0f
      ) +
      positions[
        id_vertex
      ]
    ),
    metal::float4(
      data_frame->position_player.x,
      data_frame->position_player.y,
      data_frame->position_player.z,
      1.0f
    )
  );

  c938_data_vertex_textured_coloured.brightness = (
    (
      positions[
        id_vertex
      ].y > 0.0f
      ? (
        data_frame->brightness *
        positions[
          id_vertex
        ].z > 0.0f
        ? (
          positions[
            id_vertex
          ].x > 0.0f
          ? 0.5f
          : 0.6f
        )
        : 1.0f
      )
      : 0.013f
    ) *
    metal::fmin(
      metal::fmax(
        (
          1.0f -
          (
            distance /
            10000.0f
          )
        ),
        0.5f
      ),
      1.0f
    )
  );

  c938_data_vertex_textured_coloured.colour = metal::float4(
    data_object->colour.x,
    data_object->colour.y,
    data_object->colour.z,
    data_object->colour.w
  );

  return c938_data_vertex_textured_coloured;
}

[[fragment]] metal::float4 c938_building_fragment(
  c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  float brightness = (
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness
  );

  constexpr metal::sampler sampler_texture(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  metal::float4 colour_texture = metal::float4(
    texture.sample(
      sampler_texture,
      (
        c938_data_vertex_textured_coloured.position_texture /
        100.0f
      )
    )
  );

  return metal::float4(
    (
      colour_texture.r *
      c938_data_vertex_textured_coloured.colour.r *
      brightness
    ),
    (
      colour_texture.g *
      c938_data_vertex_textured_coloured.colour.g *
      brightness
    ),
    (
      colour_texture.b *
      c938_data_vertex_textured_coloured.colour.b *
      brightness
    ),
    (
      colour_texture.a *
      c938_data_vertex_textured_coloured.colour.a
    )
  );
}
