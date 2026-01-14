#include <textures/textures_buildings.h>

#include <metil_texture/metil_texture_concrete.h>

#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

void textures_buildings_load(
  struct metil* metil,
  MTKTextureLoader* texture_loader,
  id<MTLTexture>* textures
) {
  NSError* error = (
    (void*) 0
  );

  textures[
    0
  ] = [texture_loader
    newTextureWithContentsOfURL: [
      NSURL
      fileURLWithPath: @"preliminary_concrete.png"
      isDirectory: 0
      relativeToURL: [
        NSURL
        fileURLWithPath:[
          NSString
          stringWithUTF8String: (
            metil->paths.directory_textures
          )
        ]
        isDirectory: 1
      ]
    ]
    options: (void*) 0
    error: &error
  ];

  if (
    error != (void*) 0
  ) {
    textures[
      0
    ] = metil_texture_concrete_secondary_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = 0xc8,
        .y = 0xc8
      },
      (unsigned char*) textures_building_seed,
      textures_building_length_seed,
      metil->renderer_interface.metal_device
    );

    MTLRegion region = {
      {0x00, 0x00, 0x00},
      {0xc8, 0xc8, 0x01}
    };

    unsigned char* pixel_bytes = (
      (void*) 0
    );

    pixel_bytes = (
      malloc(
        sizeof(
          unsigned char
        ) *
        0x27100
      )
    );

    [
      textures[
        0
      ]
      getBytes: pixel_bytes
      bytesPerRow: 0x320
      fromRegion: region
      mipmapLevel: 0x00
    ];

    for (
      unsigned int index_pixel = 0x00;
      index_pixel < 0x27100;
      ++index_pixel
    ) {
      if (
        (
          index_pixel +
          1
        ) %
        4 ==
        0
      ) {
        continue;
      }

      if (
        pixel_bytes[
          index_pixel
        ] > 0x80
      ) {
        pixel_bytes[
          index_pixel
        ] = (
          pixel_bytes[
            index_pixel
          ] /
          0b0100
        );
      }
    }

    [
      textures[
        0
      ]
      replaceRegion: region
      mipmapLevel: 0x00
      withBytes: pixel_bytes
      bytesPerRow: 0x320
    ];

    free(
      pixel_bytes
    );
  }
}
