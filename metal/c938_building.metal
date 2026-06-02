#include <c938_metal/c938_building.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <math_c_absolute.h>
#include <math_c_bound.h>
#include <math_c_modulus.h>
#include <math_c_vector_distance.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

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
  
  c938_data_vertex_textured_coloured.position_texture.x = (
    index_vertex %
    0x02
  );
  
  c938_data_vertex_textured_coloured.position_texture.y = (
    (int) (
      index_vertex *
      34.234f
    )
    %
    0x02
  );
  
  c938_data_vertex_textured_coloured.colour = (
    float4(
      data_object->colour.x,
      data_object->colour.y,
      data_object->colour.z,
      data_object->colour.w
    )
  );

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_building_fragment(
  c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[stage_in]],
  metal::texture2d<float> texture [[
    texture(
      0x00
    )
  ]],
  metal::texture2d<float> texture_two [[
    texture(
      0x01
    )
  ]],
  metal::texture2d<float> texture_three [[
    texture(
      0x02
    )
  ]],
  metal::texture2d<float> texture_four [[
    texture(
      0x03
    )
  ]]
) {
  float brightness = (
    c938_data_vertex_textured_coloured.brightness
  );
  
  constexpr metal::sampler sampler(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );
  
  constexpr metal::sampler sampler_no_repeat(
    metal::mag_filter::linear
  );
  
  float4 sample = (
    texture.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture *
        0.1f
      )
    ) *
    texture_two.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture *
        0.1f
      )
    ) *
    texture_three.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture *
        0.1f
      )
    ) *
    texture_four.sample(
      sampler,
      (
        c938_data_vertex_textured_coloured.position_texture *
        0.1f
      )
    )
  );
  
  sample = (
    float4(
      (
        c938_data_vertex_textured_coloured.colour.x *
        brightness
      ),
      (
        c938_data_vertex_textured_coloured.colour.y *
        brightness
      ),
      (
        c938_data_vertex_textured_coloured.colour.z *
        brightness
      ),
      (
        c938_data_vertex_textured_coloured.colour.w
      )
    ) *
    sample
  );
  
  if (
    c938_data_vertex_textured_coloured.colour.x !=
    0x01
  ) {
    sample = (
      sample *
      1.125f
    );
    
    float max = (
      sample.x
    );
    
    if (
      max <
      sample.y
    ) {
      max = (
        sample.y
      );
    }
    
    if (
      max <
      sample.z
    ) {
      max = (
        sample.z
      );
    }
    
    sample.x = (
      max
    );
    
    sample.y = (
      max
    );
    
    sample.z = (
      max
    );
    
    float2 position_sample = (
      (
        c938_data_vertex_textured_coloured.position_texture +
        (
          0.23f +
          (float)
          (
            (unsigned int)
            (
              math_c_absolute_float(
                c938_data_vertex_textured_coloured.position.x
              ) +
              math_c_absolute_float(
                c938_data_vertex_textured_coloured.position.y
              )
            ) %
            0x0a
          ) *
          0.1f
        )
      )
    );
    
    position_sample.x = (
      math_c_modulus_mirror_float(
        position_sample.x,
        0x01
      )
    );
    
    position_sample.y = (
      math_c_modulus_mirror_float(
        position_sample.y * 0x03,
        0x01
      )
    );  
      
    float4 sample_additional = (
      texture_four.sample(
        sampler_no_repeat,
        position_sample * 0x05
      ) *
      0.05f
    );
    
    if (
      (
        sample_additional.x >
        sample_additional.y
      ) &&
      (
        sample_additional.x >
        sample_additional.z
      )
    ) {
      sample_additional.y = (
        0x00
      );
      
      sample_additional.z = (
        0x00
      );
    } else if (
      (
        sample_additional.y >
        sample_additional.x
      ) &&
      (
        sample_additional.y >
        sample_additional.z
      )
    ) {
      sample_additional.x = (
        0x00
      );
      
      sample_additional.z = (
        0x00
      );
    } else {
      sample_additional.x = (
        0x00
      );
      
      sample_additional.y = (
        0x00
      );
    }
    
    sample_additional = (
      sample_additional *
      0.25f
    );
    
    if (
      sample_additional.x !=
      0x00
    ) {
      sample_additional.x = (
        sample_additional.x +
        0.75f
      );
    }
    
    if (
      sample_additional.y !=
      0x00
    ) {
      sample_additional.y = (
        sample_additional.y +
        0.75f
      );
    }
    
    sample_additional.z = (
        math_c_modulus_mirror_float(
          (
            sample_additional.x +
            sample_additional.y
          ),
          0x01
        )
      );
    
    
    if (
      sample_additional.z <
      0.755f
    ) {
      sample_additional.z = (
        0x00
      );
    } else {
      sample_additional.z = (
        sample_additional.z *
        0.5f +
        0.5f
      );
    }
    
    if (
      sample_additional.x >
      0x00
    ) {
      sample_additional.x = (
        0x00
      );
    } 
    
    sample = (
      sample +
      sample_additional *
      0.25f
    );
  }
  
  sample.w = (
    0x01
  );
  
  return (
    sample
  );
}
