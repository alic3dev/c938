#include <data/c938_data.h>

#include <c938_logging.h>
#include <network/network_client.h>
#include <network/network_host.h>

void c938_data_initialize(
  struct c938_data* c938_data
) {
  c938_logging_initialize(
    &c938_data->logging
  );

  c938_data->network_host.initialized = 0;
}

void c938_data_destroy(
  struct metil* metil,
  struct c938_data* c938_data
) {
  c938_logging_destroy(
    metil,
    &c938_data->logging
  );

  network_client_destroy(
    &c938_data->network_client
  );

  network_host_destroy(
    &c938_data->network_host
  );
}
