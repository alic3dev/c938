#include <data/player_data.h>

void player_data_initialize(
  struct player_data* player_data,
  float height
) {
  player_data->buildings = (
    (void*) 0
  );

  player_data->projectiles = (
    (void*) 0
  );

  player_data->time_jump = 0;
  player_data->time_boost = 0;
  player_data->time_shot = 0;

  player_data->is_jumping = 0;
  player_data->is_jumping_secondary = 0;

  player_data->is_boosted = 0;

  player_data->shooting = 0;

  player_data->height = height;

  player_data->life_maximum = 3;
  player_data->life = player_data->life_maximum;

  player_data->rate_fire = player_data_default_rate_fire;

  player_data->time = (
    (void*) 0
  );
}
