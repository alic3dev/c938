#ifndef __input_map_h
#define __input_map_h

#include <input/keycodes.h>

#define input_map_keydown_length keycode_max_value + 1

extern unsigned char input_map_keydown[input_map_keydown_length];

void input_maps_initialize();

void input_map_keydown_initialize();

#endif
