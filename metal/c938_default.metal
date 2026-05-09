#include <c938_metal/c938_default.h>

#include <c938_metal/c938_data_vertex_textured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_textured c938_vertex(
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
  struct c938_data_vertex_textured c938_data_vertex_textured;

  c938_data_vertex_textured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  c938_data_vertex_textured.brightness = (
    data_frame->brightness
  );

  return (
    c938_data_vertex_textured
  );
}

[[fragment]] metal::float4 c938_fragment(
  c938_data_vertex_textured c938_data_vertex_textured [[
    stage_in
  ]]
) {
  return (
    float4(
      c938_data_vertex_textured.brightness,
      c938_data_vertex_textured.brightness,
      c938_data_vertex_textured.brightness,
      0x01
    )
  );
}
