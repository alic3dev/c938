#include <c938_metal/c938_default.h>

#include <c938_metal/c938_data_vertex_textured_coloured.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metal_texture>

[[vertex]] struct c938_data_vertex_textured_coloured c938_gun_vertex(
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

  c938_data_vertex_textured_coloured.brightness = (
    data_frame->brightness *
    (((int) ((
      vertices[
        index_vertex
      ].x +
      vertices[
        index_vertex
      ].y +
      vertices[
        index_vertex
      ].z
    ) *
    0x64
    ) %
    0x65
    ) /
    0x64 *
    0.5f +
    0.5f
    )
  );
  
  float colour = (
    (float)
    (
      (
        index_vertex *
        0x03
      ) %
      0x08
    ) /
    0x07 *
    0.7f +
    0.3f
  );
  
  c938_data_vertex_textured_coloured.colour.x = (
    0.2f *
    colour *
    c938_data_vertex_textured_coloured.brightness
  );
  
  c938_data_vertex_textured_coloured.colour.y = (
    0.25f *
    colour *
    c938_data_vertex_textured_coloured.brightness
  );
  
  c938_data_vertex_textured_coloured.colour.z = (
    colour *
    c938_data_vertex_textured_coloured.brightness
  );
  
  c938_data_vertex_textured_coloured.colour.w = (
    0x01
  );
  
  c938_data_vertex_textured_coloured.position_texture.x = (
    vertices[
      index_vertex
    ].x +
    math_c_sine(
      data_frame->rotation_camera.y,
      math_c_pi
    ) /
    0x0f +
    data_frame->position_player.x /
    0xffff
  );
  
  c938_data_vertex_textured_coloured.position_texture.y = (
    vertices[
      index_vertex
    ].y +
    math_c_sine(
      data_frame->rotation_camera.x,
      math_c_pi
    ) /
    0x0f +
    data_frame->position_player.y /
    0xffff
  );    

  return (
    c938_data_vertex_textured_coloured
  );
}

[[fragment]] metal::float4 c938_gun_fragment(
  struct c938_data_vertex_textured_coloured c938_data_vertex_textured_coloured [[
    stage_in
  ]],
  metal::texture2d<float> texture_gun [[
    texture(
      0x00
    )
  ]]
) {
  constexpr metal::sampler sampler(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );
  
  float4 grid = (
    texture_gun.sample(
      sampler,
      c938_data_vertex_textured_coloured.position_texture *
      0.75f
    )
  );
  
  if (
    grid.x >
    0.5f
  ) {
    grid.x = (
      0x01
    );
    
    grid.y = (
      0x01
    );
    
    grid.z = (
      0x01
    );
  } else {
    grid.x = (
      0x00
    );
    
    grid.y = (
      0x00
    );
    
    grid.z = (
      grid.z *
      0.5f
    );
  }

  return (
    c938_data_vertex_textured_coloured.colour *
    texture_gun.sample(
      sampler,
      c938_data_vertex_textured_coloured.position_texture /
      0x0a
    ) *
    texture_gun.sample(
      sampler,
      (
        (
          c938_data_vertex_textured_coloured.position_texture +
          c938_data_vertex_textured_coloured.position_texture
        ) *
        0x64
      )
    ) *
    grid
  );}
