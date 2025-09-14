#include <scenes/scene_gameplay.h>

#include <audio/audio.h>
#include <mesh/mesh_building.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/mesh_player.h>
#include <metal_kit_shader_types.h>
#include <object.h>
#include <paths/paths.h>
#include <scenes/scene.h>

#include <stdlib.h>
#include <stdio.h>

void scene_gameplay_data_initialize(
  struct scene* scene
) {
  scene->data = (void*)0;
}

void scene_gameplay_initialize(
  struct scene* scene,
  id<MTLDevice> metal_kit_device
) {
  audio_io_proc_add(
    scene_gameplay_io_proc
  );

  scene_initialize(
    scene,
    metal_kit_device
  );

  scene->type = scene_type_game;
  scene->id = scene_id_gameplay;

  scene->poll = scene_gameplay_poll;
  scene->destroy = scene_gameplay_destroy;

  scene->length_objects = 100;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct object*) *
    scene->length_objects
  );

  for (
    unsigned char index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    scene->objects[index_object] = malloc(
      sizeof(struct object)
    );
  }

  scene->length_textures = 5;
  scene->textures = malloc(
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_kit_device];

  scene->textures[
    textures_scene_gameplay_player
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"concrete_3.jpeg"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    1
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"concrete_1.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    2
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"concrete_2.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    3
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"concrete_4.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    4
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"concrete_5.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

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
    newBufferWithLength: sizeof(metal_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->texture = scene->textures[
    textures_scene_gameplay_player
  ];

  unsigned short int iterator_id = 0;

  metal_kit_data_frame_object* data = scene->objects[0]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_player;

  mesh_ground_initialize(
    &scene->objects[1]->mesh,
    2000.0f,
    500.0f,
    2000.0f
  );

  scene->objects[1]->position.y = -500.0f;

  scene->objects[1]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[1]->mesh.vertices
    length: scene->objects[1]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[1]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[1]->mesh.indices
    length: scene->objects[1]->mesh.length_indices * sizeof(unsigned int)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[1]->data = [metal_kit_device
    newBufferWithLength: sizeof(metal_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[1]->texture = scene->textures[
    1
  ];

  scene->objects[1]->texture_secondary = scene->textures[
    2
  ];

  data = scene->objects[1]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_ground;

  for (
    unsigned char index_object = 2;
    index_object < scene->length_objects;
    ++index_object
  ) {
    mesh_building_initialize(
      &scene->objects[index_object]->mesh,
      25.0f + (rand() % 100),
      400.0f + (rand() % 100),
      25.0f + (rand() % 100)
    );

    scene->objects[index_object]->position.y = -500.0f;

    if (index_object == 2) {
      scene->player.position.y = -500.0f + scene->objects[index_object]->mesh.size.y + 1.0f;

      scene->objects[0]->position.y = scene->player.position.y;
    } else {
      while (
        scene->objects[index_object]->position.x - scene->objects[index_object]->mesh.size.x / 2.0f <= scene->objects[2]->mesh.size.x / 2.0f &&
        scene->objects[index_object]->position.x + scene->objects[index_object]->mesh.size.x / 2.0f >= -scene->objects[2]->mesh.size.x / 2.0f &&
        scene->objects[index_object]->position.z - scene->objects[index_object]->mesh.size.z / 2.0f <= scene->objects[2]->mesh.size.z / 2.0f &&
        scene->objects[index_object]->position.z + scene->objects[index_object]->mesh.size.z / 2.0f >= -scene->objects[2]->mesh.size.z / 2.0f
      ) {
        scene->objects[index_object]->position.x = -700.0f + (rand() % 1400);
        scene->objects[index_object]->position.z = -700.0f + (rand() % 1400);
      }
    } 

    scene->objects[index_object]->vertices = [metal_kit_device
      newBufferWithBytes: scene->objects[index_object]->mesh.vertices
      length: scene->objects[index_object]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
      options: MTLResourceStorageModeShared
    ];

    scene->objects[index_object]->indices = [metal_kit_device
      newBufferWithBytes: scene->objects[index_object]->mesh.indices
      length: scene->objects[index_object]->mesh.length_indices * sizeof(unsigned int)
      options: MTLResourceStorageModeShared
    ];

    scene->objects[index_object]->data = [metal_kit_device
      newBufferWithLength: sizeof(metal_kit_data_frame_object)
      options: MTLResourceStorageModeShared
    ];

    scene->objects[index_object]->texture = scene->textures[
      (rand() % (scene->length_textures - 1)) + 1
    ];

    data = scene->objects[index_object]->data.contents;
    data->id = iterator_id++;
    data->mode_texture = mode_texture_building;
  }

  scene->player.length_objects = scene->length_objects - 2;
  scene->player.objects = scene->objects + 2;
}

void scene_gameplay_poll(
  struct scene* scene
) {
  if (
    scene->player.on_ground == 2 ||
    scene->player.position.y <= -490.0f
  ) {
    // TODO: don't destroy/reinit, instead just reset existing values
    scene_gameplay_destroy(scene);
    scene_gameplay_initialize(
      scene,
      scene->metal_kit_device
    );

    return;
  }

  scene_poll_default(scene);

  scene->objects[0]->position.x = (
    scene->player.position.x  - 1.0f
  );

  scene->objects[0]->position.y = (
    scene->player.position.y + 1.0f
  );

  scene->objects[0]->position.z = (
    scene->player.position.z + 1.0f
  );
}


void scene_gameplay_destroy(
  struct scene* scene
) {
  audio_io_proc_remove(
    scene_gameplay_io_proc
  );

  scene_destroy_default(scene);
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
