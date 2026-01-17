#include <c938_logging.h>

#include <metil_group.h>

void c938_logging_initialize(
  struct c938_logging* c938_logging
) {
  metil_group_initialize(
    &c938_logging->group
  );
}
