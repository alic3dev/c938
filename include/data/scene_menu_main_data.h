#ifndef __c938_data_scene_menu_main_data_h
#define __c938_data_scene_menu_main_data_h

#include <data/parameters_gameplay.h>

#include <metil_menus/metil_menu.h>
#include <network/network_host.h>

#include <stdio.h>

struct scene_menu_main_data {
  struct metil_menu* _Nonnull menu_current;
  struct metil_menu menu_main;
  struct metil_menu menu_main_custom;
  struct metil_menu menu_main_network;

  unsigned long int time_started;

  float angle;

  FILE* _Nonnull file_audio;

  struct parameters_gameplay* _Nonnull parameters_gameplay;
};

#endif
