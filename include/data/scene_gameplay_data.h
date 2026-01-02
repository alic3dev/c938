#ifndef __scene_gameplay_data_h
#define __scene_gameplay_data_h

#include <metil_menus/metil_menu.h>

#define scene_gameplay_data_length_projectiles_maximum 200

struct scene_gameplay_data {
  struct metil_menu menu;
  unsigned char visible_menu;

  unsigned long int fired_projectiles[
    scene_gameplay_data_length_projectiles_maximum
  ];
  unsigned int length_projectiles;
};

#endif
