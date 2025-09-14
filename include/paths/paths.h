#ifndef __paths_h
#define __paths_h

struct paths {
  char* directory_root;
  char* directory_home;

  char* directory_configuration;
  char* directory_resources;
  char* directory_textures;

  char* file_configuration;

  unsigned int length_directory_root;
  unsigned int length_directory_home;

  unsigned int length_directory_configuration;
  unsigned int length_directory_resources;
  unsigned int length_directory_textures;

  unsigned int length_file_configuration;
};

extern struct paths paths;

void paths_initialize(
  char*
);

void paths_directory_root_set(
  char*
);

void paths_directory_home_set();

void paths_configuration_set();
void paths_directory_resources_set();
void paths_directory_textures_set();

void paths_destroy();

#endif
