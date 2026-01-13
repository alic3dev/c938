#ifndef __menus_menu_main_custom_h
#define __menus_menu_main_custom_h

#include <metil_menus/metil_menu.h>

#define menus_menu_main_custom_length 3

enum menus_menu_main_custom_index {
  menus_menu_main_custom_index_start = 0,
  menus_menu_main_custom_index_mode = 1,
  menus_menu_main_custom_index_back = 2
};

void menu_main_custom_initialize(
  struct metil_menu*
);

#endif
