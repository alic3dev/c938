#ifndef __player_h
#define __player_h

#include <metil_player/metil_player.h>

extern const float player_speed_movement_default;

extern const float player_jump_velocity;

extern const unsigned long int delta_time_jump_threshold;

void player_poll_input(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

void player_poll(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

void player_destroy(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

#endif
