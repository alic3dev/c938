#ifndef __player_h
#define __player_h

#include <metil_player.h>

extern const float player_speed_movement_default;
extern const float player_speed_rotation_default;

extern const unsigned long int delta_time_jump_threshold;

void player_poll_input(
  struct metil_player*,
  unsigned long int,
  unsigned long int
);

void player_poll(
  struct metil_player*
);

void player_destroy(
  struct metil_player*
);

#endif
