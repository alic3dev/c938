#ifndef __c938_parameters_gameplay_h
#define __c938_parameters_gameplay_h

#define parameters_gameplay_length_buildings_default 200

enum gameplay_objective {
  gameplay_objective_target = 0,
  gameplay_objective_enemies = 1
};

struct parameters_gameplay {
  enum gameplay_objective objective;

  float speed_movement;

  unsigned int length_buildings;
};

void parameters_gameplay_initialize(
  struct parameters_gameplay*,
  float
);

#endif
