#ifndef __configuration_configuration_h
#define __configuration_configuration_h

#include <configuration/configuration_audio.h>
#include <configuration/configuration_rendering_properties.h>

struct configuration {
  struct configuration_audio audio;
  struct configuration_rendering_properties rendering_properties;
};

extern struct configuration configuration;

void configuration_initialize();

unsigned char configuration_load();

void configuration_values_set();

float configuration_value_float_parse(
  char*,
  char*,
  unsigned short int
);

void configuration_destroy();

#endif
