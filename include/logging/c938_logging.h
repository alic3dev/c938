#ifndef __c938_logging_h
#define __c938_logging_h

#define c938_logging_time_display_length 3938

#include <metil.h>
#include <metil_group.h>
#include <metil_utilities/metil_stopwatch.h>

#include <pthread.h>

struct c938_logging {
  struct metil_group group;
  struct metil_stopwatch* _Nonnull stopwatches;

  char* _Nonnull * _Nonnull buffer_logs;
  unsigned int length_buffer_logs;

  float position_y;
  float scale;

  pthread_mutex_t mutex;
};

void c938_logging_initialize(
  struct c938_logging* _Nonnull
);

void c938_logging_log(
  struct metil* _Nonnull,
  char* _Nonnull
);

void c938_logging_poll(
  struct metil* _Nonnull
);

void c938_logging_destroy(
  struct metil* _Nonnull,
  struct c938_logging* _Nonnull
);

#endif
