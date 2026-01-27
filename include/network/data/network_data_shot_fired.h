#ifndef network_data_network_data_shot_fired_h
#define network_data_network_data_shot_fired_h

#include <math_c_vector.h>

struct network_data_shot_fired {
  struct math_c_vector3_float position;
  struct math_c_vector2_float angle;
  unsigned long int time;
};

#endif
