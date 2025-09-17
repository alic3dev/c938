#ifndef __player_data_h
#define __player_data_h

#include <metil_object.h>

#include <clic3_vector.h>

struct player_data {
  struct metil_object** objects;
  unsigned short int length_objects;

  unsigned long int time_jump;

  float is_jumping;
  float is_jumping_secondary;

  unsigned int has_collided;
  unsigned int on_ground;
};

void player_data_initialize(
  struct player_data*
);

#endif
