#include <metal_kit_shader_types.h>

#include <metal_stdlib>

struct output_vertex {
  float4 position [[position]];
  float distance;
  float height;
  float2 position_texture;
  unsigned char mode_texture;
  unsigned char index_texture;
  unsigned int id;
  float brightness;
  float3 color;
};

[[vertex]] output_vertex c938_vertex(
  const device simd_float4* positions [[buffer(metal_kit_vertex_input_index_positions)]],
  constant metal_kit_data_frame& data_frame [[buffer(metal_kit_vertex_input_index_frame_data)]],
  constant metal_kit_data_frame_object& data [[buffer(metal_kit_vertex_input_index_data)]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct output_vertex output_vertex;

  output_vertex.brightness = data_frame.brightness;
  output_vertex.height = 0.0f;
  output_vertex.id = data.id;
  output_vertex.mode_texture = data.mode_texture;
  output_vertex.position = data.view_model_matrix_projection * positions[id_vertex];

  if (
    data.mode_texture == mode_texture_text
  ) {
    output_vertex.index_texture = 0;
    output_vertex.brightness = data_frame.brightness_text;

    output_vertex.position_texture.x = (
      id_vertex == 0 || id_vertex == 3
      ? 0
      : 1
    );

    output_vertex.position_texture.y = (
      id_vertex == 0 || id_vertex == 1
      ? 1
      : 0
    );

    return output_vertex;
  }

  if (
    data.mode_texture == mode_texture_ground
  ) {
    float3 size_half;
    size_half.x = (data.width / 2.0f);
    size_half.y = (data.height / 2.0f);
    size_half.z = (data.depth / 2.0f);

    output_vertex.brightness = 0.0125f;

    if (
      (
        (positions[id_vertex].x + size_half.x) < data.width * 0.12f ||
        (positions[id_vertex].x + size_half.x) > data.width * 0.88f
      ) || (
        (positions[id_vertex].z + size_half.z) < data.depth * 0.12f ||
        (positions[id_vertex].z + size_half.z) > data.depth * 0.88f
      )
    ) {
      output_vertex.index_texture = 1;
      output_vertex.position_texture = float2(
        ((float) data_frame.frame / 5000.0f) + (positions[id_vertex].x + size_half.x) / (data.width / 50.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 50.0f),
        ((float) data_frame.frame / 5000.0f) + (positions[id_vertex].z + size_half.z) / (data.depth / 50.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 50.0f)
      );
    } else {
      output_vertex.index_texture = 0;
      output_vertex.position_texture = float2(
        (id_vertex / 10) % 10 == 0 
        ? ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].x + size_half.x) / (data.width / 1.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 5.0f)
        : ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].x + size_half.x) / (data.width / 500.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 500.0f),
        (id_vertex / 10) % 10 == 0 
        ? ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].z + size_half.z) / (data.depth / 1.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 5.0f)
        : ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].z + size_half.z) / (data.depth / 500.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 500.0f)
      );
    }

    unsigned char z = 0;
    unsigned char x = 0;

    while (output_vertex.position_texture.x > 1.0f) {
      output_vertex.position_texture.x = (
        output_vertex.position_texture.x - 1.0f
      );

      z = z == 0 ? 1 : 0;
    }

    while (output_vertex.position_texture.y > 1.0f) {
      output_vertex.position_texture.y = (
        output_vertex.position_texture.y - 1.0f
      );

      x = x == 0 ? 1 : 0;
    }

    if (z == 1) {
      output_vertex.position_texture.x = 1.0f - (
        output_vertex.position_texture.x
      );
    }

    if (x == 1) {
      output_vertex.position_texture.y = 1.0f - (
        output_vertex.position_texture.y
      );
    }

    if (positions[id_vertex].y <= data.height / 20.0f) {
      output_vertex.height = positions[id_vertex].y / (data.height / 20.0f) * 0.5f;
    } else {
      output_vertex.height = (positions[id_vertex].y / data.height) * 0.4;
    }
  } else if (
    data.mode_texture == mode_texture_building
  ) {
    output_vertex.index_texture = 0;

    output_vertex.position_texture.x = (
      id_vertex == 4 ||
      id_vertex == 6 ||

      id_vertex == 0 ||
      id_vertex == 1
    ) ? 0 : 1;
    output_vertex.position_texture.y = (
      id_vertex == 6 ||
      id_vertex == 7 ||

      id_vertex == 1 ||
      id_vertex == 3
    ) ? 0 : 1;

    output_vertex.brightness = id_vertex > 3 ? 1.0f : 0.0125f;
  } else if (
    data.mode_texture == mode_texture_player
  ) {
    output_vertex.index_texture = 0;

    if (id_vertex == 0) {
      output_vertex.position_texture.x = 0.5f;
      output_vertex.position_texture.y = metal::fabs(1.0f - (float)(data_frame.frame % 221) / 110.0f);
    } else {
      output_vertex.position_texture.x = (float) ((id_vertex - 1)) / 6.0f;
      
      if (output_vertex.position_texture.x > 1.0f) {
        output_vertex.position_texture.x = 1.0f - (output_vertex.position_texture.x - 1.0f);
      }

      output_vertex.position_texture.y = metal::fabs(((float)(data_frame.frame % 667) / 333.0f) - 1.0f);
    }
  } else {
    output_vertex.index_texture = 0;
    output_vertex.height = positions[id_vertex].y / data.height;

    if (positions[id_vertex].x > data.width || positions[id_vertex].z > data.depth) {
      output_vertex.height = metal::fmin(positions[id_vertex].y / data.height * 0.2f, 0.2f);
      output_vertex.position_texture.y = id_vertex % 2 == 0 ? 1.0f : 0.0f;
      output_vertex.position_texture.x = (float)((unsigned short int)(metal::fabs(positions[id_vertex].x + positions[id_vertex].z) * 10000.0f) % 74) / 74.0f;
    } else {
      output_vertex.height = metal::fmin(positions[id_vertex].y / data.height * 0.8, 0.2f);
      output_vertex.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
      output_vertex.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (data.width * 2.0f);
    }
  }

  output_vertex.distance = (
    metal::fabs((data.position.x + positions[id_vertex].x) - data_frame.position_player.x) + 
    metal::fabs((data.position.y + positions[id_vertex].y) - data_frame.position_player.y) + 
    metal::fabs((data.position.z + positions[id_vertex].z) - data_frame.position_player.z)
  );

  return output_vertex;
}

