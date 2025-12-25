#include <player_data.h>

#include <metil_rendering/camera/camera.h>

void player_data_initialize(
  struct player_data* player_data
) {
  player_data->buildings = (
    (void*) 0
  );

  player_data->projectiles = (
    (void*) 0
  );

  player_data->time_jump = 0;
  player_data->time_boost = 0;

  player_data->is_jumping = 0;
  player_data->is_jumping_secondary = 0;

  player_data->is_boosted = 0;

  player_data->shooting = 0;

  player_data->height = __metil_camera_height_default;
}
