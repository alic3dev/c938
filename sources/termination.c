#include <termination.h>

#include <stdlib.h>

termination_on_function* termination_on_functions = (void*)0;
void** termination_on_functions_data = (void*)0;
unsigned short int termination_length_on_functions = 0;

void termination_initialize() {
  termination_on_functions = malloc(
    sizeof(termination_on_function) *
    termination_length_on_functions
  );

  termination_on_functions_data = malloc(
    sizeof(termination_on_function) *
    termination_length_on_functions
  );
}

void termination_on_function_add(
  termination_on_function on,
  void* data
) {
  termination_length_on_functions = (
    termination_length_on_functions + 1
  );

  termination_on_functions = realloc(
    termination_on_functions,
    sizeof(termination_on_function) *
    termination_length_on_functions
  );

  termination_on_functions[
    termination_length_on_functions - 1
  ] = on;


  termination_on_functions_data = realloc(
    termination_on_functions_data,
    sizeof(void*) *
    termination_length_on_functions
  );

  termination_on_functions_data[
    termination_length_on_functions - 1
  ] = data;
}

void termination_on_function_remove(
  termination_on_function on
) {
  for (
    signed int index_termination_on = 0;
    index_termination_on < termination_length_on_functions;
    ++index_termination_on
  ) {
    if (
      on == termination_on_functions[index_termination_on]
    ) {
      termination_length_on_functions = (
        termination_length_on_functions - 1
      );

      for (
        unsigned short int index_termination_on_offset = index_termination_on;
        index_termination_on_offset < termination_length_on_functions;
        ++index_termination_on_offset
      ) {
        termination_on_functions[
          index_termination_on_offset
        ] = termination_on_functions[
          index_termination_on_offset + 1
        ];

        termination_on_functions_data[
          index_termination_on_offset
        ] = termination_on_functions_data[
          index_termination_on_offset + 1
        ];
      }

      termination_on_functions = realloc(
        termination_on_functions,
        sizeof(termination_on_function) *
        termination_length_on_functions
      );

      termination_on_functions_data = realloc(
        termination_on_functions_data,
        sizeof(void*) *
        termination_length_on_functions
      );

      index_termination_on = (
        index_termination_on - 1
      );
    }
  }
}

void termination_terminate() {
  for (
    unsigned short int index_termination_on = 0;
    index_termination_on < termination_length_on_functions;
    ++index_termination_on
  ) {
    termination_on_functions[index_termination_on](
      termination_on_functions_data[index_termination_on]
    );
  }

  free(termination_on_functions);
}
