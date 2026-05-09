#include <textures/textures_buildings.h>

#include <metil_texture/metil_texture_brightness.h>
#include <metil_texture/metil_texture_concrete.h>

#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

void textures_buildings_load(
  struct metil* metil,
  MTKTextureLoader* texture_loader,
  id<MTLTexture>* textures
) {
  NSError* error = (
    0x00
  );

  textures[
    0x00
  ] = [texture_loader
    newTextureWithContentsOfURL: [
      NSURL
      fileURLWithPath: @"preliminary_concrete.png"
      isDirectory: (
        0x00
      )
      relativeToURL: [
        NSURL
        fileURLWithPath:[
          NSString
          stringWithUTF8String: (
            metil->paths.directory_textures
          )
        ]
        isDirectory: (
          0x01
        )
      ]
    ]
    options: (
      0x00
    )
    error: &(
      error
    )
  ];

  if (
    error !=
    0x00
  ) {
    textures[
      0x00
    ] = metil_texture_concrete_secondary_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = (
          0xc8
        ),
        .y = (
          0xc8
        )
      },
      (
        (unsigned char*)
        textures_building_seed
      ),
      textures_building_length_seed,
      metil->renderer_interface.metal_device
    );

    metil_texture_brightness_linear(
      textures[
        0x00
      ],
      0.05f
    );
  }
}
