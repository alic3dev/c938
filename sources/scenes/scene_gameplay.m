#include <scenes/scene_gameplay.h>

#include <generate/generate_buildings.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/mesh_player.h>
#include <mode_texture.h>
#include <player.h>
#include <player_data.h>
#include <scenes/scene_id.h>
#include <textures/textures_buildings.h>

#include <metil_audio/audio.h>
#include <metil_debug/log.h>
#include <metil_shader_types.h>
#include <metil_object.h>
#include <metil_paths/paths.h>
#include <metil_scenes/scene.h>

#include <stdlib.h>

void scene_gameplay_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_kit_device
) {
  metil_audio_io_proc_add(
    scene_gameplay_io_proc
  );

  metil_scene_initialize(
    scene,
    metal_kit_device
  );

  scene->player.poll = player_poll;
  scene->player.poll_input = player_poll_input;
  scene->player.destroy = player_destroy;

  static struct player_data* player_data;
  player_data = malloc(
    sizeof(struct player_data)
  );

  scene->player.data = player_data;

  scene->type = metil_scene_type_game;
  scene->id = scene_id_gameplay;

  scene->poll = scene_gameplay_poll;
  scene->destroy = scene_gameplay_destroy;

  scene->length_objects = 200;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  scene->objects[0] = malloc(
    sizeof(struct metil_object)
  );

  for (
    unsigned char index_object = 1;
    index_object < scene->length_objects;
    ++index_object
  ) {
    scene->objects[index_object] = (void*)0;
  }

  scene->length_textures = 5;
  scene->textures = malloc(
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [
    [MTKTextureLoader alloc]
    initWithDevice: metal_kit_device
  ];

  scene->textures[
    textures_scene_gameplay_player
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"concrete_3.jpeg"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil_paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  textures_buildings_load(
    texture_loader,
    scene->textures + 1
  );

  [texture_loader release];

  mesh_player_initialize(
    &scene->objects[0]->mesh
  );

  scene->objects[0]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[0]->mesh.vertices
    length: scene->objects[0]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[0]->mesh.indices
    length: scene->objects[0]->mesh.length_indices * sizeof(unsigned int)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->data = [metal_kit_device
    newBufferWithLength: sizeof(metil_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->texture = scene->textures[
    textures_scene_gameplay_player
  ];

  metil_kit_data_frame_object* data = scene->objects[0]->data.contents;
  data->id = 0;
  data->mode_texture = mode_texture_player;

  scene_gameplay_populate(scene);
}

void scene_gameplay_populate(
  struct metil_scene* scene
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

  unsigned short int iterator_id = 1;

  if (scene->objects[1] != (void*)0) {
    for (
      unsigned short int index_object = 1;
      index_object < scene->length_objects;
      ++index_object
    ) {
      [scene->objects[index_object]->data release];
      [scene->objects[index_object]->indices release];
      [scene->objects[index_object]->vertices release];

      metil_object_destroy(
        scene->objects[index_object]
      );

      free(scene->objects[index_object]);
    }
  }

  scene->length_objects = 100;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  generate_buildings(
    scene->metal_kit_device,
    scene->objects + 1,
    scene->length_objects - 1,
    scene->textures + 1,
    scene->length_textures - 1,
    1
  );

  scene->player.position.x = scene->objects[2]->position.x;
  scene->player.position.y = scene->objects[2]->position.y + scene->objects[2]->mesh.size.y;
  scene->player.position.z = scene->objects[2]->position.z;

  scene->objects[0]->position.y = scene->player.position.y;

  player_data->length_objects = scene->length_objects - 2;
  player_data->objects = scene->objects + 2;
}

void scene_gameplay_poll(
  struct metil_scene* scene
) {
  struct player_data* player_data = (
    (struct player_data*) scene->player.data
  );

  if (
    player_data->on_ground == 2 ||
    scene->player.position.y <= 10.0f
  ) {
    scene_gameplay_populate(
      scene
    );

    return;
  }

  metil_scene_poll_default(scene);

  scene->objects[0]->position.x = (
    scene->player.position.x
  );

  scene->objects[0]->position.y = (
    scene->player.position.y
  );

  scene->objects[0]->position.z = (
    scene->player.position.z
  );
}

void scene_gameplay_destroy(
  struct metil_scene* scene
) {
  metil_audio_io_proc_remove(
    scene_gameplay_io_proc
  );

  for (
    unsigned short int index_object = 1;
    index_object < scene->length_objects;
    ++index_object
  ) {
    [scene->objects[index_object]->data release];
    [scene->objects[index_object]->indices release];
    [scene->objects[index_object]->vertices release];
  }

  metil_scene_destroy_default(scene);
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
    AudioBuffer audio_buffer_current = list_buffer_audio_out->mBuffers[index_buffer];

    float* buffer_out = audio_buffer_current.mData;
    unsigned long int size_buffer_out = audio_buffer_current.mDataByteSize / sizeof(float);
    unsigned long int count_channel_out = audio_buffer_current.mNumberChannels;
    
    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = index_buffer_out % count_channel_out;

      if (channel == 0) {
        buffer_out[index_buffer_out] = 0.0f;
      } else {
        buffer_out[index_buffer_out] = buffer_out[index_buffer_out - channel];
      }
    }
  }

  return 0;
}
