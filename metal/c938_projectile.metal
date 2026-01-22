#include <c938_metal/c938_projectile.h>

#include <c938_metal/c938_data_vertex_coloured.h>

#include <data/projectile_data.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_coloured c938_projectile_vertex(
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
  constant struct projectile_data* projectile_data [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct c938_data_vertex_coloured c938_data_vertex_coloured;

  c938_data_vertex_coloured.position = (
    projectile_data->view_model_matrix_projection *
    positions[id_vertex]
  );

  c938_data_vertex_coloured.brightness = (
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

  c938_data_vertex_coloured.colour = metal::float4(
    projectile_data->colour.x,
    projectile_data->colour.y,
    projectile_data->colour.z,
    (1.0f - percentage_lifespan) *
    metal::fmin(
      id_vertex,
      1.0f
    )
  );

  return c938_data_vertex_coloured;
}

[[fragment]] metal::float4 c938_projectile_fragment(
  c938_data_vertex_coloured c938_data_vertex_coloured [[stage_in]]
) {
  return metal::float4(
    c938_data_vertex_coloured.colour.r * c938_data_vertex_coloured.brightness,
    c938_data_vertex_coloured.colour.g * c938_data_vertex_coloured.brightness,
    c938_data_vertex_coloured.colour.b * c938_data_vertex_coloured.brightness,
    c938_data_vertex_coloured.colour.a
  );
}
