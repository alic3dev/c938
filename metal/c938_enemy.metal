#include <c938_metal/c938_enemy.h>

#include <c938_metal/c938_data_vertex_coloured.h>

#include <data/enemy_data.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct c938_data_vertex_coloured c938_enemy_vertex(
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
  constant struct enemy_data* enemy_data [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct c938_data_vertex_coloured c938_data_vertex_coloured;

  c938_data_vertex_coloured.position = (
    enemy_data->view_model_matrix_projection *
    positions[
      id_vertex
    ]
  );

  c938_data_vertex_coloured.brightness = (
    data_frame->brightness
  );

  float percentage_life = (
    (float) enemy_data->life /
    (float) enemy_data->life_maximum
  );

  c938_data_vertex_coloured.colour = (
    metal::float4(
      (
        enemy_data->colour.x *
        metal::fmin(
          (
            percentage_life *
            2.0f
          ),
          1.0f
        )
      ),
      (
        enemy_data->colour.y *
        percentage_life
      ),
      (
        enemy_data->colour.z *
        percentage_life
      ),
      1.0f
    )
  );

  return (
    c938_data_vertex_coloured
  );
}

[[fragment]] metal::float4 c938_enemy_fragment(
  c938_data_vertex_coloured c938_data_vertex_coloured [[stage_in]]
) {
  return metal::float4(
    (
      c938_data_vertex_coloured.colour.r *
      c938_data_vertex_coloured.brightness
    ),
    (
      c938_data_vertex_coloured.colour.g *
      c938_data_vertex_coloured.brightness
    ),
    (
      c938_data_vertex_coloured.colour.b *
      c938_data_vertex_coloured.brightness
    ),
    c938_data_vertex_coloured.colour.a
  );
}
