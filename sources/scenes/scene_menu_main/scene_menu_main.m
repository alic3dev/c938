#include <scenes/scene_menu_main/scene_menu_main.h>

#include <generate/generate_buildings.h>
#include <menus/menu_main.h>
#include <menus/menu_main_custom.h>
#include <c938_pipeline_index.h>
#include <scenes/scene_id.h>
#include <textures/textures_buildings.h>

#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_group.h>
#include <metil_input/metil_keycodes.h>
#include <metil_input/metil_input_map.h>
#include <metil_menus/metil_menu.h>
#include <metil_menus/metil_menu_input.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_mesh/metil_mesh_box.h>
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
#include <metil_utilities/metil_stopwatch.h>

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
      case scene_menu_main_renderables_index_group_buildings:
      case scene_menu_main_renderables_index_group_text_menu_main_backing:
      case scene_menu_main_renderables_index_group_text_menu_main:
      case scene_menu_main_renderables_index_group_text_menu_custom_backing:
      case scene_menu_main_renderables_index_group_text_menu_custom:
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
    &data->menu_main
  );

  menu_main_custom_initialize(
    &data->menu_main_custom
  );

  data->menu_current = &(
    data->menu_main
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
    metil,
    texture_loader, (
      scene->textures +
      scene_menu_main_textures_index_buildings
    )
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

  struct metil_group* metil_group_text_main_backing = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_main_backing
    ].renderable
  );

  struct metil_group* metil_group_text_main = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_main
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_text_main_backing,
    scene_menu_main_length_group_renderables_text_main_backing,
    metil_renderable_type_object
  );

  metil_group_add_length_initialize(
    metil_group_text_main,
    scene_menu_main_length_group_renderables_text_main,
    metil_renderable_type_object
  );

  for (
    unsigned char index_metil_group_text_main_renderable = 0;
    index_metil_group_text_main_renderable < scene_menu_main_length_group_renderables_text_main;
    ++index_metil_group_text_main_renderable
  ) {
    struct metil_object* metil_object_text_backing = (
      metil_group_text_main_backing->renderables[
        index_metil_group_text_main_renderable
      ]->renderable
    );

    struct metil_object* metil_object_text = (
      metil_group_text_main->renderables[
        index_metil_group_text_main_renderable
      ]->renderable
    );

    switch (
      index_metil_group_text_main_renderable
    ) {
      case scene_menu_main_renderables_group_text_main_index_menu_start:
        metil_object_text_initialize(
          metil,
          metil_object_text,
          "start"
        );

        break;
      case scene_menu_main_renderables_group_text_main_index_menu_custom:
        metil_object_text_initialize(
          metil,
          metil_object_text,
          "custom"
        );

        break;
      case scene_menu_main_renderables_group_text_main_index_menu_exit:
        metil_object_text_initialize(
          metil,
          metil_object_text,
          "exit"
        );
        
        break;
    }

    metil_mesh_box_initialize(
      &metil_object_text_backing->mesh,
      (struct math_c_vector3_float) {
        .x = 0.5f,
        .y = (
          metil_object_text->mesh.size.y * 1.5f
        ),
        .z = (
          0.5f
        )
      }
    );

    metil_object_text_backing->position.z = 0.5f;

    metil_object_text_backing->rotation.x = -0.025f;
    metil_object_text_backing->rotation.y = -0.025f;

    metil_object_texture_add(
      metil_object_text_backing,
      scene->textures[
        scene_menu_main_textures_index_text_backing
      ]
    );

    metil_object_buffers_initialize(
      metil_object_text_backing,
      metil->renderer_interface.metal_device
    );

    struct metil_renderer_data_object* metil_renderer_data_object = (
      metil_object_text_backing->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_renderer_data_object_initialize(
      metil_renderer_data_object
    );

    metil_object_text_backing->index_pipeline_render = (
      c938_pipeline_index_text_backing_menu
    );

    metil_object_text_backing->positioning = (
      metil_positioning_static
    );

    metil_object_text->position.y = (
      metil_object_text->mesh.size.y *
      (
        -6.0f -
        (
          index_metil_group_text_main_renderable *
          4.0f
        )
      )
    );

    metil_object_text_backing->position.y = (
      metil_object_text->position.y -
      (
        metil_object_text->mesh.size.y /
        50.0f
      )
    );
  }

  struct metil_group* metil_group_text_menu_custom_backing = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_custom_backing
    ].renderable
  );

  struct metil_group* metil_group_text_menu_custom = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_custom
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_text_menu_custom_backing,
    scene_menu_main_length_group_renderables_text_menu_custom_backing,
    metil_renderable_type_object
  );

  metil_group_add_length_initialize(
    metil_group_text_menu_custom,
    scene_menu_main_length_group_renderables_text_menu_custom,
    metil_renderable_type_object
  );

  metil_group_text_menu_custom_backing->visible = 0;
  metil_group_text_menu_custom->visible = 0;

  for (
    unsigned char index_metil_group_text_main_renderable = 0;
    index_metil_group_text_main_renderable < scene_menu_main_length_group_renderables_text_menu_custom;
    ++index_metil_group_text_main_renderable
  ) {
    struct metil_object* metil_object_text_backing = (
      metil_group_text_menu_custom_backing->renderables[
        index_metil_group_text_main_renderable
      ]->renderable
    );

    struct metil_object* metil_object_text = (
      metil_group_text_menu_custom->renderables[
        index_metil_group_text_main_renderable
      ]->renderable
    );

    switch (
      index_metil_group_text_main_renderable
    ) {
      case menus_menu_main_custom_index_start: {
        metil_object_text_initialize(
          metil,
          metil_object_text,
          "start"
        );

        break;
      }
      case menus_menu_main_custom_index_back: {
        metil_object_text_initialize(
          metil,
          metil_object_text,
          "back"
        );

        break;
      }
    }

    metil_mesh_box_initialize(
      &metil_object_text_backing->mesh,
      (struct math_c_vector3_float) {
        .x = 0.5f,
        .y = (
          metil_object_text->mesh.size.y * 1.5f
        ),
        .z = (
          0.5f
        )
      }
    );

    metil_object_text_backing->position.z = 0.5f;

    metil_object_text_backing->rotation.x = -0.025f;
    metil_object_text_backing->rotation.y = -0.025f;

    metil_object_texture_add(
      metil_object_text_backing,
      scene->textures[
        scene_menu_main_textures_index_text_backing
      ]
    );

    metil_object_buffers_initialize(
      metil_object_text_backing,
      metil->renderer_interface.metal_device
    );

    struct metil_renderer_data_object* metil_renderer_data_object = (
      metil_object_text_backing->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_renderer_data_object_initialize(
      metil_renderer_data_object
    );

    metil_object_text_backing->index_pipeline_render = (
      c938_pipeline_index_text_backing_menu
    );

    metil_object_text_backing->positioning = (
      metil_positioning_static
    );

    metil_object_text->position.y = (
      metil_object_text->mesh.size.y *
      (
        -6.0f -
        (
          index_metil_group_text_main_renderable *
          4.0f
        )
      )
    );

    metil_object_text_backing->position.y = (
      metil_object_text->position.y -
      (
        metil_object_text->mesh.size.y /
        50.0f
      )
    );
  }

  struct metil_group* metil_group_buildings = (
    scene->renderables[
      scene_menu_main_renderables_index_group_buildings
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

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    scene_menu_main_io_proc,
    scene->data
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

  struct metil_menu* menu = (
    data->menu_current
  );

  struct metil_group* metil_group_text_main_backing = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_main_backing
    ].renderable
  );

  struct metil_group* metil_group_text_main = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_main
    ].renderable
  );

  struct metil_group* metil_group_text_menu_custom_backing = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_custom_backing
    ].renderable
  );

  struct metil_group* metil_group_text_menu_custom = (
    scene->renderables[
      scene_menu_main_renderables_index_group_text_menu_custom
    ].renderable
  );

  
  for (
    unsigned char index_metil_group_text_main_renderable = 0;
    index_metil_group_text_main_renderable < (
      menu == &data->menu_main
      ? scene_menu_main_length_group_renderables_text_main
      : scene_menu_main_length_group_renderables_text_menu_custom
    );
    ++index_metil_group_text_main_renderable
  ) {
    struct metil_object* metil_object_text_backing;
    struct metil_object* metil_object_text;

    if (
      menu == &data->menu_main
    ) {
      metil_object_text_backing = (
        metil_group_text_main_backing->renderables[
          index_metil_group_text_main_renderable
        ]->renderable
      );

      metil_object_text = (
        metil_group_text_main->renderables[
          index_metil_group_text_main_renderable
        ]->renderable
      );
    } else {
      metil_object_text_backing = (
        metil_group_text_menu_custom_backing->renderables[
          index_metil_group_text_main_renderable
        ]->renderable
      );

      metil_object_text = (
        metil_group_text_menu_custom->renderables[
          index_metil_group_text_main_renderable
        ]->renderable
      );
    }

    struct metil_renderer_data_object* metil_renderer_data_text_backing = (
      metil_object_text_backing->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    struct metil_renderer_data_object* metil_renderer_data_text = (
      metil_object_text->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    if (
      menu->index_current == index_metil_group_text_main_renderable
    ) {
      metil_object_text_backing->rotation.x = -0.00625f;
      metil_object_text_backing->rotation.y = -0.00625f;

      metil_object_text->position.x = 0.0f;

      metil_object_text->position.y = (
        metil_object_text->mesh.size.y *
        (
          -6.075f -
          (
            index_metil_group_text_main_renderable *
            4.0f
          )
        )
      );

      metil_renderer_data_text_backing->color.x = (
        0.8f
      );

      if (
        menu == &data->menu_main &&
        index_metil_group_text_main_renderable == menus_menu_main_index_exit
      ) {
        metil_renderer_data_text_backing->color.y = (
          0.4f
        );

        metil_renderer_data_text_backing->color.z = (
          0.4f
        );
      } else {
        metil_renderer_data_text_backing->color.y = (
          0.8f
        );

        metil_renderer_data_text_backing->color.z = (
          0.8f
        );
      }

      metil_renderer_data_text->color.x = (
        0.8f
      );

      metil_renderer_data_text->color.y = (
        0.8f
      );

      metil_renderer_data_text->color.z = (
        0.8f
      );
    } else {
      metil_object_text_backing->rotation.x = -0.0125f;
      metil_object_text_backing->rotation.y = -0.0125f;

      metil_object_text->position.x = 0.001f;

      metil_object_text->position.y = (
        metil_object_text->mesh.size.y *
        (
          -6.05f -
          (
            index_metil_group_text_main_renderable *
            4.0f
          )
        )
      );

      metil_renderer_data_text_backing->color.x = (
        1.0f
      );

      if (
        menu == &data->menu_main &&
        index_metil_group_text_main_renderable == menus_menu_main_index_exit
      ) {
        metil_renderer_data_text_backing->color.y = (
          0.5f
        );

        metil_renderer_data_text_backing->color.z = (
          0.5f
        );
      } else {
        metil_renderer_data_text_backing->color.y = (
          1.0f
        );

        metil_renderer_data_text_backing->color.z = (
          1.0f
        );
      }

      metil_renderer_data_text->color.x = (
        1.0f
      );

      metil_renderer_data_text->color.y = (
        1.0f
      );

      metil_renderer_data_text->color.z = (
        1.0f
      );
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

    if (
      data->menu_current == &data->menu_main
    ) {
      switch (
        menu->index_selected
      ) {
        case menus_menu_main_index_start: {
          metil_debug_log(
            metil->configuration.debug_log_level,
            "scene_menu_main:starting\n"
          );

          data->time_started = (
            scene->time
          );

          break;
        }
        default:
        case menus_menu_main_index_custom: {
          menu->index_selected = -1;
          menu->handled = 0;

          metil_group_text_main_backing->visible = 0;
          metil_group_text_main->visible = 0;

          metil_group_text_menu_custom_backing->visible = 1;
          metil_group_text_menu_custom->visible = 1;

          data->menu_current = &(
            data->menu_main_custom
          );

          data->menu_current->index_current = (
            0
          );

          metil_stopwatch_start(
            &data->menu_current->stopwatch_input
          );

          break;
        }
        case menus_menu_main_index_exit: {
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
    } else {
      switch (
        menu->index_selected
      ) {
        case menus_menu_main_custom_index_start: {
          metil_debug_log(
            metil->configuration.debug_log_level,
            "scene_menu_main:starting\n"
          );

          data->time_started = (
            scene->time
          );

          break;
        }
        default:
        case menus_menu_main_custom_index_back: {
          menu->index_selected = -1;
          menu->handled = 0;

          metil_group_text_main_backing->visible = 1;
          metil_group_text_main->visible = 1;

          metil_group_text_menu_custom_backing->visible = 0;
          metil_group_text_menu_custom->visible = 0;

          data->menu_current = &(
            data->menu_main
          );

          data->menu_current->index_current = (
            0
          );

          metil_stopwatch_start(
            &data->menu_current->stopwatch_input
          );

          break;
        }
      }
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
    scene_menu_main_data->menu_current
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
    &scene_menu_main_data->menu_main
  );

  metil_menu_destroy(
    &scene_menu_main_data->menu_main_custom
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

  struct metil_scene* metil_scene_menu_main= &(
    metil_scene_controller->scene
  );

  struct scene_menu_main_data* scene_menu_main_data = (
    metil_scene_menu_main->data
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
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_menu_main= &(
    metil_scene_controller->scene
  );

  struct scene_menu_main_data* scene_menu_main_data = (
    metil_scene_menu_main->data
  );

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
