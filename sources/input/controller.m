#include <input/controller.h>

#include <GameController/GameController.h>

struct controller_state controller_state = {
  .trigger_left = 0.0f,
  .trigger_right = 0.0f,

  .thumbstick_axis_x_left = 0.0f,
  .thumbstick_axis_y_left = 0.0f,

  .input_axis_x_right = 0.0f,
  .thumbstick_axis_y_right = 0.0f,

  .thumbstick_button_left = 0.0f,
  .thumbstick_button_right = 0.0f,

  .button_directional_pad_down = 0.0f,
  .button_directional_pad_right = 0.0f,
  .button_directional_pad_left = 0.0f,
  .button_directional_pad_up = 0.0f,

  .button_cross = 0.0f,
  .button_circle = 0.0f,
  .button_square = 0.0f,
  .button_triangle = 0.0f,

  .available = 0
};

void controller_poll() {
  // TODO: GCDualSenseGamepad: Add DualSense specific functionality

  GCController* controller = [GCController current];
  GCExtendedGamepad* profile_controller = (
    controller != (void*)0
    ? (GCDualSenseGamepad*) [controller extendedGamepad]
    : (void*)0
  );

  if (profile_controller != (void*)0) {
    GCControllerButtonInput* trigger_left = [profile_controller leftTrigger];
    GCControllerButtonInput* trigger_right = [profile_controller rightTrigger];
    
    GCControllerDirectionPad* thumbstick_right = [profile_controller rightThumbstick];
    GCControllerAxisInput* thumbstick_axis_y_right = [thumbstick_right yAxis];
    GCControllerAxisInput* input_axis_x_right = [thumbstick_right xAxis];

    GCControllerDirectionPad* thumbstick_left = [profile_controller leftThumbstick];
    GCControllerAxisInput* thumbstick_axis_y_left = [thumbstick_left yAxis];
    GCControllerAxisInput* thumbstick_axis_x_left = [thumbstick_left xAxis];

    controller_state.trigger_left = trigger_left.value;
    controller_state.trigger_right = trigger_right.value;

    controller_state.thumbstick_axis_x_left = thumbstick_axis_x_left.value;
    controller_state.thumbstick_axis_y_left = thumbstick_axis_y_left.value;

    controller_state.input_axis_x_right = input_axis_x_right.value;
    controller_state.thumbstick_axis_y_right = thumbstick_axis_y_right.value;

    controller_state.thumbstick_button_left = [profile_controller leftThumbstickButton].value;
    controller_state.thumbstick_button_right = [profile_controller rightThumbstickButton].value;

    GCControllerDirectionPad* directional_pad = [profile_controller dpad];

    controller_state.button_directional_pad_down = directional_pad.down.value;
    controller_state.button_directional_pad_right = directional_pad.right.value;
    controller_state.button_directional_pad_left = directional_pad.left.value;
    controller_state.button_directional_pad_up = directional_pad.up.value;

    controller_state.button_cross = [profile_controller buttonA].value;
    controller_state.button_circle = [profile_controller buttonB].value;
    controller_state.button_square = [profile_controller buttonX].value;
    controller_state.button_triangle = [profile_controller buttonY].value;

    controller_state.available = 1;
  } else {
    controller_state.trigger_left = 0.0f;
    controller_state.trigger_right = 0.0f;

    controller_state.thumbstick_axis_x_left = 0.0f;
    controller_state.thumbstick_axis_y_left = 0.0f;

    controller_state.input_axis_x_right = 0.0f;
    controller_state.thumbstick_axis_y_right = 0.0f;

    controller_state.thumbstick_button_left = 0.0f;
    controller_state.thumbstick_button_right = 0.0f;

    controller_state.available = 0;
  }
}
