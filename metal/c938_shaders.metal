#include <mode_texture.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  unsigned int id;

  float4 position [[position]];
  float distance;
  float height;
  
  float2 position_texture;
  unsigned char index_texture;
  unsigned char mode_texture;
  
  float brightness;
  float3 color;
};

[[vertex]] struct data_vertex c938_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_positions
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

  data_vertex.id = data_object->id;
  data_vertex.height = 0.0f;
  data_vertex.position = (
    data_object->view_model_matrix_projection *
    positions[id_vertex]
  );
  data_vertex.brightness = data_frame->brightness;
  data_vertex.mode_texture = data_object->mode_texture;

  if (
    data_object->mode_texture == mode_texture_text
  ) {
    data_vertex.index_texture = 0;
    data_vertex.brightness = (
      data_object->noise == 1
      ? data_frame->brightness_text / 4.0f
      : data_frame->brightness_text
    );

    data_vertex.position_texture.x = (
      id_vertex == 0 || id_vertex == 3
      ? 0
      : 1
    );

    data_vertex.position_texture.y = (
      id_vertex == 0 || id_vertex == 1
      ? 1
      : 0
    );

    return data_vertex;
  }

  if (
    data_object->mode_texture == mode_texture_ground ||
    data_object->mode_texture == mode_texture_building
  ) {
    data_vertex.index_texture = 0;

    data_vertex.position_texture.x = (
      id_vertex == 4 ||
      id_vertex == 6 ||

      id_vertex == 0 ||
      id_vertex == 1
    ) ? 0 : 1;

    data_vertex.position_texture.y = (
      id_vertex == 6 ||
      id_vertex == 7 ||

      id_vertex == 1 ||
      id_vertex == 3
    ) ? 0 : 1;

    data_vertex.brightness = (
      id_vertex > 3 && data_object->mode_texture == mode_texture_building
      ? 1.0f
      : 0.125f
    );
  } else if (
    data_object->mode_texture == mode_texture_player
  ) {
    data_vertex.index_texture = 0;

    if (
      id_vertex == 0
    ) {
      data_vertex.position_texture.x = 0.5f;
      data_vertex.position_texture.y = metal::fabs(1.0f - (float)(data_frame->frame % 221) / 110.0f);
    } else {
      data_vertex.position_texture.x = (float) ((id_vertex - 1)) / 6.0f;
      
      if (
        data_vertex.position_texture.x > 1.0f
      ) {
        data_vertex.position_texture.x = 1.0f - (data_vertex.position_texture.x - 1.0f);
      }

      data_vertex.position_texture.y = metal::fabs(((float)(data_frame->frame % 667) / 333.0f) - 1.0f);
    }
  } else {
    data_vertex.index_texture = 0;
    data_vertex.height = positions[id_vertex].y / data_object->height;

    if (
      positions[id_vertex].x > data_object->width ||
      positions[id_vertex].z > data_object->depth
    ) {
      data_vertex.height = metal::fmin(positions[id_vertex].y / data_object->height * 0.2f, 0.2f);
      data_vertex.position_texture.y = id_vertex % 2 == 0 ? 1.0f : 0.0f;
      data_vertex.position_texture.x = (float)((unsigned short int)(metal::fabs(positions[id_vertex].x + positions[id_vertex].z) * 10000.0f) % 74) / 74.0f;
    } else {
      data_vertex.height = metal::fmin(positions[id_vertex].y / data_object->height * 0.8, 0.2f);
      data_vertex.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
      data_vertex.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (data_object->width * 2.0f);
    }
  }

  if (
    data_object->mode_texture == mode_texture_hud_item
  ) {
    data_vertex.color.r = (float) (2000 - data_object->noise) / 2000.0f;
    data_vertex.color.g = (float) data_object->noise / 2000.0f;
    data_vertex.color.b = (float) (data_object->noise % 2000) / 2000.0f;
  }

  data_vertex.distance = (
    metal::fabs((data_object->position.x + positions[id_vertex].x) - data_frame->position_player.x) + 
    metal::fabs((data_object->position.y + positions[id_vertex].y) - data_frame->position_player.y) + 
    metal::fabs((data_object->position.z + positions[id_vertex].z) - data_frame->position_player.z)
  );

  return data_vertex;
}

[[fragment]] float4 c938_fragment(
  data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture_primary [[texture(0)]],
  metal::texture2d<half> texture_secondary [[texture(1)]]
) {
  if (
    data_vertex.mode_texture == mode_texture_hud_item
  ) {
    return float4(
      data_vertex.color.r * data_vertex.brightness,
      data_vertex.color.g * data_vertex.brightness,
      data_vertex.color.b * data_vertex.brightness,
      1.0f
    );
  }

  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  metal::texture2d<half> texture = (
    data_vertex.index_texture == 0
    ? texture_primary
    : texture_secondary
  );

  float4 color_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  float brightness = (
    data_vertex.brightness * 
    metal::fmax(
      1.0f - (data_vertex.distance / 1000.0f),
      0.25f
    )
  );

  if (
    data_vertex.mode_texture == mode_texture_text
  ) {
    return float4(
      color_texture[0] * brightness,
      color_texture[1] * brightness,
      color_texture[2] * brightness,
      color_texture[3]
    );
  }
  
  if (
    data_vertex.mode_texture == mode_texture_player
  ) {
    return float4(
      color_texture[0] * brightness * 0.02f * 0.0f,
      color_texture[1] * brightness * 0.019f * 0.0f,
      color_texture[2] * brightness * 0.02f * 0.0f,
      color_texture[3]
    );
  }
  
  if (
    data_vertex.mode_texture == mode_texture_building
  ) {
    color_texture[0] = color_texture[0] * 0.6f + 0.4;
    color_texture[1] = color_texture[1] * 0.5f + 0.5;
    color_texture[2] = color_texture[2] * 0.5f + 0.5;

    if (
      data_vertex.id == 3
    ) {
      color_texture[0] = color_texture[0] * 0.3f + 0.7;
      color_texture[1] = color_texture[1] * 0.4f + 0.5;
      color_texture[2] = color_texture[2] * 0.4f + 0.5;
    }
  }

  return float4(
    color_texture[0] * brightness,
    color_texture[1] * brightness,
    color_texture[2] * brightness,
    color_texture[3]
  );
}
