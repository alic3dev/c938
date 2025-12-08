#include <c938.h>

#include <application/c938_application_delegate.h>
#include <pipeline_index.h>
#include <player.h>
#include <scenes/scene_id.h>
#include <scenes/scene_menu_main.h>
#include <scenes/scene_gameplay.h>

#include <metil_configuration/configuration.h>
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_player.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>

#include <Metal/MTLDevice.h>

int main(
  int length_parameters,
  #if target_os_ios
  char** parameters
  #else
  const char** parameters
  #endif
) {
  metil_configuration_default_rendering_properties_brightness = 0.05f;
  metil_configuration_default_rendering_properties_brightness_text = 0.5f;

  metil_player_speed_movement_default = player_speed_movement_default;

  #if target_os_ios
  metil_initialize(
    length_parameters,
    parameters,
    "c938",
    c938_renderer_on_initialize
  );

  return UIApplicationMain(
    length_parameters,
    parameters,
    (void*)0,
    NSStringFromClass([c938_application_delegate class])
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

void c938_renderer_on_initialize(
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_library_initialize(
    metil_renderer_interface->metal_device,
    @"c938_fragment",
    @"c938_vertex"
  );

  metil_renderer_interface->rendering_properties->color_clear.x = (
    0.8724f * metil_configuration.rendering_properties.brightness
  );
  
  metil_renderer_interface->rendering_properties->color_clear.y = (
    0.8824f * metil_configuration.rendering_properties.brightness
  );

  metil_renderer_interface->rendering_properties->color_clear.z = (
    0.9049f * metil_configuration.rendering_properties.brightness
  );

  metil_renderer_interface->rendering_properties->color_clear.w = 1.0f;

  c938_pipeline_index_building = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"c938_building_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"c938_building_vertex"
    ]
  ];

  c938_pipeline_index_ground = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"c938_ground_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"c938_ground_vertex"
    ]
  ];

  c938_pipeline_index_hud_item = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"c938_hud_item_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"c938_hud_item_vertex"
    ]
  ];

  c938_pipeline_index_player = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"c938_player_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"c938_player_vertex"
    ]
  ];

  c938_pipeline_index_text = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"c938_text_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"c938_text_vertex"
    ]
  ];

  c938_pipeline_index_crosshair = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"c938_crosshair_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"c938_crosshair_vertex"
    ]
  ];

  scene_menu_main_initialize(
    &metil_scene_controller.scene,
    metil_renderer_interface->metal_device
  );

  metil_scene_controller_on_scene_change_add(
    c938_on_scene_change,
    metil_renderer_interface
  );
}

void c938_on_scene_change(
  int id_scene,
  void* data
) {
  struct metil_renderer_interface* metil_renderer_interface = (
    (struct metil_renderer_interface*) data
  );

  metil_scene_destroy(
    &metil_scene_controller.scene
  );

  switch (
    id_scene
  ) {
    case scene_id_unknown:
    case scene_id_menu_main:
      scene_menu_main_initialize(
        &metil_scene_controller.scene,
        metil_renderer_interface->metal_device
      );
      break;
    case scene_id_gameplay:
      scene_gameplay_initialize(
        &metil_scene_controller.scene,
        metil_renderer_interface->metal_device
      );
      break;
  }
}
