#include <utilities/stopwatch.h>
#include <utilities/time.h>

#include <sys/time.h>

void stopwatch_start(
  struct stopwatch* stopwatch
) {
  gettimeofday(
    &stopwatch->timeval,
    (void*)0
  );
}

unsigned long int stopwatch_elapsed(
  struct stopwatch* stopwatch
) {
  return time_milliseconds_get() - (
    time_seconds_to_milliseconds(stopwatch->timeval.tv_sec) +
    time_microseconds_to_milliseconds(stopwatch->timeval.tv_usec)
  );
}
