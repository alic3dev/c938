#ifndef __player_data_h
#define __player_data_h

#include <metil_rendering/metil_renderable.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>

struct player_data {
  id<MTLDevice> _Nonnull metal_device;

  struct metil_group* _Nonnull buildings;
  struct metil_group* _Nonnull projectiles;

  unsigned long int time_boost;
  unsigned long int time_jump;

  unsigned char is_boosted;
  unsigned char is_jumping;
  unsigned char is_jumping_secondary;

  unsigned int on_ground;

  unsigned char shooting;

  float height;
};

void player_data_initialize(
  struct player_data* _Nonnull
);

#endif
