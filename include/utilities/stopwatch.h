#ifndef __utilities_stopwatch_h
#define __utilities_stopwatch_h

#include <sys/time.h>

struct stopwatch {
  struct timeval timeval;
};

void stopwatch_start(
  struct stopwatch*
);

unsigned long int stopwatch_elapsed(
  struct stopwatch*
);

#endif
