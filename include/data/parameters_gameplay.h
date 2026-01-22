#ifndef __c938_data_parameters_gameplay_h
#define __c938_data_parameters_gameplay_h

#define parameters_gameplay_length_buildings_default 200
#define parameters_gameplay_length_enemies_default 255

enum gameplay_objective {
  gameplay_objective_target = 0,
  gameplay_objective_enemies = 1
};

enum parameters_gameplay_networked {
  parameters_gameplay_networked_none = 0b0000,
  parameters_gameplay_networked_host = 0b0001,
  parameters_gameplay_networked_client = 0b0010
};

struct parameters_gameplay {
  enum gameplay_objective objective;

  float speed_movement;

  unsigned int length_buildings;
  unsigned int length_enemies;

  float multiplier_buildings;
  float multiplier_enemies;
  float multiplier_speed_movement;

  unsigned char networked;
};

void parameters_gameplay_initialize(
  struct parameters_gameplay*,
  float
);

#endif
