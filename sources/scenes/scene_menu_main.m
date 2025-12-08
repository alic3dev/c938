#include <scenes/scene_menu_main.h>

#include <generate/generate_buildings.h>
#include <menus/menu_main.h>
#include <pipeline_index.h>
#include <scenes/scene_id.h>
#include <textures/textures_buildings.h>

#include <metil_audio/audio.h>
#include <metil_debug/log.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>
#include <metil_menus/menu.h>
#include <metil_mesh/mesh_text.h>
#include <metil_object.h>
#include <metil_paths/paths.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_data_menu_item.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>
#include <metil_text/text.h>

#if !target_os_ios
#include <AppKit/AppKit.h>
#include <CoreAudio/CoreAudio.h>
#else
#include <UIKit/UIKit.h>
#endif

const unsigned long int scene_menu_main_time_scene_transition = 333;

void scene_menu_main_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_device
) {
  #if !target_os_ios
  metil_audio_io_proc_add(
    scene_menu_main_io_proc
  );
  #endif

  metil_scene_initialize_with_renderables(
    scene,
    metal_device,
    103
  );

  scene->poll = scene_menu_main_poll;
  scene->poll_input = scene_menu_main_poll_input;
  scene->destroy = scene_menu_main_destroy;

  scene->data = malloc(
    sizeof(struct scene_menu_main_data)
  );

  struct scene_menu_main_data* data = (
    (struct scene_menu_main_data*) scene->data
  );

  data->angle = 0.0f;

  data->time_started = 0;

  menu_main_initialize(
    &data->menu
  );

  scene->length_textures = 4;
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
    scene->textures + 3
  );

  [texture_loader release];

  unsigned short int iterator_id = 0;

  generate_buildings(
    scene->metal_device,
    scene->renderables,
    scene->length_renderables - 3,
    scene->textures[3],
    iterator_id
  );

  iterator_id = (
    scene->length_renderables -
    3
  );
  
  metil_renderable_initialize_at_index(
    scene->renderables,
    iterator_id,
    metil_renderable_type_object
  );

  struct metil_object* object = (
    scene->renderables[
      iterator_id
    ].renderable
  );

  object->index_pipeline_render = (
    c938_pipeline_index_text
  );

  scene->textures[
    textures_scene_menu_main_title
  ] = metil_text_mesh_with_texture_initialize(
    metal_device,
    &object->mesh,
    "c938",
    &metil_text_render_parameters_default
  );

  object->positioning = metil_positioning_static;

  metil_object_buffers_initialize_with_data_size(
    object,
    metal_device,
    sizeof(struct metil_renderer_data_menu_item)
  );

  object->position.y = (
    0.5f - (
      object->mesh.size.y /
      4.0f
    )
  );

  metil_object_texture_add(
    object,
    scene->textures[
      textures_scene_menu_main_title
    ]
  );

  struct metil_renderer_data_object* data_object = (
    object->data.contents
  );
  
  data_object->id = iterator_id++;
  data_object->noise = 0;

  metil_renderable_initialize_at_index(
    scene->renderables,
    iterator_id,
    metil_renderable_type_object
  );

  object = (
    scene->renderables[
      iterator_id
    ].renderable
  );

  object->index_pipeline_render = (
    c938_pipeline_index_text
  );

  scene->textures[
    textures_scene_menu_main_menu_enter
  ] = metil_text_mesh_with_texture_initialize(
    metal_device,
    &object->mesh,
    "enter",
    &metil_text_render_parameters_default
  );

  object->positioning = metil_positioning_static;

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  object->position.y = (
    object->mesh.size.y *
    -6.0
  );

  metil_object_texture_add(
    object,
    scene->textures[
      textures_scene_menu_main_menu_enter
    ]
  );

  data_object = object->data.contents;
  data_object->id = iterator_id++;

  metil_renderable_initialize_at_index(
    scene->renderables,
    iterator_id,
    metil_renderable_type_object
  );

  object = (
    scene->renderables[
      iterator_id
    ].renderable
  );

  object->index_pipeline_render = (
    c938_pipeline_index_text
  );

  scene->textures[
    textures_scene_menu_main_menu_exit
  ] = metil_text_mesh_with_texture_initialize(
    metal_device,
    &object->mesh,
    "exit",
    &metil_text_render_parameters_default
  );

  object->positioning = metil_positioning_static;

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  object->position.y = (
    object->mesh.size.y *
    -10.0f
  );

  data_object = object->data.contents;
  
  metil_object_texture_add(
    object,
    scene->textures[
      textures_scene_menu_main_menu_exit
    ]
  );

  data_object->id = iterator_id++;

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
  struct scene_menu_main_data* data = (
    (struct scene_menu_main_data*) scene->data
  );

  data->angle = fmod((
      data->angle +
      scene->time_delta /
      20000.0f
    ), (
      M_PI *
      2.0f
    )
  );

  scene->player.position.x = -cos(
    data->angle
  ) * 1500.0f;
  
  scene->player.position.z = -sin(
    data->angle
  ) * 1500.0f;

  scene->player.rotation.y = ((
      data->angle *
      1.0f
    ) - (
      M_PI / 2.0f
    )
  );

  struct metil_menu* menu = &data->menu;

  switch (menu->index_current) {
    case 0: {
      struct metil_renderer_data_menu_item* data_object = (
        (
          (struct metil_object*) scene->renderables[
            scene->length_renderables - 2
          ].renderable
        )->data.contents
      );
      data_object->selected = 1;

      data_object = (
        (struct metil_object*) scene->renderables[
          scene->length_renderables - 1
        ].renderable
      )->data.contents;
      data_object->selected = 0;
      break;
    }
    case 1: {
      struct metil_renderer_data_menu_item* data_object = (
        ((struct metil_object*) scene->renderables[
          scene->length_renderables - 1
        ].renderable)->data.contents
      );
      data_object->selected = 1;

      data_object = (
        (struct metil_object*) scene->renderables[
          scene->length_renderables - 2
        ].renderable
      )->data.contents;
      data_object->selected = 0;
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
        (float) (
          scene_menu_main_time_scene_transition - time_delta
        ) / (float) scene_menu_main_time_scene_transition
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

        #if target_os_ios
        [[UIApplication sharedApplication] terminate: 0];
        #else
        [[NSApplication sharedApplication] terminate: 0];
        #endif
        break;
    }
  }
}

void scene_menu_main_poll_input(
  struct metil_scene* scene
) {
  struct metil_menu* menu = (
    &(
      (struct scene_menu_main_data*) scene->data
    )->menu
  );

  metil_menu_poll_input(
    menu
  );
}

void scene_menu_main_destroy(
  struct metil_scene* scene
) {
  #if !target_os_ios
  metil_audio_io_proc_remove(
    scene_menu_main_io_proc
  );
  #endif

  metil_menu_destroy(
    &(
      (struct scene_menu_main_data*) scene->data
    )->menu
  );

  metil_scene_destroy_default(scene);
}

#if !target_os_ios
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
    AudioBuffer audio_buffer_current = list_buffer_audio_out->mBuffers[
      index_buffer
    ];

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
        index_buffer == 0
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
