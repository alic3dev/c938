#include <c938.h>

#include <c938_pipeline_index.h>
#include <data/c938_data.h>
#include <data/parameters_gameplay.h>
#include <data/scene_menu_main_data.h>
#include <player.h>
#include <scenes/scene_id.h>
#include <scenes/scene_menu_main/scene_menu_main.h>
#include <scenes/scene_gameplay/scene_gameplay.h>

#include <clic3_memory.h>

#if target_os_ios
#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_application/metil_view_controller.h>
#endif
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

#if target_os_ios
char* c938_executable_path = 0;
#endif

int main(
  int length_parameters,
  #if target_os_ios
  char** parameters
  #else
  const char** parameters
  #endif
) {
  #if target_os_ios
  c938_executable_path = (
    parameters[0]
  );

  metil_view_controller_on_view_did_load = (
    c938_view_controller_on_view_did_load
  );

  return UIApplicationMain(
    length_parameters,
    parameters,
    NSStringFromClass([metil_application class]),
    NSStringFromClass([metil_application_delegate class])
  );
  #else
  return metil_initialize(
    length_parameters,
    parameters,
    "c938",
    c938_renderer_on_initialize
  );
  #endif
}

#if target_os_ios
void c938_view_controller_on_view_did_load() {
  metil_initialize(
    1,
    &c938_executable_path,
    "c938",
    c938_renderer_on_initialize
  );
}
#endif

void c938_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil->player_defaults.speed_movement = (
    player_speed_movement_default
  );

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"c938_fragment",
    @"c938_vertex"
  );

  metil->renderer_interface.rendering_properties->colour_clear.x = (
    0.0f *
    metil->rendering_properties.brightness
  );
  
  metil->renderer_interface.rendering_properties->colour_clear.y = (
    0.0f *
    metil->rendering_properties.brightness
  );

  metil->renderer_interface.rendering_properties->colour_clear.z = (
    0.0f *
    metil->rendering_properties.brightness
  );

  metil->renderer_interface.rendering_properties->colour_clear.w = (
    1.0f
  );

  c938_pipeline_index_building = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_building_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_building_vertex"
    ]
  ];

  c938_pipeline_index_ground = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_ground_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_ground_vertex"
    ]
  ];

  c938_pipeline_index_hud_item = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_hud_item_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_hud_item_vertex"
    ]
  ];

  c938_pipeline_index_player = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_player_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_player_vertex"
    ]
  ];

  c938_pipeline_index_text = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_text_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_text_vertex"
    ]
  ];

  c938_pipeline_index_crosshair = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_crosshair_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_crosshair_vertex"
    ]
  ];

  c938_pipeline_index_projectile = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_projectile_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_projectile_vertex"
    ]
  ];

  c938_pipeline_index_enemy = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_enemy_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_enemy_vertex"
    ]
  ];

  c938_pipeline_index_text_backing_menu = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"c938_text_backing_menu_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"c938_text_backing_menu_vertex"
    ]
  ];

  metil->text_defaults.object_text_index_pipeline_render = (
    c938_pipeline_index_text
  );

  metil->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct c938_data
      )
    )
  );

  struct c938_data* c938_data = (
    metil->data
  );

  c938_data_initialize(
    c938_data
  );

  parameters_gameplay_initialize(
    &c938_data->parameters_gameplay,
    metil->player_defaults.speed_movement
  );

  metil_termination_on_function_add(
    &metil->termination,
    c938_termination,
    metil
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  scene_menu_main_initialize(
    metil,
    &metil_scene_controller->scene
  );

  metil_scene_controller_on_scene_change_add(
    metil_scene_controller,
    c938_on_scene_change,
    0
  );
}

void c938_on_scene_change(
  struct metil* metil,
  int id_scene,
  void* data
) {
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  metil_scene_destroy(
    metil,
    metil_scene
  );

  switch (
    id_scene
  ) {
    case scene_id_unknown:
    case scene_id_menu_main:
      scene_menu_main_initialize(
        metil,
        metil_scene
      );
      break;
    case scene_id_gameplay:
      scene_gameplay_initialize(
        metil,
        metil_scene
      );
      break;
  }
}

void c938_termination(
  void* data
) {
  struct metil* metil = (
    data
  );

  struct c938_data* c938_data = (
    metil->data
  );

  c938_data_destroy(
    metil,
    c938_data
  );

  clic3_memory_free_raw(
    c938_data
  );
}
