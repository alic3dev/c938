#include <paths/paths.h>
#include <paths/paths_constants.h>

#include <clic3_char_arrays.h>
#include <clic3_bytes.h>

#include <stdlib.h>

struct paths paths;

void paths_initialize(
  char* directory_root
) {
  paths.length_directory_root = 0;
  paths.length_directory_home = 0;

  paths.length_directory_configuration = 0;
  paths.length_directory_resources = 0;
  paths.length_directory_textures = 0;

  paths.length_file_configuration = 0;

  paths_directory_root_set(
    directory_root
  );

  paths_directory_home_set();

  paths_configuration_set();
  paths_directory_resources_set();
  paths_directory_textures_set();
}

void paths_directory_root_set(
  char* directory_root
) {
  unsigned int index_slash = 0;

  while (
    directory_root[
      paths.length_directory_root
    ] != '\0'
  ) {
    if (
      directory_root[
        paths.length_directory_root
      ] == '/'
    ) {
      index_slash = paths.length_directory_root;
    }

    paths.length_directory_root = (
      paths.length_directory_root + 1
    );
  }

  if (index_slash < 2) {
    paths.length_directory_root = 3;

    paths.directory_root = malloc(
      sizeof(char) *
      paths.length_directory_root
    );

    paths.directory_root[0] = '.';
    paths.directory_root[1] = '/';
    paths.directory_root[2] = '\0';
  } else {
    paths.length_directory_root = index_slash + 2;

    paths.directory_root = malloc(
      sizeof(char) * paths.length_directory_root
    );

    clic3_bytes_copy(
      paths.directory_root,
      directory_root,
      paths.length_directory_root - 1
    );

    paths.directory_root[
      paths.length_directory_root - 1
    ] = '\0';
  }
}

void paths_directory_home_set() {
  paths.directory_home = clic3_char_arrays_concatenate(
    getenv("HOME"),
    "/"
  );

  paths.length_directory_home = clic3_char_array_length(
    paths.directory_home
  );
}

void paths_configuration_set() {
  paths.length_directory_configuration = (
    paths.length_directory_home +
    paths_length_directory_configuration
  );
  
  paths.directory_configuration = clic3_char_arrays_concatenate(
    paths.directory_home,
    paths_directory_configuration
  );

  paths.file_configuration = clic3_char_arrays_concatenate(
    paths.directory_configuration,
    paths_file_configuration
  );
}

void paths_directory_resources_set() {
  paths.length_directory_resources = (
    paths.length_directory_root +
    paths_length_directory_resources
  );

  paths.directory_resources = clic3_char_arrays_concatenate(
    paths.directory_root,
    paths_directory_resources
  );
}

void paths_directory_textures_set() {
  paths.length_directory_textures = (
    paths.length_directory_resources +
    paths_length_directory_resources_textures
  );

  paths.directory_textures = clic3_char_arrays_concatenate(
    paths.directory_resources,
    paths_directory_resources_textures
  );
}

void paths_destroy() {
  free(paths.directory_root);
  free(paths.directory_home);

  free(paths.directory_configuration);
  free(paths.directory_resources);
  free(paths.directory_textures);

  free(paths.file_configuration);
}
