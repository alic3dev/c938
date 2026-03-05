#include <scenes/scene_gameplay/scene_gameplay_group_players.h>

#include <objects/object_player.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>

#include <Metal/MTLTexture.h>

void scene_gameplay_group_players_resize(
  struct metil* metil,
  struct metil_group* metil_group_players,
  unsigned int length_players,
  id<MTLTexture> metal_texture_player
) {
  if (
    metil_group_players->length < length_players
  ) {
    unsigned int players_original = (
      metil_group_players->length
    );

    unsigned int players_new = (
      length_players -
      players_original
    );

    metil_group_add_length_initialize(
      metil_group_players,
      players_new,
      metil_renderable_type_object
    );

    for (
      unsigned int index_player_new = players_original;
      index_player_new < metil_group_players->length;
      ++index_player_new
    ) {
      struct metil_object* metil_object_player = (
        metil_group_players->renderables[
          index_player_new
        ]->renderable
      );

      object_player_initialize(
        metil,
        metil_object_player,
        metal_texture_player,
        0
      );
    }
  } else {
    while (
      metil_group_players->length > length_players
    ) {
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_players,
        (
          metil_group_players->length -
          1
        )
      );
    }
  }
}
