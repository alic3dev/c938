#include <c938_metal/c938_ground.h>

#include <c938_metal/c938_data_vertex_textured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured c938_ground_vertex(
  const device metal::float4* positions [[
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
  struct c938_data_vertex_textured c938_data_vertex_textured;

  c938_data_vertex_textured.position = (
    data_object->view_model_matrix_projection *
    positions[id_vertex]
  );

  c938_data_vertex_textured.position_texture.x = positions[id_vertex].z;
  c938_data_vertex_textured.position_texture.y = positions[id_vertex].x;

  c938_data_vertex_textured.brightness = (
    data_frame->brightness *
    metal::fmax(
      metal::fmin(
        1.0f - (
          (
            positions[
              id_vertex
            ].z +
            data_object->size.z / 2.0f
          ) /
          data_object->size.z *
          8.0f
        ),
        1.0f
      ) *
      0.5f,
      0.0f
    ) *
    0.013
  );

  return c938_data_vertex_textured;
}

[[fragment]] metal::float4 c938_ground_fragment(
  c938_data_vertex_textured c938_data_vertex_textured [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  metal::float4 colour_texture = metal::float4(
    texture.sample(
      sampler_texture,
      c938_data_vertex_textured.position_texture / 1000.0f
    )
  );

  return metal::float4(
    colour_texture[0] * c938_data_vertex_textured.brightness,
    colour_texture[1] * c938_data_vertex_textured.brightness,
    colour_texture[2] * c938_data_vertex_textured.brightness,
    colour_texture[3]
  );
}
