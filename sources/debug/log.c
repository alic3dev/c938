#include <debug/log.h>

#include <stdio.h>

enum debug_log_level debug_log_level = debug_log_level_error;

void debug_log(
  char* buffer_output
) {
  if (
    debug_log_level != debug_log_level_all
  ) {
    return;
  }

  fprintf(
    stdout,
    "%s",
    buffer_output
  );
}

void debug_log_error(
  char* buffer_output
) {
  if (
    debug_log_level == debug_log_level_none
  ) {
    return;
  }

  fprintf(
    stderr,
    "%s",
    buffer_output
  );
}
