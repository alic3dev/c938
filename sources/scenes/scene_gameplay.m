#include <scenes/scene_gameplay.h>

#include <data/enemy_data.h>
#include <data/player_data.h>
#include <data/projectile_data.h>
#include <data/scene_gameplay_data.h>
#include <generate/generate_buildings.h>
#include <mesh/mesh_hud_item.h>
#include <mesh/mesh_player.h>
#include <objects/object_crosshair.h>
#include <objects/object_enemy.h>
#include <c938_pipeline_index.h>
#include <player.h>
#include <data/player_data.h>
#include <data/projectile_data.h>
#include <textures/textures_buildings.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_group.h>
#include <metil_object.h>
#include <metil_paths/metil_paths.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

#include <rand_clean.h>
#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#if !target_os_ios
#include <CoreAudio/CoreAudio.h>
#else
#include <UIKit/UIKit.h>
#endif

#include <stdlib.h>

void scene_gameplay_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil->rendering_properties.brightness = (
    metil->configuration.rendering_properties.brightness
  );
  metil->rendering_properties.brightness_text = (
    metil->configuration.rendering_properties.brightness_text
  );

  metil_scene_initialize_with_renderables(
    metil,
    scene,
    scene_gameplay_length_renderables
  );

  scene->data = malloc(
    sizeof(struct scene_gameplay_data)
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    scene->data
  );

  scene_gameplay_data->length_projectiles = 0;

  for (
    unsigned char index_projectile = 0;
    index_projectile < scene_gameplay_data_length_projectiles_maximum;
    ++index_projectile
  ) {
    scene_gameplay_data->fired_projectiles[
      index_projectile
    ] = (
      0
    );
  }

  scene->player.poll = player_poll;
  scene->player.poll_input = player_poll_input;
  scene->player.destroy = player_destroy;

  static struct player_data* player_data;

  player_data = malloc(
    sizeof(
      struct player_data
    )
  );

  scene->player.data = player_data;

  scene->poll = scene_gameplay_poll;
  scene->destroy = scene_gameplay_destroy;

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case scene_gameplay_renderables_index_buildings:
      case scene_gameplay_renderables_index_projectiles:
      case scene_gameplay_renderables_index_enemies:
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );
        break;
      default:
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );
        break;
    }
  }

  struct metil_object* object = (
    scene->renderables[
      scene_gameplay_renderables_index_player
    ].renderable
  );

  object->index_pipeline_render = (
    c938_pipeline_index_player
  );

  for (
    unsigned char index_renderable = scene_gameplay_renderables_index_range_hud_start;
    index_renderable < scene_gameplay_renderables_index_range_hud_end + 1;
    ++index_renderable
  ) {
    object = scene->renderables[
      index_renderable
    ].renderable;

    mesh_hud_item_initialize(
      &object->mesh
    );

    metil_object_buffers_initialize(
      object,
      metil->renderer_interface.metal_device
    );

    object->positioning = metil_positioning_static;

    object->index_pipeline_render = (
      c938_pipeline_index_hud_item
    );
  }

  scene->length_textures = 1;
  scene->textures = realloc(
    scene->textures,
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [
    [MTKTextureLoader alloc]
    initWithDevice: metil->renderer_interface.metal_device
  ];

  textures_buildings_load(
    texture_loader,
    scene->textures,
    &metil->paths
  );

  [texture_loader release];

  object = scene->renderables[
    scene_gameplay_renderables_index_player
  ].renderable;

  mesh_player_initialize(
    &object->mesh,
    &metil->player_defaults
  );

  object->positioning = metil_positioning_player;

  metil_object_buffers_initialize(
    object,
    metil->renderer_interface.metal_device
  );

  metil_object_texture_add(
    object,
    scene->textures[
      scene_gameplay_textures_index_player
    ]
  );

  struct metil_renderer_data_object* data = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_boosted
    ].renderable
  );

  data = object->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  data->noise = 2000;

  object->position.x = -0.9f;
  object->position.y = -0.9f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_jumping
    ].renderable
  );

  data = object->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  data->noise = 1.0f;

  object->position.x = -0.9f;
  object->position.y = -0.8f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_jumping_secondary
    ].renderable
  );

  data = object->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  data->noise = 2000;

  object->position.x = -0.9f;
  object->position.y = -0.7f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_crosshair
    ].renderable
  );

  object_crosshair_initialize(
    object,
    metil->renderer_interface.metal_device
  );

  scene_gameplay_populate(
    metil,
    scene,
    scene_gameplay_length_buildings_default
  );

  metil_audio_io_proc_add(
    &metil->audio,
    scene_gameplay_io_proc
  );
}

