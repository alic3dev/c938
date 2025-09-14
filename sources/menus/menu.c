#include <menus/menu.h>

#include <input/controller.h>
#include <input/keycodes.h>
#include <input/map.h>
#include <menus/menu_item.h>

#include <stdlib.h>
#include <sys/time.h>

void menu_initialize(
  struct menu* menu
) {
  menu->index_current = 0;

  menu->length_items = 0;
  menu->items = malloc(
    sizeof(struct menu_item) *
    menu->length_items
  );

  menu->index_selected = -1;
  menu->handled = 0;

  menu->wrap = 1;

  stopwatch_start(
    &menu->stopwatch_input
  );
}

void menu_poll_input(
  struct menu* menu
) {
  if (
    menu->index_selected != -1
  ) {
    return;
  }

  if (
    input_map_keydown[
      keycode_space
    ] == 1 ||
    controller_state.button_cross > 0.0f
  ) {
    menu_select(
      menu
    );

    return;
  }

  unsigned long int delta = stopwatch_elapsed(
    &menu->stopwatch_input
  );

  if (
    delta < milliseconds_menu_input_delay
  ) {
    return;
  }

  unsigned char had_input = 0;

  if (
    input_map_keydown[
      keycode_up_arrow
    ] == 1 || 
    controller_state.button_directional_pad_up > 0.0f ||
    controller_state.thumbstick_axis_y_left > 0.1f
  ) {
    had_input = 1;

    menu_previous(
      menu
    );
  } else if (
    input_map_keydown[
      keycode_down_arrow
    ] == 1 || 
    controller_state.button_directional_pad_down > 0.0f ||
    controller_state.thumbstick_axis_y_left < -0.1f
  ) {
    had_input = 1;

    menu_next(
      menu
    );
  }

  if (
    had_input == 1
  ) {
    stopwatch_start(
      &menu->stopwatch_input
    );
  }
}

void menu_item_add(
  struct menu* menu,
  enum menu_item_type type,
  enum menu_item_action action,
  void* data
) {
  menu->length_items = (
    menu->length_items + 1
  );

  menu->items = realloc(
    menu->items,
    sizeof(struct menu_item) *
    menu->length_items
  );

  menu_item_initialize(
    &menu->items[
      menu->length_items - 1
    ],
    type,
    action,
    data
  );
}

void menu_select(
  struct menu* menu
) {
  if (menu->length_items == 0) {
    return;
  }

  menu->index_selected = menu->index_current;
}

unsigned char menu_next(
  struct menu* menu
) {
  if (
    menu->index_current == menu->length_items - 1
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_current = 0;
  } else {
    menu->index_current = (
      menu->index_current + 1
    );
  }

  return 0;
}

unsigned char menu_previous(
  struct menu* menu
) {
  if (
    menu->index_current == 0
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_current = (
      menu->length_items - 1
    );
  } else {
    menu->index_current = (
      menu->index_current - 1
    );
  }

  return 0;
}

void menu_destroy(
  struct menu* menu
) {
  free(menu->items);
}
