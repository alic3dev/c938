#ifndef __player_data_h
#define __player_data_h

#include <metil_rendering/metil_renderable.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>

#define player_data_default_rate_fire 24

struct player_data {
  id<MTLDevice> _Nonnull metal_device;

  struct metil_group* _Nonnull buildings;
  struct metil_group* _Nonnull projectiles;

  unsigned long int time_boost;
  unsigned long int time_jump;
  unsigned long int time_shot;

  unsigned char is_boosted;
  unsigned char is_jumping;
  unsigned char is_jumping_secondary;

  unsigned int on_ground;

  unsigned char shooting;

  float height;

  unsigned long int rate_fire;

  unsigned long int* _Nonnull time;
};

void player_data_initialize(
  struct player_data* _Nonnull
);

#endif