void scene_gameplay_populate(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned short int length_buildings
) {
  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    10,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  scene->player.speed_movement = (
    metil->player_defaults.speed_movement
  );

  scene->player.velocity.x = 0.0f;
  scene->player.velocity.y = 0.0f;
  scene->player.velocity.z = 0.0f;

  struct scene_gameplay_data* scene_gameplay_data = (
    scene->data
  );

  struct player_data* player_data = (
    scene->player.data
  );

  player_data_initialize(
    player_data,
    metil->rendering_properties.camera.height_default
  );

  player_data->index_target_building = (
    (
      rand_result.bytes[0] *
      rand_result.bytes[1] +
      rand_result.bytes[2]
    ) % (
      length_buildings -
      2
    ) +
    2
  );

  player_data->time = &scene->time;

  scene_gameplay_data->length_projectiles = 0;

  for (
    unsigned char index_projectile = 0;
    index_projectile < scene_gameplay_data_length_projectiles_maximum;
    ++index_projectile
  ) {
    scene_gameplay_data->fired_projectiles[
      index_projectile
    ] = (
      0
    );
  }

  struct metil_group* metil_group_buildings = (
    scene->renderables[
      scene_gameplay_renderables_index_buildings
    ].renderable
  );

  struct metil_group* metil_group_projectiles = (
    scene->renderables[
      scene_gameplay_renderables_index_projectiles
    ].renderable
  );

  metil_group_destroy(
    metil,
    metil_group_projectiles
  );

  metil_group_initialize(
    metil_group_projectiles
  );

  generate_buildings(
    metil,
    metil->renderer_interface.metal_device,
    metil_group_buildings,
    length_buildings,
    player_data->index_target_building,
    scene->textures[
      scene_gameplay_textures_index_buildings
    ]
  );

  struct metil_object* object = (
    metil_group_buildings->renderables[
      scene_gameplay_group_buildings_index_starting
    ]->renderable
  );

  scene->player.position.x = object->position.x;
  scene->player.position.y = (
    object->position.y +
    object->mesh.size.y
  );
  scene->player.position.z = object->position.z;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_player
    ].renderable
  );

  object->position.y = scene->player.position.y;

  player_data->metal_device = (
    metil->renderer_interface.metal_device
  );

  player_data->buildings = (
    metil_group_buildings
  );

  player_data->projectiles = (
    metil_group_projectiles
  );

  player_data->height = (
    metil->rendering_properties.camera.height
  );

  struct metil_group* metil_group_enemies = (
    scene->renderables[
      scene_gameplay_renderables_index_enemies
    ].renderable
  );

  metil_group_destroy(
    metil,
    metil_group_enemies
  );

  metil_group_initialize(
    metil_group_enemies
  );

  float distance_minimum = 200.0f;

  for (
    unsigned char index_enemy = 0;
    index_enemy < 255;
    ++index_enemy
  ) {
    rand_get(
      &rand_source,
      &rand_result,
      &rand_parameters
    );

    metil_group_add_initialize(
      metil_group_enemies,
      metil_renderable_type_object
    );

    struct metil_object* metil_object_enemy = (
      metil_group_enemies->renderables[
        index_enemy
      ]->renderable
    );

    struct math_c_vector3_float position_enemy = {
      .x = (
        1250 - (
          rand_result.bytes[0] *
          rand_result.bytes[1]
        ) % 2500
      ),
      .y = 1000 + (
        rand_result.bytes[2] *
        rand_result.bytes[3]
      ) % 500,
      .z = (
        1250 - (
          rand_result.bytes[4] *
          rand_result.bytes[5]
        ) % 2500
      )
    };

    if (
      position_enemy.x <= distance_minimum &&
      position_enemy.x >= -distance_minimum
    ) {
      float offset = (
        rand_result.bytes[7] +
        distance_minimum
      );

      if (
        position_enemy.x < 0.0f
      ) {
        offset = (
          offset *
          -1
        );
      }

      position_enemy.x = (
        position_enemy.x +
        offset
      );
    }

    if (
      position_enemy.z <= distance_minimum &&
      position_enemy.z >= -distance_minimum
    ) {
      float offset = (
        rand_result.bytes[6] +
        distance_minimum
      );

      if (
        position_enemy.z < 0.0f
      ) {
        offset = (
          offset *
          -1
        );
      }

      position_enemy.z = (
        position_enemy.z +
        offset
      );
    }

    float speed_enemy = (
      (float) (
        rand_result.bytes[8] +
        rand_result.bytes[9]
      ) / 255.0f *
      16.0f +
      32.0f
    );

    object_enemy_initialize(
      metil_object_enemy,
      metil->renderer_interface.metal_device,
      position_enemy,
      4,
      speed_enemy
    );
  }

  rand_clean(
    &rand_result,
    &rand_source
  );
}

