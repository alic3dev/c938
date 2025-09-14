#include <text/text.h>

#include <debug/log.h>
#include <mesh/mesh_text.h>

#include <clic3_char_arrays.h>

#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>
#include <MetalKit/MetalKit.h>

CTFontRef font_reference_monospace = (void*)0;
CGColorSpaceRef font_color_space = (void*)0;

void text_initialize() {
  CFStringRef name_family_font_monospace = CFSTR(
    "monospace"
  );

  font_reference_monospace = CTFontCreateWithName(
    name_family_font_monospace,
    48.0,
    (void*)0
  );

  CFRelease(
    name_family_font_monospace
  );

  font_color_space = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);

  if (
    font_color_space == (void*)0
  ) {
    debug_log_error(
      "couldn't create color space\n"
    );
  }
}

CGGlyph* text_glyphs_encode(
  char* characters,
  unsigned int length_characters,
  CTFontRef font
) {
  static CGGlyph* glyphs;

  glyphs = malloc(
    sizeof(CGGlyph) *
    length_characters
  );

  UInt16 characters_unicode[length_characters];

  for (
    unsigned int index_character = 0;
    index_character < length_characters;
    ++index_character
  ) {
    characters_unicode[
      index_character
    ] = characters[
      index_character
    ];
  }

  unsigned char status_glyphs = CTFontGetGlyphsForCharacters(
    font,
    characters_unicode,
    glyphs,
    length_characters
  );

  if (!status_glyphs) {
    char* message_debug_log_error = clic3_char_arrays_concatenate(
      "couldn't encode glyphs: ",
      characters
    );

    char* message_debug_log_error_with_newline = clic3_char_arrays_concatenate(
      message_debug_log_error,
      "\n"
    );

    debug_log_error(
      message_debug_log_error_with_newline
    );

    free(message_debug_log_error);
    free(message_debug_log_error_with_newline);

    free(glyphs);

    return (void*)0;
  }

  return glyphs;
}

struct text_image* text_render(
  char* characters,
  CTFontRef font
) {
  unsigned int length_characters = clic3_char_array_length(
    characters
  );

  CGGlyph* glyphs = text_glyphs_encode(
    characters,
    length_characters,
    font
  );

  if (
    glyphs == (void*)0
  ) {
    return (void*)0;
  }

  CGRect bounding_box_glyphs[length_characters];

  CTFontGetBoundingRectsForGlyphs(
    font_reference_monospace,
    kCTFontOrientationDefault,
    glyphs,
    bounding_box_glyphs,
    length_characters
  );

  CGPoint positions_glyphs[length_characters];

  static struct text_image* text_image;
  text_image = malloc(
    sizeof(struct text_image)
  );

  text_image->size.x = 5;
  text_image->size.y = 0;

  for (
    unsigned char index_glyph = 0;
    index_glyph < length_characters;
    ++index_glyph
  ) {
    positions_glyphs[index_glyph].x = text_image->size.x;
    positions_glyphs[index_glyph].y = 15;

    text_image->size.x = (
      text_image->size.x +
      bounding_box_glyphs[
        index_glyph
      ].size.width
    );

    text_image->size.y = fmax(
      text_image->size.y,
      bounding_box_glyphs[
        index_glyph
      ].size.height
    );
  }

  text_image->size.x = text_image->size.x + 5;
  text_image->size.y = text_image->size.y + 15;

  unsigned int length_text_image_data = (
    4 * (text_image->size.x) * (text_image->size.y)
  );

  text_image->data = malloc(
    sizeof(unsigned char) *
    length_text_image_data
  );

  for (
    unsigned int index_pixel = 0;
    index_pixel < length_text_image_data;
    index_pixel = index_pixel + 4
  ) {
    unsigned char value = 0;

    text_image->data[index_pixel] = value;
    text_image->data[index_pixel + 1] = value;
    text_image->data[index_pixel + 2] = value;
    text_image->data[index_pixel + 3] = value;
  }

  CGContextRef context_bitmap = CGBitmapContextCreate(
    text_image->data,
    text_image->size.x,
    text_image->size.y,
    8,
    4 * (text_image->size.x),
    font_color_space,
    kCGImageAlphaNoneSkipFirst
  );

  if (
    context_bitmap == (void*)0
  ) {
    debug_log_error(
      "failed_to_create->{CGBitmapContext}\n"
    );

    return (void*)0;
  }

  CTFontDrawGlyphs(
    font,
    glyphs,
    positions_glyphs,
    length_characters,
    context_bitmap
  );

  CGContextRelease(
    context_bitmap
  );

  free(glyphs);

  for (
    unsigned int index_pixel = 0;
    index_pixel < length_text_image_data;
    index_pixel = index_pixel + 4
  ) {
    unsigned char value = text_image->data[index_pixel];

    text_image->data[index_pixel + 1] = value;
    text_image->data[index_pixel + 2] = value;
    text_image->data[index_pixel + 3] = value;
  }

  return text_image;
}


id<MTLTexture> text_texture_render(
  id<MTLDevice> metal_kit_device,
  struct text_image* text_image
) {
  MTLTextureDescriptor* texture_descriptor = [[MTLTextureDescriptor alloc] init];

  texture_descriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;

  texture_descriptor.width = text_image->size.x;
  texture_descriptor.height = text_image->size.y;

  id<MTLTexture> texture = [metal_kit_device
    newTextureWithDescriptor: texture_descriptor
  ];

  [texture_descriptor release];

  MTLRegion region = {
    {0, 0, 0},
    {text_image->size.x, text_image->size.y, 1}
  };

  [texture
    replaceRegion: region
    mipmapLevel: 0
    withBytes: text_image->data
    bytesPerRow: 4 * (text_image->size.x)
  ];

  return texture;
}

id<MTLTexture> text_mesh_with_texture_initialize(
  id<MTLDevice> metal_kit_device,
  struct mesh* mesh,
  char* characters,
  CTFontRef font
) {
  struct text_image* text_image = text_render(
    characters,
    font
  );
  
  if (
    text_image == (void*)0
  ) {
    debug_log_error(
      "failed_to_render_text_image\n"
    );

    return (void*)0;
  }

  mesh_text_initialize(
    mesh,
    text_image->size.x,
    text_image->size.y,
    0.001f
  );

  id<MTLTexture> texture = text_texture_render(
    metal_kit_device,
    text_image
  );

  text_image_destroy(text_image);

  return texture;
}

void text_image_destroy(
  struct text_image* text_image
) {
  free(text_image->data);
  free(text_image);
}

void text_destroy() {
  CGColorSpaceRelease(
    font_color_space
  );

  CFRelease(
    font_reference_monospace
  );
}
