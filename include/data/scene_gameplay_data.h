#ifndef __scene_gameplay_data_h
#define __scene_gameplay_data_h

#include <metil_menus/metil_menu.h>

struct scene_gameplay_data {
  struct metil_menu menu;
  unsigned char visible_menu;

  unsigned long int* _Nonnull fired_projectiles;
  unsigned int length_projectiles;
};

#endif
