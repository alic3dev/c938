#include <data/parameters_gameplay.h>

void parameters_gameplay_initialize(
  struct parameters_gameplay* parameters_gameplay,
  float speed_movement_default
) {
  parameters_gameplay->speed_movement = (
    speed_movement_default
  );

  parameters_gameplay->length_buildings = (
    parameters_gameplay_length_buildings_default
  );
}
