#ifndef __utilities_time_h
#define __utilities_time_h

#define time_seconds_to_microseconds(x) ((x) * 1000000000)
#define time_seconds_to_milliseconds(x) ((x) * 1000)
#define time_microseconds_to_milliseconds(x) ((x) / 1000)

unsigned long int time_milliseconds_get();

#endif
