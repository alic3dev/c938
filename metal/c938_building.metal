#include <c938_metal/c938_building.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <math_c_bound.h>
#include <math_c_vector_distance.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_textured_coloured c938_building_vertex(
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
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured;

  c938_data_vertex_textured_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  struct math_c_vector3_float vertex_with_translation = {
    .x = (
      data_object->position.x +
      vertices[
        index_vertex
      ].x
    ),
    .y = (
      data_object->position.y +
      vertices[
        index_vertex
      ].y
    ),
    .z = (
      data_object->position.z +
      vertices[
        index_vertex
      ].z
    )
  };

  struct math_c_vector3_float position_player = {
    .x = (
      data_frame->position_player.x
    ),
    .y = (
      data_frame->position_player.y
    ),
    .z = (
      data_frame->position_player.z
    )
  };

  float distance = (
    math_c_vector3_distance_float_fastest(
      &vertex_with_translation,
      &position_player
    )
  );

  c938_data_vertex_textured_coloured.brightness = (
    (
      (
        vertices[
          index_vertex
        ].y >
        0x00
      )
      ? (
        data_frame->brightness *
        (
          (
            vertices[
              index_vertex
            ].z >
            0x00
          )
          ? 0.9f
          : 0x01
        )
      )
      : 0.013f
    ) *
    math_c_bound_float(
      (
        0x01 -
        distance /
        0x2710
      ),
      0x01,
      0.5f
    )
  );

  c938_data_vertex_textured_coloured.colour = metal::float4(
    data_object->colour.x,
    data_object->colour.y,
    data_object->colour.z,
    data_object->colour.w
  );

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_building_fragment(
  c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]]
) {
  float brightness = (
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness *
    c938_data_vertex_textured_coloured.brightness
  );

  return metal::float4(
    (
      c938_data_vertex_textured_coloured.colour.r *
      brightness
    ),
    (
      c938_data_vertex_textured_coloured.colour.g *
      brightness
    ),
    (
      c938_data_vertex_textured_coloured.colour.b *
      brightness
    ),
    (
      c938_data_vertex_textured_coloured.colour.a
    )
  );
}
