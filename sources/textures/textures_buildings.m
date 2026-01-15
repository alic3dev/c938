#include <textures/textures_buildings.h>

#include <metil_texture/metil_texture_brightness.h>
#include <metil_image/metil_image_type.h>
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

    metil_texture_brightness(
      textures[
        0
      ],
      0.05f
    );
  }
}