[[fragment]] float4 c938_fragment(
  output_vertex in [[stage_in]],
  metal::texture2d<half> texture_primary [[ texture(0) ]],
  metal::texture2d<half> texture_secondary [[ texture(1) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  metal::texture2d<half> texture = (
    in.index_texture == 0
    ? texture_primary
    : texture_secondary
  );

  float4 color_texture = float4(
    texture.sample(
      sampler_texture,
      in.position_texture
    )
  );

  float brightness = (
    in.brightness * 
    metal::fmax(
      1.0f - (in.distance / 1000.0f),
      0.25f
    )
  );

  if (in.mode_texture == mode_texture_text) {
    return float4(
      color_texture[0] * in.color.r * brightness,
      color_texture[1] * in.color.g * brightness,
      color_texture[2] * in.color.b * brightness,
      color_texture[3]
    );
  }
  
  if (in.mode_texture == mode_texture_player) {
    return float4(
      color_texture[0] * brightness * 0.02f * 0.0f,
      color_texture[1] * brightness * 0.019f * 0.0f,
      color_texture[2] * brightness * 0.02f * 0.0f,
      color_texture[3]
    );
  }
  
  if (in.mode_texture == mode_texture_building) {
    //brightness = 1.0f;

    color_texture[0] = color_texture[0] * 0.6f + 0.4;
      color_texture[1] = color_texture[1] * 0.5f + 0.5;
      color_texture[2] = color_texture[2] * 0.5f + 0.5;

    if (in.id == 3) {
      color_texture[0] = color_texture[0] * 0.3f + 0.7;
      color_texture[1] = color_texture[1] * 0.4f + 0.5;
      color_texture[2] = color_texture[2] * 0.4f + 0.5;
    }

    /*
    switch (in.id % 3) {
      case 0:
        color_texture[0] = color_texture[0] * 0.3f + 0.2;
        color_texture[1] = color_texture[1] * 0.4f + 0.25;
        color_texture[2] = color_texture[2] * 0.5f + 0.25;
        break;
      case 1:
        color_texture[0] = color_texture[0] * 0.3f + 0.2;
        color_texture[1] = color_texture[1] * 0.4f + 0.25;
        color_texture[2] = color_texture[2] * 0.5f + 0.2;
        break;
      case 2:
        color_texture[0] = color_texture[0] * 0.3f + 0.2;
        color_texture[1] = color_texture[1] * 0.4f + 0.2;
        color_texture[2] = color_texture[2] * 0.5f + 0.25;
        break;
    }
    */
  }

  return float4(
    color_texture[0] * brightness,
    color_texture[1] * brightness,
    color_texture[2] * brightness,
    color_texture[3]
  );
}
