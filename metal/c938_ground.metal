#include <mode_texture.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
  float distance;
};

[[vertex]] struct data_vertex c938_ground_vertex(
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

  data_vertex.position_texture.x = (
    id_vertex == 4 ||
    id_vertex == 6 ||

    id_vertex == 0 ||
    id_vertex == 1
  ) ? 0 : 1;

  data_vertex.position_texture.y = (
    id_vertex == 6 ||
    id_vertex == 7 ||

    id_vertex == 1 ||
    id_vertex == 3
  ) ? 0 : 1;

  data_vertex.brightness = (
    id_vertex > 3 && data_object->mode_texture == mode_texture_building
    ? 1.0f
    : 0.125f
  ) * data_frame->brightness;

  data_vertex.distance = (
    metal::fabs((data_object->position.x + positions[id_vertex].x) - data_frame->position_player.x) + 
    metal::fabs((data_object->position.y + positions[id_vertex].y) - data_frame->position_player.y) + 
    metal::fabs((data_object->position.z + positions[id_vertex].z) - data_frame->position_player.z)
  );

  return data_vertex;
}

[[fragment]] float4 c938_ground_fragment(
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

  float brightness = (
    data_vertex.brightness * 
    metal::fmax(
      1.0f - (data_vertex.distance / 1000.0f),
      0.25f
    )
  );

  return float4(
    color_texture[0] * brightness,
    color_texture[1] * brightness,
    color_texture[2] * brightness,
    color_texture[3]
  );
}
