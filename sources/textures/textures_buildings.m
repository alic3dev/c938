#include <textures/textures_buildings.h>

#include <metil_paths/paths.h>

#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

void textures_buildings_load(
  MTKTextureLoader* texture_loader,
  id<MTLTexture>* textures
) {
  textures[
    0
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"preliminary_concrete.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil_paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];
}
