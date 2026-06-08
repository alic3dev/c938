#include <c938_metal/c938_projectile.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <data/projectile_data.h>

#include <math_c_absolute.h>
#include <math_c_bound.h>
#include <math_c_maximum.h>
#include <math_c_minimum.h>
#include <math_c_modulus.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_projectile_vertex(
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
  constant struct projectile_data* projectile_data [[
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
    projectile_data->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );
  
  c938_data_vertex_textured_coloured.position_texture.x = (
    (
      math_c_modulus_mirror_float(
        math_c_absolute_float(
          (
            projectile_data->position_previous.x +
            projectile_data->position_previous.z
          ) *
          0x01
        ),
        0x0b
      ) +
      0x01
    ) +
    (
      math_c_absolute_float(
        vertices[
          index_vertex
        ].x
      ) +
      math_c_absolute_float(
        vertices[
          index_vertex
        ].z
      ) +
      0x01
    )
  );
  
  c938_data_vertex_textured_coloured.position_texture.y = (
    (
      math_c_modulus_mirror_float(
        math_c_absolute_float(
          (
            projectile_data->position_previous.y
          ) *
          0x01
        ),
        0x0b
      ) +
      0x01
    ) +
    (
      math_c_absolute_float(
        vertices[
          index_vertex
        ].y
      ) +
      0x01
    )
  );
  
  c938_data_vertex_textured_coloured.brightness = (
    data_frame->brightness *
    (
      0x01 -
      (
        index_vertex /
        0x05
      )
    )
  );

  float percentage_lifespan = (
    math_c_bound_float(
      (
        (float)
        (
          projectile_data->time_current -
          projectile_data->time_fired
        ) /
        projectile_data->lifespan
      ),
      0x01,
      0x00
    )
  );

  c938_data_vertex_textured_coloured.colour = (
    float4(
      projectile_data->colour.x,
      projectile_data->colour.y,
      projectile_data->colour.z,
      (
        (
          0x01 -
          percentage_lifespan
        ) *
        math_c_minimum_float(
          index_vertex,
          0x01
        )
      )
    )
  );

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_projectile_fragment(
  c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[
    stage_in
  ]],
  metal::texture2d<float> texture_projectile [[
    texture(
      0x00
    )
  ]]
) {
  constexpr metal::sampler sampler(
    metal::r_address::repeat,
    metal::s_address::repeat,
    metal::t_address::repeat
  );
  
  float4 sample = (
    texture_projectile.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture /
        0x03
      )
    ) +
    texture_projectile.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture /
        0x04
      )
    ) +
    texture_projectile.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture /
        0x02
      )
    ) +
    texture_projectile.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture /
        0x64
      )
    )
  );
  
  float4 colour = (
    metal::float4(
      (
        c938_data_vertex_textured_coloured.colour.r *
        c938_data_vertex_textured_coloured.brightness
      ),
      (
        c938_data_vertex_textured_coloured.colour.g *
        c938_data_vertex_textured_coloured.brightness
      ),
      (
        c938_data_vertex_textured_coloured.colour.b *
        c938_data_vertex_textured_coloured.brightness
      ),
      c938_data_vertex_textured_coloured.colour.a
    )
  );
  
  sample = (
    sample +
    colour
  );
  
  return (
    float4(
      math_c_modulus_mirror_float(
        sample.x,
        0x01
      ),
      math_c_modulus_mirror_float(
        sample.y,
        0x01
      ),
      math_c_modulus_mirror_float(
        sample.z,
        0x01
      ),
      colour.w
    )
  );
}
