#include <objects/object_player.h>

#include <rendering/c938_pipeline_index.h>
#include <mesh/mesh_player.h>

#include <metil.h>
#include <metil_object/metil_object.h>

#include <Metal/MTLTexture.h>

void object_player_initialize(
  struct metil* metil,
  struct metil_object* metil_object_player,
  id<MTLTexture> metal_texture_player,
  unsigned char user_player
) {
  metil_object_player->index_pipeline_render = (
    c938_pipeline_index_player
  );

  mesh_player_initialize(
    &metil_object_player->mesh,
    &metil->player_defaults
  );

  if (
    user_player == 1
  ) {
    metil_object_player->positioning = (
      metil_positioning_player
    );
  }

  metil_object_buffers_initialize(
    metil_object_player,
    metil->renderer_interface.metal_device
  );

  metil_object_texture_add(
    metil_object_player,
    metal_texture_player
  );
}
