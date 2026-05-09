#include <data/player_data.h>

void player_data_initialize(
  struct player_data* player_data,
  float height
) {
  player_data->buildings = (
    0x00
  );

  player_data->projectiles = (
    0x00
  );

  player_data->height = (
    height
  );

  player_data->is_jumping = (
    0x00
  );

  player_data->is_jumping_secondary = (
    0x00
  );

  player_data->is_boosted = (
    0x00
  );

  player_data->life_maximum = (
    0x03
  );

  player_data->life = (
    player_data->life_maximum
  );

  player_data->rate_fire = (
    player_data_default_rate_fire
  );

  player_data->shooting = (
    0x00
  );

  player_data->time = (
    0x00
  );

  player_data->time_jump = (
    0x00
  );

  player_data->time_boost = (
    0x00
  );

  player_data->time_shot = (
    0x00
  );
}
