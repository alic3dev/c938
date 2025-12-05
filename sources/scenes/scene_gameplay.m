#include <scenes/scene_gameplay.h>

#include <generate/generate_buildings.h>
#include <mesh/mesh_hud_item.h>
#include <mesh/mesh_player.h>
#include <objects/object_crosshair.h>
#include <pipeline_index.h>
#include <player.h>
#include <player_data.h>
#include <scenes/scene_id.h>
#include <textures/textures_buildings.h>

#include <metil_audio/audio.h>
#include <metil_debug/log.h>
#include <metil_object.h>
#include <metil_paths/paths.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/scene.h>

#include <stdlib.h>

void scene_gameplay_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_device
) {
  metil_scene_initialize_with_renderables(
    scene,
    metal_device,
    scene_gameplay_length_renderables_default
  );

  metil_audio_io_proc_add(
    scene_gameplay_io_proc
  );

  scene->player.poll = player_poll;
  scene->player.poll_input = player_poll_input;
  scene->player.destroy = player_destroy;

  static struct player_data* player_data;
  player_data = malloc(
    sizeof(struct player_data)
  );

  scene->player.data = player_data;

  scene->poll = scene_gameplay_poll;
  scene->destroy = scene_gameplay_destroy;

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );
  }

  struct metil_object* object = (
    scene->renderables[
      0
    ].renderable
  );

  object->index_pipeline_render = (
    c938_pipeline_index_player
  );

  for (
    unsigned char index_renderable = 1;
    index_renderable < 4;
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
      metal_device
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
    initWithDevice: metal_device
  ];

  textures_buildings_load(
    texture_loader,
    scene->textures
  );

  [texture_loader release];

  object = scene->renderables[0].renderable;

  mesh_player_initialize(
    &object->mesh
  );

  object->positioning = metil_positioning_player;

  metil_object_buffers_initialize(
    object,
    scene->metal_device
  );

  metil_object_texture_add(
    object,
    scene->textures[
      0
    ]
  );

  struct metil_renderer_data_object* data = (
    object->data.contents
  );

  data->id = 0;

  object = (
    scene->renderables[
      1
    ].renderable
  );

  data = object->data.contents;

  data->id = 1;

  data->noise = 2000;

  object->position.x = -0.9f;
  object->position.y = -0.9f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      2
    ].renderable
  );

  data = object->data.contents;
  data->id = 2;

  data->noise = 1.0f;

  object->position.x = -0.9f;
  object->position.y = -0.8f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      3
    ].renderable
  );

  data = object->data.contents;

  data->id = 3;

  data->noise = 2000;

  object->position.x = -0.9f;
  object->position.y = -0.7f;
  object->position.z = 0.0f;

  object = (
    scene->renderables[
      4
    ].renderable
  );

  object_crosshair_initialize(
    object,
    scene->metal_device
  );

  scene_gameplay_populate(
    scene,
    scene->length_renderables
  );
}

void scene_gameplay_populate(
  struct metil_scene* scene,
  unsigned short int length_renderables
) {
  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  scene->player.speed_movement = metil_player_speed_movement_default;

  scene->player.velocity.x = 0.0f;
  scene->player.velocity.y = 0.0f;
  scene->player.velocity.z = 0.0f;

  struct player_data* player_data = (
    (struct player_data*) scene->player.data
  );

  player_data_initialize(
    player_data
  );

  unsigned short int iterator_id = 5;

  if (
    scene->renderables[5].renderable != (void*)0
  ) {
    for (
      unsigned short int index_renderable = 5;
      index_renderable < scene->length_renderables;
      ++index_renderable
    ) {
      metil_object_destroy(
        scene->renderables[
          index_renderable
        ].renderable
      );

      free(
        scene->renderables[
          index_renderable
        ].renderable
      );
    }
  }

  if (
    scene->length_renderables != length_renderables
  ) {
    if (
      scene->length_renderables < length_renderables
    ) {
      scene->renderables = realloc(
        scene->renderables,
        sizeof(struct metil_object*) *
        length_renderables
      );
    }

    if (
      scene->length_renderables > length_renderables
    ) {
      scene->renderables = realloc(
        scene->renderables,
        sizeof(struct metil_object*) *
        length_renderables
      );
    }

    scene->length_renderables = length_renderables;
  }

  generate_buildings(
    scene->metal_device,
    scene->renderables + 5,
    scene->length_renderables,
    scene->textures[0],
    5
  );

  struct metil_object* object = (
    scene->renderables[
      6
    ].renderable
  );

  scene->player.position.x = object->position.x;
  scene->player.position.y = (
    object->position.y +
    object->mesh.size.y
  );
  scene->player.position.z = object->position.z;

  object = (
    scene->renderables[
      0
    ].renderable
  );

  object->position.y = scene->player.position.y;

  player_data->length_renderables = (
    scene->length_renderables - 6
  );

  player_data->renderables = (
    scene->renderables + 6
  );
}

void scene_gameplay_poll(
  struct metil_scene* scene
) {
  struct player_data* player_data = (
    (struct player_data*) scene->player.data
  );

  if (
    player_data->on_ground == 2
  ) {
    unsigned short int length_renderables_reduced = (
      scene->length_renderables * 0.9f
    );

    if (
      length_renderables_reduced < 10
    ) {
      length_renderables_reduced = 10;
    }

    scene_gameplay_populate(
      scene,
      length_renderables_reduced
    );

    return;
  } else if (
    scene->player.position.y <= 10.0f
  ) {
    scene_gameplay_populate(
      scene,
      scene_gameplay_length_renderables_default
    );

    return;
  }

  metil_scene_poll_default(
    scene
  );

  struct metil_object* object = (
    scene->renderables[
      0
    ].renderable
  );

  object->position.x = scene->player.position.x;
  object->position.y = scene->player.position.y;
  object->position.z = scene->player.position.z;

  object = (
    scene->renderables[
      1
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
      2
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
      3
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
  metil_audio_io_proc_remove(
    scene_gameplay_io_proc
  );

  metil_scene_destroy_default(
    scene
  );
}

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
