#include <utilities/time.h>

#include <sys/time.h>

unsigned long int time_milliseconds_get() {
  struct timeval timeval;

  gettimeofday(
    &timeval,
    (void*)0
  );

  return (
    time_seconds_to_milliseconds(timeval.tv_sec) +
    time_microseconds_to_milliseconds(timeval.tv_usec)
  );
}
