#include <c938.h>

#include <player.h>
#include <scenes/scene_id.h>
#include <scenes/scene_menu_main.h>
#include <scenes/scene_gameplay.h>

#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_player.h>
#include <metil_rendering/rendering_properties.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>

#include <Metal/MTLDevice.h>

int main(
  int length_parameters,
  const char** parameters
) {
  metil_player_speed_movement_default = player_speed_movement_default;

  return metil_initialize(
    length_parameters,
    parameters,
    "c938",
    c938_renderer_on_initialize
  );
}

void c938_renderer_on_initialize(
  id<MTLDevice> metal_kit_device,
  struct metil_rendering_properties* metil_rendering_properties,
  void* data
) {
  metil_library.library = [metal_kit_device newDefaultLibrary];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: @"c938_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: @"c938_fragment"
  ];

  metil_library_initialize_fps_display(
    metal_kit_device,
    (void*)0
  );

  metil_rendering_properties->color_clear.x = 0.0724f;
  metil_rendering_properties->color_clear.y = 0.0824f;
  metil_rendering_properties->color_clear.z = 0.1049f;
  metil_rendering_properties->color_clear.w = 1.0f;

  scene_menu_main_initialize(
    &metil_scene_controller.scene,
    metal_kit_device
  );

  metil_scene_controller_on_scene_change_add(
    c938_on_scene_change,
    metal_kit_device
  );
}

void c938_on_scene_change(
  int id_scene,
  void* data
) {
  id<MTLDevice> metal_kit_device = (
    (id<MTLDevice>) data
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
        metal_kit_device
      );
      break;
    case scene_id_gameplay:
      scene_gameplay_initialize(
        &metil_scene_controller.scene,
        metal_kit_device
      );
      break;
  }
}
