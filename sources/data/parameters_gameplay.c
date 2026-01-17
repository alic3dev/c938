#include <data/parameters_gameplay.h>

void parameters_gameplay_initialize(
  struct parameters_gameplay* parameters_gameplay,
  float speed_movement_default
) {
  parameters_gameplay->objective = (
    gameplay_objective_target
  );

  parameters_gameplay->speed_movement = (
    speed_movement_default
  );

  parameters_gameplay->length_buildings = (
    parameters_gameplay_length_buildings_default
  );

  parameters_gameplay->length_enemies = (
    parameters_gameplay_length_enemies_default
  );

  parameters_gameplay->multiplier_buildings = (
    0.9f
  );

  parameters_gameplay->multiplier_enemies = (
    1.25f
  );

  parameters_gameplay->multiplier_speed_movement = (
    1.2f
  );

  parameters_gameplay->networked = (
    parameters_gameplay_networked_none
  );
}
