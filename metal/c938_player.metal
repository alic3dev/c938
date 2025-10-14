#include <mode_texture.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
};

[[vertex]] struct data_vertex c938_player_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_positions
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

  data_vertex.brightness = 1.0f;//data_frame->brightness;

  if (
    id_vertex == 0
  ) {
    data_vertex.position_texture.x = 0.5f;
    data_vertex.position_texture.y = metal::fabs(1.0f - (float)(data_frame->frame % 221) / 110.0f);
  } else {
    data_vertex.position_texture.x = (float) ((id_vertex - 1)) / 6.0f;
    
    if (
      data_vertex.position_texture.x > 1.0f
    ) {
      data_vertex.position_texture.x = 1.0f - (data_vertex.position_texture.x - 1.0f);
    }

    data_vertex.position_texture.y = metal::fabs(((float)(data_frame->frame % 667) / 333.0f) - 1.0f);
  }

  return data_vertex;
}

[[fragment]] float4 c938_player_fragment(
  data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 color_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  return float4(
    color_texture[0] * data_vertex.brightness * 0.5f,
    color_texture[1] * data_vertex.brightness * 0.5f,
    color_texture[2] * data_vertex.brightness * 0.7f + 0.3f,
    color_texture[3]
  );
}
