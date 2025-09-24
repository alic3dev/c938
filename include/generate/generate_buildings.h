#ifndef __c938_generate_generate_buildings_h
#define __c938_generate_generate_buildings_h

#include <metil_object.h>
#include <metil_shader_types.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void generate_buildings(
  id<MTLDevice>,
  struct metil_object**,
  unsigned short int,
  id<MTLTexture>*,
  unsigned short int,
  unsigned short int
);

#endif
