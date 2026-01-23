#ifndef __c938_network_network_host_client_h
#define __c938_network_network_host_client_h

#include <network/network_client_status.h>
#include <network/network_client_status_game.h>
#include <network/network_command.h>

#include <math_c_vector.h>

#include <pthread.h>

struct network_host_client_shot_fired;

struct network_host_client {
  int socket;

  unsigned int index;
  char* char_array_index;

  pthread_mutex_t mutex;
  pthread_mutex_t mutex_position;
  pthread_mutex_t mutex_sending;
  pthread_mutex_t mutex_shots_fired;

  enum network_client_status status;
  enum network_client_status_game status_game;

  enum network_command command_sending;

  struct math_c_vector3_float position;

  struct network_host_client_shot_fired* shots_fired;
  unsigned int length_shots_fired;
};

struct network_host_client_shot_fired {
  struct math_c_vector3_float position;
  struct math_c_vector2_float angle;
  unsigned long int time;
};

void network_host_client_initialize(
  struct network_host_client*,
  int,
  unsigned int
);

void network_host_client_shots_fired_clear(
  struct network_host_client*
);

void network_host_client_shots_fired_add(
  struct network_host_client*,
  unsigned int
);

void network_host_client_destroy(
  struct network_host_client*
);

#endif
