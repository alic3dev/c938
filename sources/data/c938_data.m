#include <data/c938_data.h>

#include <logging/c938_logging.h>
#include <network/network_client.h>
#include <network/network_host.h>

void c938_data_initialize(
  struct c938_data* c938_data
) {
  c938_logging_initialize(
    &c938_data->logging
  );

  c938_data->network_host.initialized = 0;
  c938_data->network_client.status = (
    network_client_status_none
  );
}

void c938_data_destroy(
  struct metil* metil,
  struct c938_data* c938_data
) {
  network_client_destroy(
    &c938_data->network_client
  );

  network_host_destroy(
    &c938_data->network_host
  );

  c938_logging_destroy(
    metil,
    &c938_data->logging
  );
}
