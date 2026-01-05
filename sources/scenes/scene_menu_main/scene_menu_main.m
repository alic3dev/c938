#include <scenes/scene_menu_main/scene_menu_main.h>

#include <generate/generate_buildings.h>
#include <menus/menu_main.h>
#include <pipeline_index.h>
#include <scenes/scene_id.h>
#include <textures/textures_buildings.h>

#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_group.h>
#include <metil_input/metil_keycodes.h>
#include <metil_input/metil_input_map.h>
#include <metil_menus/metil_menu.h>
#include <metil_mesh/metil_mesh_text.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_text.h>
#include <metil_paths/metil_paths.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>
#include <metil_termination/metil_termination.h>
#include <metil_text/metil_text.h>

#if !target_os_ios
#include <AppKit/AppKit.h>
#include <CoreAudio/CoreAudio.h>
#else
#include <AVFAudio/AVFAudio.h>
#include <UIKit/UIKit.h>
#endif

void scene_menu_main_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    scene_menu_main_length_renderables
  );

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case scene_menu_main_renderables_index_buildings:
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

  scene->poll = (
    scene_menu_main_poll
  );

  scene->poll_input = (
    scene_menu_main_poll_input
  );

  scene->destroy = (
    scene_menu_main_destroy
  );

  scene->data = malloc(
    sizeof(
      struct scene_menu_main_data
    )
  );

  struct scene_menu_main_data* data = (
    scene->data
  );

  data->angle = (
    0.0f
  );

  data->time_started = (
    0
  );

  menu_main_initialize(
    metil,
    &data->menu
  );

  scene->length_textures = (
    scene_menu_main_length_textures
  );

  scene->textures = realloc(
    scene->textures, (
      sizeof(
        id<MTLTexture>
      ) *
      scene->length_textures
    )
  );

  MTKTextureLoader* texture_loader = [
    [MTKTextureLoader alloc]
    initWithDevice: metil->renderer_interface.metal_device
  ];

  textures_buildings_load(
    texture_loader, (
      scene->textures +
      scene_menu_main_textures_index_buildings
    ),
    &metil->paths
  );

  [texture_loader release];

  struct metil_object* metil_object_text_title = (
    scene->renderables[
      scene_menu_main_renderables_index_text_title
    ].renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object_text_title,
    "c938"
  );

  metil_object_text_title->position.y = (
    0.5f - (
      metil_object_text_title->mesh.size.y /
      4.0f
    )
  );

  struct metil_object* metil_object_text_enter = (
    scene->renderables[
      scene_menu_main_renderables_index_menu_enter
    ].renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object_text_enter,
    "enter"
  );

  metil_object_text_enter->position.y = (
    metil_object_text_enter->mesh.size.y *
    -6.0
  );

  struct metil_object* metil_object_text_exit = (
    scene->renderables[
      scene_menu_main_renderables_index_menu_exit
    ].renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object_text_exit,
    "exit"
  );

  metil_object_text_exit->position.y = (
    metil_object_text_exit->mesh.size.y *
    -10.0f
  );

  struct metil_group* metil_group_buildings = (
    scene->renderables[
      scene_menu_main_renderables_index_buildings
    ].renderable
  );

  generate_buildings(
    metil,
    metil->renderer_interface.metal_device,
    metil_group_buildings,
    scene_menu_main_length_buildings_default,
    100,
    scene->textures[
      scene_menu_main_textures_index_buildings
    ]
  );

  scene->player.position.y = (
    1600.0f
  );

  scene->player.position.z = (
    -1500.0f
  );

  scene->player.rotation.x = -0.3f;

  metil_audio_io_proc_add(
    &metil->audio,
    scene_menu_main_io_proc
  );
}

