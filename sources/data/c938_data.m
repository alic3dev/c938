#include <data/c938_data.h>

#include <c938_logging.h>

void c938_data_initialize(
  struct c938_data* c938_data
) {
  c938_logging_initialize(
    &c938_data->logging
  );
}