void scene_gameplay_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct player_data* player_data = (
    (struct player_data*) scene->player.data
  );

  if (
    player_data->on_ground == (
      player_data->index_target_building +
      1
    )
  ) {
    struct metil_group* metil_group_buildings = (
      scene->renderables[
        scene_gameplay_renderables_index_buildings
      ].renderable
    );

    unsigned short int length_buildings_reduced = (
      metil_group_buildings->length *
      0.9f
    );

    if (
      length_buildings_reduced < 10
    ) {
      length_buildings_reduced = 10;
    }

    scene_gameplay_populate(
      metil,
      scene,
      length_buildings_reduced
    );

    return;
  } else if (
    scene->player.position.y <= 10.0f
  ) {
    scene_gameplay_populate(
      metil,
      scene,
      scene_gameplay_length_buildings_default
    );

    return;
  }

  struct metil_group* metil_group_projectiles = (
    scene->renderables[
      scene_gameplay_renderables_index_projectiles
    ].renderable
  );

  struct metil_group* metil_group_enemies = (
    scene->renderables[
      scene_gameplay_renderables_index_enemies
    ].renderable
  );

  float time_delta_percent = (
    (float) scene->time_delta /
    1000.0f
  );

  for (
    unsigned int index_projectile = 0;
    index_projectile < metil_group_projectiles->length;
  ) {
    struct metil_object* metil_object_projectile = (
      metil_group_projectiles->renderables[
        index_projectile
      ]->renderable
    );

    unsigned int collision = (
      0
    );

    for (
      unsigned char index_enemy = 0;
      index_enemy < metil_group_enemies->length;
      ++index_enemy
    ) {
      struct metil_object* metil_object_enemy = (
        metil_group_enemies->renderables[
          index_enemy
        ]->renderable
      );

      if (
        metil_object_projectile->position.x >= metil_object_enemy->position.x - (metil_object_enemy->mesh.size.x / 2.0f) &&
        metil_object_projectile->position.x <= metil_object_enemy->position.x + (metil_object_enemy->mesh.size.x / 2.0f) &&

        metil_object_projectile->position.y >= metil_object_enemy->position.y - (metil_object_enemy->mesh.size.y / 2.0f) &&
        metil_object_projectile->position.y <= metil_object_enemy->position.y + (metil_object_enemy->mesh.size.y / 2.0f) &&

        metil_object_projectile->position.z >= metil_object_enemy->position.z - (metil_object_enemy->mesh.size.z / 2.0f) &&
        metil_object_projectile->position.z <= metil_object_enemy->position.z + (metil_object_enemy->mesh.size.z / 2.0f)
      ) {
        collision = 1;

        struct enemy_data* enemy_data = (
          metil_object_enemy->buffers_vertex[
            metil_object_buffer_default_index_data
          ].buffer.contents
        );

        enemy_data->life = (
          enemy_data->life -
          1
        );

        if (
          enemy_data->life <= 0
        ) {
          metil_group_destroy_renderable_at_index(
            metil,
            metil_group_enemies,
            index_enemy
          );
        }

        break;
      }
    }

    struct projectile_data* projectile_data = (
      metil_object_projectile->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    projectile_data->time_current = (
      scene->time
    );

    projectile_data->time_delta_percent = (
      time_delta_percent
    );

    if (
      collision == 1 ||
      projectile_data->time_current -
      projectile_data->time_fired >
      projectile_data->lifespan
    ) {
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_projectiles,
        index_projectile
      );
    } else {
      index_projectile = (
        index_projectile +
        1
      );
    }
  }

  for (
    unsigned char index_enemy = 0;
    index_enemy < metil_group_enemies->length;
  ) {
    struct metil_object* metil_object_enemy = (
      metil_group_enemies->renderables[
        index_enemy
      ]->renderable
    );

    if (
      scene->player.position.x >= metil_object_enemy->position.x - (metil_object_enemy->mesh.size.x / 2.0f) &&
      scene->player.position.x <= metil_object_enemy->position.x + (metil_object_enemy->mesh.size.x / 2.0f) &&

      (scene->player.position.y + player_data->height) >= metil_object_enemy->position.y - (metil_object_enemy->mesh.size.y / 2.0f) &&
      (scene->player.position.y + player_data->height) <= metil_object_enemy->position.y + (metil_object_enemy->mesh.size.y / 2.0f) &&

      scene->player.position.z >= metil_object_enemy->position.z - (metil_object_enemy->mesh.size.z / 2.0f) &&
      scene->player.position.z <= metil_object_enemy->position.z + (metil_object_enemy->mesh.size.z / 2.0f)
    ) {
      player_data->life = (
        player_data->life -
        1
      );
      
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_enemies,
        index_enemy
      );

      if (
        player_data->life <= 0
      ) {
        scene_gameplay_populate(
          metil,
          scene,
          scene_gameplay_length_buildings_default
        );

        return;
      }

      continue;
    } else {
      index_enemy = (
        index_enemy +
        1
      );
    }
  }

  metil_scene_poll_default(
    metil,
    scene
  );

  struct metil_object* object = (
    scene->renderables[
      scene_gameplay_renderables_index_player
    ].renderable
  );

  object->position.x = scene->player.position.x;
  object->position.y = scene->player.position.y;
  object->position.z = scene->player.position.z;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_boosted
    ].renderable
  );

  struct metil_renderer_data_object* data = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  if (
    player_data->is_boosted == 1
  ) {
    unsigned long int delta_time_boost = (
      scene->time_input -
      player_data->time_boost
    );

    data->noise = (
      delta_time_boost > 2000
      ? 2000
      : delta_time_boost
    );
  } else {
    data->noise = 2000;
  }

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_jumping
    ].renderable
  );

  data = object->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  data->noise = (
    player_data->is_jumping != 0
    ? 0
    : 2000
  );

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_jumping_secondary
    ].renderable
  );

  data = object->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  data->noise = (
    player_data->is_jumping_secondary != 0
    ? 0
    : 2000
  );
}

