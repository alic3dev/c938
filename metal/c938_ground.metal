#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
};

[[vertex]] struct data_vertex c938_ground_vertex(
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

  data_vertex.position_texture.x = positions[id_vertex].z;
  data_vertex.position_texture.y = positions[id_vertex].x;

  data_vertex.brightness = (
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

  return data_vertex;
}

[[fragment]] float4 c938_ground_fragment(
  data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  float4 color_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture / 1000.0f
    )
  );

  return float4(
    color_texture[0] * data_vertex.brightness,
    color_texture[1] * data_vertex.brightness,
    color_texture[2] * data_vertex.brightness,
    color_texture[3]
  );
}
