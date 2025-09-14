#ifndef __input_controller_h
#define __input_controller_h

struct controller_state {
  float trigger_left;
  float trigger_right;

  float thumbstick_axis_x_left;
  float thumbstick_axis_y_left;

  float input_axis_x_right;
  float thumbstick_axis_y_right;

  float thumbstick_button_left;
  float thumbstick_button_right;

  float button_directional_pad_down;
  float button_directional_pad_right;
  float button_directional_pad_left;
  float button_directional_pad_up;

  float button_cross;
  float button_circle;
  float button_square;
  float button_triangle;

  unsigned char available;
};

extern struct controller_state controller_state;

void controller_poll();

#endif
