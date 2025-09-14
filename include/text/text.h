#ifndef __text_text_h
#define __text_text_h

#include <mesh/mesh.h>

#include <clic3_vector.h>

#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>
#include <MetalKit/MetalKit.h>

extern CTFontRef font_reference_monospace;

struct text_image {
  unsigned char* data;
  struct clic3_vector2_unsigned_int size;
};

void text_initialize();

CGGlyph* text_glyphs_encode(
  char*,
  unsigned int,
  CTFontRef
);

struct text_image* text_render(
  char*,
  CTFontRef
);

id<MTLTexture> text_texture_render(
  id<MTLDevice>,
  struct text_image*
);

id<MTLTexture> text_mesh_with_texture_initialize(
  id<MTLDevice>,
  struct mesh*,
  char*,
  CTFontRef
);

void text_image_destroy(
  struct text_image*
);

void text_destroy();

#endif
