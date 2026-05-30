#include <c938_metal/c938_default.h>

#include <c938_metal/c938_data_vertex_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_coloured c938_gun_vertex(
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

  c938_data_vertex_coloured.brightness = (
    data_frame->brightness
  );
  
  c938_data_vertex_coloured.colour.x = (
    0.2f *
    c938_data_vertex_coloured.brightness
  );
  
  c938_data_vertex_coloured.colour.y = (
    0.25f *
    c938_data_vertex_coloured.brightness
  );
  
  c938_data_vertex_coloured.colour.z = (
    0.3f *
    c938_data_vertex_coloured.brightness
  );
  
  c938_data_vertex_coloured.colour.w = (
    0x01
  );  

  return (
    c938_data_vertex_coloured
  );
}

[[fragment]] metal::float4 c938_gun_fragment(
  struct c938_data_vertex_coloured c938_data_vertex_coloured [[
    stage_in
  ]]
) {
  return (
    c938_data_vertex_coloured.colour
  );
}
