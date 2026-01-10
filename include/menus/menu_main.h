#ifndef __menus_menu_main_h
#define __menus_menu_main_h

#include <metil_menus/metil_menu.h>

#define menus_menu_main_length 3

enum menus_menu_main_index {
  menus_menu_main_index_start = 0,
  menus_menu_main_index_custom = 1,
  menus_menu_main_index_exit = 2
};

void menu_main_initialize(
  struct metil_menu* _Nonnull
);

#endif
