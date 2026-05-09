#include <c938_metal/c938_crosshair.h>

#include <c938_metal/c938_data_vertex_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_coloured c938_crosshair_vertex(
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
  struct c938_data_vertex_coloured c938_data_vertex_coloured;

  c938_data_vertex_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  c938_data_vertex_coloured.colour.x = (
    data_object->colour.x
  );

  c938_data_vertex_coloured.colour.y = (
    data_object->colour.y
  );

  c938_data_vertex_coloured.colour.z = (
    data_object->colour.z
  );

  c938_data_vertex_coloured.colour.w = (
    data_object->colour.w
  );

  return (
    c938_data_vertex_coloured
  );
}

[[fragment]] metal::float4 c938_crosshair_fragment(
  c938_data_vertex_coloured c938_data_vertex_coloured [[stage_in]]
) {
  return metal::float4(
    c938_data_vertex_coloured.colour.x,
    c938_data_vertex_coloured.colour.y,
    c938_data_vertex_coloured.colour.z,
    c938_data_vertex_coloured.colour.w
  );
}
