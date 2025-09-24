#include <scenes/scene_menu_main.h>

#include <generate/generate_buildings.h>
#include <menus/menu_main.h>
#include <mode_texture.h>
#include <scenes/scene_id.h>
#include <textures/textures_buildings.h>

#include <metil_audio/audio.h>
#include <metil_debug/log.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>
#include <metil_menus/menu.h>
#include <metil_mesh/mesh_text.h>
#include <metil_shader_types.h>
#include <metil_object.h>
#include <metil_paths/paths.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>
#include <metil_text/text.h>

#include <CoreAudio/CoreAudio.h>

const unsigned long int scene_menu_main_time_scene_transition = 333;

void scene_menu_main_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_kit_device
) {
  metil_audio_io_proc_add(
    scene_menu_main_io_proc
  );

  metil_scene_initialize(
    scene,
    metal_kit_device
  );

  scene->poll = scene_menu_main_poll;
  scene->poll_input = scene_menu_main_poll_input;
  scene->destroy = scene_menu_main_destroy;

  scene->data = malloc(
    sizeof(struct metil_scene_menu_main_data)
  );

  struct metil_scene_menu_main_data* data = (struct metil_scene_menu_main_data*) scene->data;

  data->time_started = 0;

  menu_main_initialize(
    &data->menu
  );

  scene->type = metil_scene_type_menu;
  scene->id = scene_id_menu_main;

  scene->length_objects = 103;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  scene->objects[0] = malloc(
    sizeof(struct metil_object)
  );

  scene->length_textures = 7;
  scene->textures = malloc(
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_kit_device];

  textures_buildings_load(
    texture_loader,
    scene->textures + 3
  );

  [texture_loader release];

  unsigned short int iterator_id = 0;

  scene->objects[0] = malloc(
    sizeof(struct metil_object)
  );

  scene->textures[
    textures_scene_menu_main_title
  ] = metil_text_mesh_with_texture_initialize(
    metal_kit_device,
    &scene->objects[0]->mesh,
    "c938",
    metil_font_reference_monospace
  ); // TODO: Check for null

  scene->objects[0]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[0]->mesh.vertices
    length: scene->objects[0]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[0]->mesh.indices
    length: (
      sizeof(unsigned int) *
      scene->objects[0]->mesh.length_indices
    )
    options: MTLResourceStorageModePrivate
  ];

  scene->objects[0]->data = [metal_kit_device
    newBufferWithLength: sizeof(metil_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->position.y = 0.5f - (scene->objects[0]->mesh.size.y / 4.0f);

  metil_kit_data_frame_object* data_object = scene->objects[0]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_text;
  data_object->noise = 0;

  scene->objects[0]->texture = scene->textures[
    textures_scene_menu_main_title
  ];

  scene->objects[1] = malloc(
    sizeof(struct metil_object)
  );

  scene->textures[
    textures_scene_menu_main_menu_enter
  ] = metil_text_mesh_with_texture_initialize(
    metal_kit_device,
    &scene->objects[1]->mesh,
    "enter",
    metil_font_reference_monospace
  ); // TODO: Check for null

  scene->objects[1]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[1]->mesh.vertices
    length: scene->objects[1]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[1]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[1]->mesh.indices
    length: (
      sizeof(unsigned int) *
      scene->objects[1]->mesh.length_indices
    )
    options: MTLResourceStorageModePrivate
  ];

  scene->objects[1]->data = [metal_kit_device
    newBufferWithLength: sizeof(metil_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[1]->position.y = -scene->objects[1]->mesh.size.y * 6.0;

  data_object = scene->objects[1]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_text;

  scene->objects[1]->texture = scene->textures[
    textures_scene_menu_main_menu_enter
  ];

  scene->objects[2] = malloc(
    sizeof(struct metil_object)
  );

  scene->textures[
    textures_scene_menu_main_menu_exit
  ] = metil_text_mesh_with_texture_initialize(
    metal_kit_device,
    &scene->objects[2]->mesh,
    "exit",
    metil_font_reference_monospace
  );

  scene->objects[2]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[2]->mesh.vertices
    length: scene->objects[2]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[2]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[2]->mesh.indices
    length: (
      sizeof(unsigned int) *
      scene->objects[2]->mesh.length_indices
    )
    options: MTLResourceStorageModePrivate
  ];

  scene->objects[2]->data = [metal_kit_device
    newBufferWithLength: sizeof(metil_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[2]->position.y = -scene->objects[2]->mesh.size.y * 10.0f;

  data_object = scene->objects[2]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_text;

  scene->objects[2]->texture = scene->textures[
    textures_scene_menu_main_menu_exit
  ];

  generate_buildings(
    scene->metal_kit_device,
    scene->objects + 3,
    scene->length_objects - 3,
    scene->textures + 3,
    scene->length_textures - 3,
    iterator_id
  );

  scene->player.position.y = (
    1600.0f
  );

  scene->player.position.z = (
    -1500.0f
  );

  scene->player.rotation.x = -0.3f;
}

void scene_menu_main_poll(
  struct metil_scene* scene
) {
  float angle = ((float) (scene->time - 1758700000000) / 100000.0f) * M_PI * 2.0f;

  scene->player.position.x = cos(
    angle
  ) * 1500.0f;
  
  scene->player.position.z = sin(
    angle
  ) * 1500.0f;

  scene->player.rotation.y = -angle - M_PI / 2.0f;

  struct metil_scene_menu_main_data* data = (struct metil_scene_menu_main_data*) scene->data;

  struct metil_menu* menu = &data->menu;

  switch (menu->index_current) {
    case 0: {
      metil_kit_data_frame_object* data_object = scene->objects[1]->data.contents;
      data_object->noise = 1;
      data_object = scene->objects[2]->data.contents;
      data_object->noise = 0;
      break;
    }
    case 1: {
      metil_kit_data_frame_object* data_object = scene->objects[2]->data.contents;
      data_object->noise = 1;
      data_object = scene->objects[1]->data.contents;
      data_object->noise = 0;
      break;
    }
  }

  if (
    data->time_started != 0
  ) {
    unsigned long int time_delta = (
      scene->time - 
      data->time_started
    );

    if (
      time_delta >= scene_menu_main_time_scene_transition
    ) {
      scene->rendering_properties.brightness = 0.0f;
      scene->rendering_properties.brightness_text = 0.0f;

      metil_scene_controller_scene_change(
        scene_id_gameplay
      );
    } else {
      float brightness = (
        (float) (scene_menu_main_time_scene_transition - time_delta) / (float) scene_menu_main_time_scene_transition
      );

      scene->rendering_properties.brightness = brightness;
      scene->rendering_properties.brightness_text = brightness;
    }
  } else if (
    menu->index_selected != -1 &&
    menu->handled == 0
  ) {
    menu->handled = 1;

    switch (menu->index_selected) {
      case 0:
        metil_debug_log("STARTING\n");

        data->time_started = scene->time;
        break;
      case 1:
        metil_debug_log("EXITING\n");
        
        [[NSApplication sharedApplication] terminate: 0];
        break;
    }
  }
}

void scene_menu_main_poll_input(
  struct metil_scene* scene
) {
  struct metil_menu* menu = &(
    ((struct metil_scene_menu_main_data*) scene->data)->menu
  );

  metil_menu_poll_input(
    menu
  );
}

void scene_menu_main_destroy(
  struct metil_scene* scene
) {
  metil_audio_io_proc_remove(
    scene_menu_main_io_proc
  );

  metil_menu_destroy(
    &((struct metil_scene_menu_main_data*) scene->data)->menu
  );

  metil_scene_destroy_default(scene);
}

OSStatus scene_menu_main_io_proc(
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

      if (index_buffer == 0) {
        buffer_out[index_buffer_out] = 0.0f;
      } else {
        buffer_out[index_buffer_out] = buffer_out[index_buffer_out - channel];
      }
    }
  }

  return 0;
}
