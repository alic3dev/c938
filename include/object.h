#ifndef __object_h
#define __object_h

#include <mesh/mesh.h>

#include <clic3_vector.h>

#include <MetalKit/MetalKit.h>

struct object {
  struct mesh mesh;
  _Nonnull id<MTLBuffer> data;
  _Nonnull id<MTLBuffer> indices;
  _Nonnull id<MTLBuffer> vertices;
  _Nonnull id<MTLTexture> texture;
  _Nullable id<MTLTexture> texture_secondary;
  struct clic3_vector3_float position;
};

void object_destroy(
  struct object* _Nonnull
);

#endif
