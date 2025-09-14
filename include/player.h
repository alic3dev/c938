#ifndef __player_h
#define __player_h

#include <object.h>

#include <clic3_vector.h>

struct player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float velocity;

  struct object** objects;
  unsigned short int length_objects;

  float speed_movement;
  float speed_rotation;

  unsigned long int time_jump;

  float is_jumping;
  float is_jumping_secondary;

  unsigned int has_collided;
  unsigned int on_ground;
};

void player_initialize(
  struct player*
);

void player_poll_input(
  struct player*,
  unsigned long int
);

void player_poll(
  struct player*
);

void player_destroy(
  struct player*
);

#endif
