#ifndef __debug_log_h
#define __debug_log_h

enum debug_log_level {
  debug_log_level_none,
  debug_log_level_error,
  debug_log_level_all
};

extern enum debug_log_level debug_log_level;

void debug_log(
  char*
);

void debug_log_error(
  char*
);

#endif
