#ifndef __c938_logging_h
#define __c938_logging_h

#include <metil_group.h>

struct c938_logging {
  struct metil_group group;
};

void c938_logging_initialize(
  struct c938_logging* _Nonnull
);

#endif
