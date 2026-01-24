#include <data/data_length.h>

#include <data/parameters_gameplay.h>
#include <network/data/network_data_shot_fired.h>

#include <math_c_vector.h>

const unsigned long int data_length_float = (
  sizeof(
    float
  )
);

const unsigned long int data_length_math_c_vector2_float = (
  sizeof(
    struct math_c_vector2_float
  )
);

const unsigned long int data_length_math_c_vector3_float = (
  sizeof(
    struct math_c_vector3_float
  )
);

const unsigned long int data_length_parameters_gameplay = (
  sizeof(
    struct parameters_gameplay
  ) -
  // this is minus the networked parameter since that is application specific
  1
);

const unsigned long int data_length_unsigned_int = (
  sizeof(
    unsigned int
  )
);

const unsigned long int data_length_unsigned_long_int = (
  sizeof(
    unsigned long int
  )
);

const unsigned long int data_length_network_data_shot_fired = (
  sizeof(
    struct network_data_shot_fired
  )
);
