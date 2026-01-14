#ifndef __menus_menu_main_custom_h
#define __menus_menu_main_custom_h

#include <data/parameters_gameplay.h>
#include <metil_menus/metil_menu.h>

#define menus_menu_main_custom_length 9

enum menus_menu_main_custom_index {
  menus_menu_main_custom_index_start = 0,
  menus_menu_main_custom_index_mode = 1,
  menus_menu_main_custom_index_length_buildings = 2,
  menus_menu_main_custom_index_multiplier_buildings = 3,
  menus_menu_main_custom_index_length_enemies = 4,
  menus_menu_main_custom_index_multiplier_enemies = 5,
  menus_menu_main_custom_index_speed_movement = 6,
  menus_menu_main_custom_index_multiplier_speed_movement = 7,
  menus_menu_main_custom_index_back = 8
};

void menu_main_custom_initialize(
  struct metil_menu*,
  struct parameters_gameplay*
);

#endif