void scene_menu_main_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct scene_menu_main_data* data = (
    scene->data
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

  scene->player.position.x = (
    cos(
      data->angle
    ) *
    -1500.0f
  );
  
  scene->player.position.z = (
    sin(
      data->angle
    ) *
    -1500.0f
  );

  scene->player.rotation.y = (
    (
      data->angle *
      1.0f
    ) - (
      M_PI /
      2.0f
    )
  );

  struct metil_menu* menu = &(
    data->menu
  );

  struct metil_object* metil_object_text_enter = (
    scene->renderables[
      scene_menu_main_renderables_index_menu_enter
    ].renderable
  );

  struct metil_object* metil_object_text_exit = (
    scene->renderables[
      scene_menu_main_renderables_index_menu_exit
    ].renderable
  );

  struct metil_renderer_data_object* metil_renderer_data_menu_item_enter = (
    metil_object_text_enter->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_object* metil_renderer_data_menu_item_exit = (
    metil_object_text_exit->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  switch (
    menu->index_current
  ) {
    case 0: {
      metil_renderer_data_menu_item_enter->color.x = (
        0.1f
      );

      metil_renderer_data_menu_item_enter->color.y = (
        0.1f
      );

      metil_renderer_data_menu_item_enter->color.z = (
        0.1f
      );

      metil_renderer_data_menu_item_exit->color.x = (
        1.0f
      );

      metil_renderer_data_menu_item_exit->color.y = (
        1.0f
      );

      metil_renderer_data_menu_item_exit->color.z = (
        1.0f
      );
      break;
    }
    case 1: {
      metil_renderer_data_menu_item_enter->color.x = (
        1.0f
      );

      metil_renderer_data_menu_item_enter->color.y = (
        1.0f
      );

      metil_renderer_data_menu_item_enter->color.z = (
        1.0f
      );

      metil_renderer_data_menu_item_exit->color.x = (
        0.1f
      );

      metil_renderer_data_menu_item_exit->color.y = (
        0.1f
      );

      metil_renderer_data_menu_item_exit->color.z = (
        0.1f
      );
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
      metil->rendering_properties.brightness = 0.0f;
      metil->rendering_properties.brightness_text = 0.0f;

      metil_scene_controller_scene_change(
        metil,
        metil->scene_controller,
        scene_id_gameplay
      );
    } else {
      float brightness = (
        (float) (
          scene_menu_main_time_scene_transition -
          time_delta
        ) /
        (float) scene_menu_main_time_scene_transition
      );

      metil->rendering_properties.brightness = (
        brightness *
        metil->configuration.rendering_properties.brightness
      );

      metil->rendering_properties.brightness_text = (
        brightness *
        metil->configuration.rendering_properties.brightness_text
      );
    }
  } else if (
    menu->index_selected != -1 &&
    menu->handled == 0
  ) {
    menu->handled = 1;

    switch (menu->index_selected) {
      case 0:
        metil_debug_log(
          metil->configuration.debug_log_level,
          "scene_menu_main:starting\n"
        );

        data->time_started = scene->time;
        break;
      case 1:
        metil_debug_log(
          metil->configuration.debug_log_level,
          "scene_menu_main:exiting\n"
        );

        #if target_os_ios
        metil_termination_terminate(
          &metil->termination
        );
        exit(0);
        #else
        [[NSApplication sharedApplication] terminate: 0];
        #endif
        break;
    }
  }
}

void scene_menu_main_poll_input(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct scene_menu_main_data* scene_menu_main_data = (
    scene->data
  );
  
  struct metil_menu* menu = (
    &scene_menu_main_data->menu
  );

  metil_menu_poll_input(
    menu,
    &metil->input
  );
}

void scene_menu_main_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_audio_io_proc_remove(
    &metil->audio,
    scene_menu_main_io_proc
  );

  struct scene_menu_main_data* scene_menu_main_data = (
    scene->data
  );

  metil_menu_destroy(
    &scene_menu_main_data->menu
  );

  metil_scene_destroy_default(
    metil,
    scene
  );
}

#if target_os_ios
int scene_menu_main_io_proc(
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
      ] = (
        0.0f
      );
    }
  }
  
  return 0;
}
#else
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

      buffer_out[
        index_buffer_out
      ] = (
        0.0f
      );
    }
  }

  return 0;
}
#endif
