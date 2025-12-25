#include <scenes/scene_gameplay.h>

#include <generate/generate_buildings.h>
#include <mesh/mesh_hud_item.h>
#include <mesh/mesh_player.h>
#include <objects/object_crosshair.h>
#include <pipeline_index.h>
#include <player.h>
#include <player_data.h>
#include <textures/textures_buildings.h>

#include <metil_audio/metil_audio_io_proc.h>
#include <metil_debug/log.h>
#include <metil_group.h>
#include <metil_object.h>
#include <metil_paths/paths.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/scene.h>

#include <stdlib.h>

void scene_gameplay_initialize(
  struct metil_scene* scene,
  struct metil_renderer_interface* renderer_interface
) {
  metil_scene_initialize_with_renderables(
    scene,
    renderer_interface,
    7
  );

  #if !target_os_ios
  metil_audio_io_proc_add(
    scene_gameplay_io_proc
  );
  #endif

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
      scene->renderer_interface->metal_device
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
    initWithDevice: scene->renderer_interface->metal_device
  ];

  textures_buildings_load(
    texture_loader,
    scene->textures
  );

  [texture_loader release];

  object = scene->renderables[
    scene_gameplay_renderables_index_player
  ].renderable;

  mesh_player_initialize(
    &object->mesh
  );

  object->positioning = metil_positioning_player;

  metil_object_buffers_initialize(
    object,
    scene->renderer_interface->metal_device
  );

  metil_object_texture_add(
    object,
    scene->textures[
      scene_gameplay_textures_index_player
    ]
  );

  struct metil_renderer_data_object* data = (
    object->data.contents
  );

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_boosted
    ].renderable
  );

  data = object->data.contents;

  data->noise = 2000;

  object->position.x = -0.9f;
  object->position.y = -0.9f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_jumping
    ].renderable
  );

  data = object->data.contents;

  data->noise = 1.0f;

  object->position.x = -0.9f;
  object->position.y = -0.8f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      scene_gameplay_renderables_index_hud_jumping_secondary
    ].renderable
  );

  data = object->data.contents;

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
    scene->renderer_interface->metal_device
  );

  scene_gameplay_populate(
    scene,
    scene_gameplay_length_buildings_default
  );
}

void scene_gameplay_populate(
  struct metil_scene* scene,
  unsigned short int length_buildings
) {
  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  scene->player.speed_movement = (
    metil_player_speed_movement_default
  );

  scene->player.velocity.x = 0.0f;
  scene->player.velocity.y = 0.0f;
  scene->player.velocity.z = 0.0f;

  struct player_data* player_data = (
    (struct player_data*) scene->player.data
  );

  player_data_initialize(
    player_data
  );

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
    metil_group_projectiles
  );

  metil_group_initialize(
    metil_group_projectiles
  );

  generate_buildings(
    scene->renderer_interface->metal_device,
    metil_group_buildings,
    length_buildings,
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
    scene->renderer_interface->metal_device
  );

  player_data->buildings = (
    metil_group_buildings
  );

  player_data->projectiles = (
    metil_group_projectiles
  );

  player_data->height = (
    scene->renderer_interface->rendering_properties->camera.height
  );
}

void scene_gameplay_poll(
  struct metil_scene* scene
) {
  struct player_data* player_data = (
    (struct player_data*) scene->player.data
  );

  if (
    player_data->on_ground == scene_gameplay_group_buildings_index_target
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
      scene,
      length_buildings_reduced
    );

    return;
  } else if (
    scene->player.position.y <= 10.0f
  ) {
    scene_gameplay_populate(
      scene,
      scene_gameplay_length_buildings_default
    );

    return;
  }

  metil_scene_poll_default(
    scene
  );

  struct metil_group* metil_group_projectiles = (
    scene->renderables[
      scene_gameplay_renderables_index_projectiles
    ].renderable
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

    struct metil_renderer_data_object* metil_renderer_data_object = (
      metil_object_projectile->data.contents
    );

    if (
      metil_renderer_data_object->noise == 0
    ) {
      metil_group_destroy_renderable_at_index(
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
    object->data.contents
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

  data = object->data.contents;

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

  data = object->data.contents;

  data->noise = (
    player_data->is_jumping_secondary != 0
    ? 0
    : 2000
  );
}

void scene_gameplay_destroy(
  struct metil_scene* scene
) {
  #if !target_os_ios
  metil_audio_io_proc_remove(
    scene_gameplay_io_proc
  );
  #endif

  metil_scene_destroy_default(
    scene
  );
}

#if !target_os_ios
OSStatus scene_gameplay_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
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

      if (
        channel == 0
      ) {
        buffer_out[
          index_buffer_out
        ] = 0.0f;
      } else {
        buffer_out[
          index_buffer_out
        ] = buffer_out[
          index_buffer_out -
          channel
        ];
      }
    }
  }

  return 0;
}
#endif
