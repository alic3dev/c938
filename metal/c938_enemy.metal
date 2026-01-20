#include <data/enemy_data.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float brightness;
  float4 colour;
};

[[vertex]] struct data_vertex c938_enemy_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct enemy_data* enemy_data [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    enemy_data->view_model_matrix_projection *
    positions[id_vertex]
  );

  data_vertex.brightness = (
    data_frame->brightness
  );

  float percentage_life = (
    (float) enemy_data->life /
    (float) enemy_data->life_maximum
  );

  data_vertex.colour = float4(
    enemy_data->colour.x * metal::fmin(percentage_life * 2.0f, 1.0f),
    enemy_data->colour.y * percentage_life,
    enemy_data->colour.z * percentage_life,
    1.0f
  );

  return data_vertex;
}

[[fragment]] float4 c938_enemy_fragment(
  data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  return float4(
    data_vertex.colour.r * data_vertex.brightness,
    data_vertex.colour.g * data_vertex.brightness,
    data_vertex.colour.b * data_vertex.brightness,
    data_vertex.colour.a
  );
}
