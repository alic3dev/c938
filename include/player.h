#ifndef __player_h
#define __player_h

#include <metil_player.h>

void player_poll_input(
  struct metil_player*,
  unsigned long int
);

void player_poll(
  struct metil_player*
);

void player_destroy(
  struct metil_player*
);

#endif
