#ifndef __c938_textures_textures_buildings_h
#define __c938_textures_textures_buildings_h

#include <metil_paths/metil_paths.h>

#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

void textures_buildings_load(
  MTKTextureLoader* _Nonnull,
  _Nonnull id<MTLTexture>* _Nonnull,
  struct metil_paths* _Nonnull metil_paths
);

#endif
