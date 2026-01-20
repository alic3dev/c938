#include <network/network_host_client.h>

#include <unistd.h>

void network_host_client_initialize(
  struct network_host_client* network_host_client,
  int network_host_client_socket
) {
  network_host_client->socket = (
    network_host_client_socket
  );

  pthread_mutex_init(
    &network_host_client->mutex,
    0
  );

  pthread_mutex_init(
    &network_host_client->mutex_sending,
    0
  );

  pthread_mutex_lock(
    &network_host_client->mutex_sending
  );

  network_host_client->command_sending = (
    network_command_no_operation
  );

  network_host_client->status = (
    network_client_status_initializing
  );
}

void network_host_client_destroy(
  struct network_host_client* network_host_client
) {
  close(
    network_host_client->socket
  );

  pthread_mutex_destroy(
    &network_host_client->mutex
  );

  pthread_mutex_destroy(
    &network_host_client->mutex_sending
  );
}
