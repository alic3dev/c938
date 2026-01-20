#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float4 colour;
};

[[vertex]] struct data_vertex c938_crosshair_vertex(
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

  data_vertex.colour.r = data_object->colour.x;
  data_vertex.colour.g = data_object->colour.y;
  data_vertex.colour.b = data_object->colour.z;
  data_vertex.colour.a = data_object->colour.w;

  return data_vertex;
}

[[fragment]] float4 c938_crosshair_fragment(
  data_vertex data_vertex [[stage_in]]
) {
  return float4(
    data_vertex.colour.r,
    data_vertex.colour.g,
    data_vertex.colour.b,
    data_vertex.colour.a
  );
}
