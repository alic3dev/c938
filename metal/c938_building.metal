#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
  float4 color;
  float distance;
};

[[vertex]] struct data_vertex c938_building_vertex(
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

  unsigned short int id_vertex_moded = (
    id_vertex % 4
  );

  data_vertex.position_texture.x = (
    id_vertex_moded == 0 ||
    id_vertex_moded == 3
  ) ? (
    0.0f
  ) : (
    1.0f
  );
  data_vertex.position_texture.y = ((id_vertex + 2) / 4) % 2;

  data_vertex.brightness = (
    id_vertex > 3
    ? 1.0f
    : 0.125f
  ) * data_frame->brightness;

  data_vertex.color = float4(
    data_object->color.x,
    data_object->color.y,
    data_object->color.z,
    data_object->color.w
  );

  data_vertex.distance = metal::distance(
    metal::float4(
      metal::float4(
        data_object->position.x,
        data_object->position.y,
        data_object->position.z,
        1.0f
      ) +
      positions[id_vertex]
    ),
    metal::float4(
      data_frame->position_player.x,
      data_frame->position_player.y,
      data_frame->position_player.z,
      1.0f
    )
  );

  return data_vertex;
}

[[fragment]] float4 c938_building_fragment(
  data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  float brightness = (
    data_vertex.brightness * 
    metal::fmin(
      metal::fmax(
        1.0f - (data_vertex.distance / 1000.0f),
        0.5f
      ),
      1.0f
    )
  );

  constexpr metal::sampler sampler_texture(
    metal::coord::normalized
  );

  float4 color_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  return float4(
    color_texture[0] * data_vertex.color.r * brightness,
    color_texture[1] * data_vertex.color.g * brightness,
    color_texture[2] * data_vertex.color.b * brightness,
    color_texture[3] * data_vertex.color.a
  );
}
