#ifndef __c938_data_h
#define __c938_data_h

#include <logging/c938_logging.h>

#include <data/parameters_gameplay.h>

#include <network/network_client.h>
#include <network/network_host.h>

struct c938_data {
  struct c938_logging logging;

  struct parameters_gameplay parameters_gameplay;

  struct network_client network_client;
  struct network_host network_host;
};

void c938_data_initialize(
  struct c938_data* _Nonnull
);

void c938_data_destroy(
  struct metil* _Nonnull,
  struct c938_data* _Nonnull
);

#endif
