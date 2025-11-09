#ifndef __c938_generate_generate_buildings_h
#define __c938_generate_generate_buildings_h

#include <metil_rendering/metil_renderable.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void generate_buildings(
  id<MTLDevice>,
  struct metil_renderable*,
  unsigned short int,
  id<MTLTexture>,
  unsigned short int
);

#endif
