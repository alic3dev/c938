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

  if (
    id_vertex == 0
  ) {
    c938_data_vertex_textured_coloured.position_texture.x = (
      0.5f
    );

    c938_data_vertex_textured_coloured.position_texture.y = (
      metal::fabs(
        1.0f -
        (
          (
            (float)
            (
              data_frame->frame %
              221
            )
          ) /
          110.0f
        )
      )
    );
  } else {
    c938_data_vertex_textured_coloured.position_texture.x = (
      (
        (float)
        (
          id_vertex -
          1
        )
      ) /
      6.0f
    );
    
    if (
      c938_data_vertex_textured_coloured.position_texture.x > 1.0f
    ) {
      c938_data_vertex_textured_coloured.position_texture.x = (
        1.0f -
        (
          c938_data_vertex_textured_coloured.position_texture.x -
          1.0f
        )
      );
    }

    c938_data_vertex_textured_coloured.position_texture.y = (
      metal::fabs(
        (
          (
            (float)
            (
              data_frame->frame %
              667
            )
          ) /
          333.0f
        ) -
        1.0f
      )
    );
  }

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_player_fragment(
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]],
  metal::texture2d<half> metal_texture_player [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  metal::float4 colour_texture_player = metal::float4(
    metal_texture_player.sample(
      sampler_texture,
      c938_data_vertex_textured_coloured.position_texture
    )
  );

  return metal::float4(
    (
      colour_texture_player[0] *
      c938_data_vertex_textured_coloured.colour.r *
      c938_data_vertex_textured_coloured.brightness *
      0.7f +
      0.15f
    ),
    (
      colour_texture_player[1] *
      c938_data_vertex_textured_coloured.colour.g *
      c938_data_vertex_textured_coloured.brightness *
      0.5f
    ),
    (
      colour_texture_player[2] *
      c938_data_vertex_textured_coloured.colour.b *
      c938_data_vertex_textured_coloured.brightness *
      0.7f +
      0.3f
    ),
    (
      c938_data_vertex_textured_coloured.colour.a
    )
  );
}
