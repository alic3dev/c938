#ifndef __c938_data_scene_gameplay_data_h
#define __c938_data_scene_gameplay_data_h

#include <data/parameters_gameplay.h>

#include <metil_menus/metil_menu.h>

#include <pthread.h>

#define scene_gameplay_data_length_projectiles_maximum 200

struct scene_gameplay_data {
  struct metil_menu menu;

  unsigned char visible_menu;

  unsigned long int fired_projectiles[
    scene_gameplay_data_length_projectiles_maximum
  ];

  float speed_movement;

  unsigned int length_buildings;
  unsigned int length_enemies;
  unsigned int length_projectiles;

  struct parameters_gameplay* parameters;

  pthread_mutex_t mutex_data_map;
};

#endif
