#ifndef __c938_data_h
#define __c938_data_h

#include <c938_logging.h>

#include <data/parameters_gameplay.h>

struct c938_data {
  struct c938_logging logging;

  struct parameters_gameplay parameters_gameplay;
};

void c938_data_initialize(
  struct c938_data* _Nonnull
);

#endif
