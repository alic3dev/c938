#include <data/projectile_data.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float brightness;
  float4 colour;
};

[[vertex]] struct data_vertex c938_projectile_vertex(
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
  constant struct projectile_data* projectile_data [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    projectile_data->view_model_matrix_projection *
    positions[id_vertex]
  );

  data_vertex.brightness = (
    data_frame->brightness
  );

  float percentage_lifespan = (
    metal::fmax(
      metal::fmin(
        (
          (float) (
            projectile_data->time_current -
            projectile_data->time_fired
          ) /
          projectile_data->lifespan
        ),
        1.0f
      ),
      0.0f
    )
  );

  data_vertex.colour = float4(
    projectile_data->colour.x,
    projectile_data->colour.y,
    projectile_data->colour.z,
    (1.0f - percentage_lifespan) *
    metal::fmin(
      id_vertex,
      1.0f
    )
  );

  return data_vertex;
}

[[fragment]] float4 c938_projectile_fragment(
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
