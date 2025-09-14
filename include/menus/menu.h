#ifndef __menus_menu_h
#define __menus_menu_h

#include <menus/menu_item.h>
#include <utilities/stopwatch.h>

#define milliseconds_menu_input_delay 200

struct menu;

struct menu {
  unsigned char index_current;
  signed int index_selected;

  unsigned char handled;
  
  unsigned char length_items;
  struct menu_item* items;

  unsigned char wrap;

  struct stopwatch stopwatch_input;
};

void menu_initialize(
  struct menu*
);

void menu_item_add(
  struct menu*,
  enum menu_item_type,
  enum menu_item_action,
  void*
);

void menu_poll_input(
  struct menu*
);

void menu_select(
  struct menu*
);

unsigned char menu_next(
  struct menu*
);

unsigned char menu_previous(
  struct menu*
);

void menu_destroy(
  struct menu*
);

#endif
