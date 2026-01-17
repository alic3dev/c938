#ifndef __menus_menu_main_network_h
#define __menus_menu_main_network_h

#include <metil_menus/metil_menu.h>

#define menus_menu_main_network_length 3

enum menus_menu_main_network_index {
  menus_menu_main_network_index_host = 0,
  menus_menu_main_network_index_join = 1,
  menus_menu_main_network_index_back = 2
};

void menu_main_network_initialize(
  struct metil_menu* _Nonnull
);

#endif
