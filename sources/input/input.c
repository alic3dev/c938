#include <input/input.h>
#include <input/cursor.h>
#include <input/map.h>

void input_initialize() {
  input_cursor_initialize();
  input_maps_initialize();
}
