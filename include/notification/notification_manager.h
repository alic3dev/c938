#ifndef __c938_notification_notification_manager_h
#define __c938_notification_notification_manager_h

#include <pthread.h>

typedef void (*notification_manager_notification_on)(
  char*,
  unsigned char,
  void*
);

struct notification_manager {
  unsigned int length_notification_on_functions;
  notification_manager_notification_on* notification_on_functions;
  void** notification_on_functions_data;

  pthread_mutex_t mutex_notification;
};

void notification_manager_initialize(
  struct notification_manager*
);

void notification_manager_notification_on_add(
  struct notification_manager*,
  notification_manager_notification_on,
  void*
);

void notification_manager_send(
  struct notification_manager*,
  char*,
  unsigned char
);

void notification_manager_destroy(
  struct notification_manager*
);

#endif
