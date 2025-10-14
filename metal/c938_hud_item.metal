#include <mode_texture.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float brightness;
  float3 color;
};

[[vertex]] struct data_vertex c938_hud_item_vertex(
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

  data_vertex.brightness = data_frame->brightness;

  data_vertex.color.r = (float) (2000 - data_object->noise) / 2000.0f;
  data_vertex.color.g = (float) data_object->noise / 2000.0f;
  data_vertex.color.b = (float) (data_object->noise % 2000) / 2000.0f;

  return data_vertex;
}

[[fragment]] float4 c938_hud_item_fragment(
  data_vertex data_vertex [[stage_in]]
) {
  return float4(
    data_vertex.color.r * data_vertex.brightness,
    data_vertex.color.g * data_vertex.brightness,
    data_vertex.color.b * data_vertex.brightness,
    1.0f
  );
}
