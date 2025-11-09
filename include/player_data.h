#ifndef __player_data_h
#define __player_data_h

#include <metil_rendering/metil_renderable.h>

#include <clic3_vector.h>

struct player_data {
  struct metil_renderable* renderables;
  unsigned short int length_renderables;

  unsigned long int time_boost;
  unsigned long int time_jump;

  unsigned char is_boosted;
  unsigned char is_jumping;
  unsigned char is_jumping_secondary;

  unsigned int on_ground;
};

void player_data_initialize(
  struct player_data*
);

#endif
