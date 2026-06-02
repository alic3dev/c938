#include <c938_metal/c938_ground.h>

#include <c938_metal/c938_data_vertex_textured.h>

#include <math_c_absolute.h>
#include <math_c_maximum.h>
#include <math_c_minimum.h>
#include <math_c_modulus.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured c938_sky_vertex(
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
  unsigned int index_vertex [[vertex_id]]
) {
  struct c938_data_vertex_textured c938_data_vertex_textured;

  c938_data_vertex_textured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  c938_data_vertex_textured.brightness = (
    data_frame->brightness *
    0x01
  );
  
  c938_data_vertex_textured.position_texture.x = (
    math_c_modulus_mirror_float(
      math_c_absolute_float(vertices[
        index_vertex
      ].x) + math_c_absolute_float(vertices[
      index_vertex].z),
      0x01
    ) 
  );
  
  c938_data_vertex_textured.position_texture.y = (
    math_c_modulus_mirror_float(
      vertices[
        index_vertex
      ].y,
      0x01
    ) 
  );

  return (
    c938_data_vertex_textured
  );
}

[[fragment]] metal::float4 c938_sky_fragment(
  c938_data_vertex_textured c938_data_vertex_textured [[stage_in]],
  metal::texture2d<float> texture [[
    texture(
      0x00
    )
  ]],
  metal::texture2d<float> texture_one [[
    texture(
      0x01
    )
  ]],
  metal::texture2d<float> texture_two [[
    texture(
      0x02
    )
  ]]
) {
  constexpr metal::sampler sampler(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  return float4(
    c938_data_vertex_textured.brightness,
    c938_data_vertex_textured.brightness,
    c938_data_vertex_textured.brightness,
    0x01
  ) * texture.sample(sampler,  c938_data_vertex_textured.position_texture )*
  texture_one.sample(sampler,  c938_data_vertex_textured.position_texture) * 
  texture_two.sample(sampler,  c938_data_vertex_textured.position_texture)    ;}
