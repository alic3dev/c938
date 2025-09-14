#include <input/map.h>

#include <input/keycodes.h>

unsigned char input_map_keydown[input_map_keydown_length];

void input_maps_initialize() {
  input_map_keydown_initialize();
}

void input_map_keydown_initialize() {
  for (
    unsigned char index_keycode = 0;
    index_keycode <= keycode_max_value;
    ++index_keycode
  ) {
    input_map_keydown[
      index_keycode
    ] = 0;
  }
}