void scene_gameplay_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_audio_io_proc_remove(
    &metil->audio,
    scene_gameplay_io_proc
  );

  free(
    scene->data
  );

  scene->data = (
    (void*) 0
  );

  metil_scene_destroy_default(
    metil,
    scene
  );
}


unsigned int b = 100;
unsigned int d = 1000;

float scene_gameplay_io_proc_value_get(
  struct scene_gameplay_data* scene_gameplay_data,
  unsigned long int time_current,
  unsigned long int channel,
  unsigned long int frame
) {
  float value = 0.0f;

  for (
    unsigned int index_projectile = 0;
    index_projectile < scene_gameplay_data->length_projectiles;
  ) {
    unsigned long int time_fired = (
      scene_gameplay_data->fired_projectiles[
        index_projectile
      ]
    );

    unsigned long int v = time_current - time_fired;

    float a = 0.0f;
    
    if (v <= b) {
      a = (float) (
        b - v
      ) / (((float) b) / 2.0f) - 1.0f;
    } else {
      if (v > d) {
        for (
          unsigned int index_projectile_shift = index_projectile;
          index_projectile_shift < scene_gameplay_data->length_projectiles - 1;
          ++index_projectile_shift
        ) {
          scene_gameplay_data->fired_projectiles[
            index_projectile_shift
          ] = (
            scene_gameplay_data->fired_projectiles[
              index_projectile_shift +
              1
            ]
          );
        }

        scene_gameplay_data->length_projectiles = (
          scene_gameplay_data->length_projectiles -
          1
        );

        continue;
      }

      a = ((float) (
        d - v
      ) / (((float) d) / 2.0f) - 1.0f) * 0.5f;
    }

    if (
      v % 2 == 0
    ) {
      a = -a;
    }

    value = (
      value +
      a
    );

    index_projectile = (
      index_projectile +
      1
    );
  }

  if (value > 1.0f) {
    value = (
      value - (
        (float) (
          (unsigned long int) value
        )
      )
    );
  } else if (value < -1.0f) {
    value = (
      value + (
        (float) (
          (unsigned long int) (-value)
        )
      )
    );
  }

  value = (
    value
  );

  return value;
}


#if target_os_ios
int scene_gameplay_io_proc(
  unsigned char silence,
  const AudioTimeStamp* _Nonnull timestamp,
  AVAudioFrameCount frame_count,
  AudioBufferList* _Nonnull output_data,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_gameplay = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  for (
    unsigned int index_frame = 0;
    index_frame < frame_count;
    ++index_frame
  ) {
    for (
      unsigned long int index_buffer = 0;
      index_buffer < output_data->mNumberBuffers;
      ++index_buffer
    ) {
      AudioBuffer audio_buffer_current = output_data->mBuffers[
        index_buffer
      ];

      float* buffer_out = audio_buffer_current.mData;

      buffer_out[
        index_frame
      ] = scene_gameplay_io_proc_value_get(
        scene_gameplay_data,
        metil_scene_gameplay->time,
        index_buffer,
        index_frame
      );
    }
  }
  
  return 0;
}
#else
OSStatus scene_gameplay_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_gameplay = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  for (
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      list_buffer_audio_out->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = audio_buffer_current.mData;

    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      sizeof(float)
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );
    
    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = (
        index_buffer_out %
        count_channel_out
      );

      buffer_out[
        index_buffer_out
      ] = (
        scene_gameplay_io_proc_value_get(
          scene_gameplay_data,
          metil_scene_gameplay->time,
          channel,
          index_buffer_out
        )
      );
    }
  }

  return 0;
}
#endif
