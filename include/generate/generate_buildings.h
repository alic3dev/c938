#ifndef __c938_generate_generate_buildings_h
#define __c938_generate_generate_buildings_h

#include <metil.h>
#include <metil_group.h>
#include <metil_rendering/metil_renderable.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void generate_buildings(
  struct metil* _Nonnull,
  _Nonnull id<MTLDevice>,
  struct metil_group* _Nonnull,
  unsigned short int,
  _Nonnull id<MTLTexture>
);

#endif
