#include <scenes/scene_gameplay.h>

#include <c938_pipeline_index.h>
#include <data/c938_data.h>
#include <data/data_length.h>
#include <data/enemy_data.h>
#include <data/parameters_gameplay.h>
#include <data/player_data.h>
#include <data/projectile_data.h>
#include <data/scene_gameplay_data.h>
#include <generate/generate_buildings.h>
#include <mesh/mesh_hud_item.h>
#include <mesh/mesh_player.h>
#include <network/data/network_data_map_functions.h>
#include <network/network_client.h>
#include <network/network_client_status.h>
#include <network/network_command.h>
#include <network/network_host.h>
#include <objects/object_crosshair.h>
#include <objects/object_enemy.h>
#include <player.h>
#include <textures/textures_buildings.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_group.h>
#include <metil_object.h>
#include <metil_paths/metil_paths.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

#include <rand_clean.h>
#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#if !target_os_ios
#include <CoreAudio/CoreAudio.h>
#else
#include <UIKit/UIKit.h>
#endif

#include <pthread.h>

void scene_gameplay_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct c938_data* c938_data = (
    metil->data
  );

  struct parameters_gameplay* parameters_gameplay = (
    &c938_data->parameters_gameplay  
  );

  metil->rendering_properties.brightness = (
    metil->configuration.rendering_properties.brightness
  );
  metil->rendering_properties.brightness_text = (
    metil->configuration.rendering_properties.brightness_text
  );

  metil_scene_initialize_with_renderables(
    metil,
    scene,
    scene_gameplay_length_renderables
  );

  scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct scene_gameplay_data
      )
    )
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    scene->data
  );

  scene_gameplay_data->parameters = (
    parameters_gameplay
  );

  scene_gameplay_data->length_projectiles = 0;

  scene_gameplay_data->action_data_map = (
    scene_gameplay_data_action_data_map_none
  );

  for (
    unsigned char index_projectile = 0;
    index_projectile < scene_gameplay_data_length_projectiles_maximum;
    ++index_projectile
  ) {
    scene_gameplay_data->fired_projectiles[
      index_projectile
    ] = (
      0
    );
  }

  scene->player.poll = player_poll;
  scene->player.poll_input = player_poll_input;
  scene->player.destroy = player_destroy;

  static struct player_data* player_data;

  player_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct player_data
      )
    )
  );

  scene->player.data = player_data;

  scene->poll = scene_gameplay_poll;
  scene->destroy = scene_gameplay_destroy;

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case scene_gameplay_renderables_index_buildings:
      case scene_gameplay_renderables_index_group_players:
      case scene_gameplay_renderables_index_projectiles:
      case scene_gameplay_renderables_index_enemies:
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        break;
      case scene_gameplay_renderables_index_group_logging:
        scene->renderables[
          index_renderable
        ].type = (
          metil_renderable_type_group
        );

        scene->renderables[
          index_renderable
        ].renderable = (
          &c938_data->logging.group
        );

        break;
      default:
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );
        
        break;
    }
  }

  for (
    unsigned char index_renderable = scene_gameplay_renderables_index_range_hud_start;
    index_renderable < scene_gameplay_renderables_index_range_hud_end + 1;
    ++index_renderable
  ) {
    struct metil_object* metil_object_hud = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    mesh_hud_item_initialize(
      &metil_object_hud->mesh
    );

    metil_object_buffers_initialize(
      metil_object_hud,
      metil->renderer_interface.metal_device
    );

    metil_object_hud->positioning = metil_positioning_static;

    metil_object_hud->index_pipeline_render = (
      c938_pipeline_index_hud_item
    );

    struct metil_renderer_data_object* metil_renderer_data_object_hud;

    switch (
      index_renderable
    ) {
      case scene_gameplay_renderables_index_hud_boosted:
        metil_renderer_data_object_hud = (
          metil_object_hud->buffers_vertex[
            metil_object_buffer_default_index_data
          ].buffer.contents
        );

        metil_renderer_data_object_hud->noise = 2000;

        metil_object_hud->position.x = -0.9f;
        metil_object_hud->position.y = -0.9f;
        metil_object_hud->position.z = 0.0f;

        break;
      case scene_gameplay_renderables_index_hud_jumping:
        metil_renderer_data_object_hud = (
          metil_object_hud->buffers_vertex[
            metil_object_buffer_default_index_data
          ].buffer.contents
        );

        metil_renderer_data_object_hud->noise = 1;

        metil_object_hud->position.x = -0.9f;
        metil_object_hud->position.y = -0.8f;
        metil_object_hud->position.z = 0.0f;

        break;
      case scene_gameplay_renderables_index_hud_jumping_secondary:
        metil_renderer_data_object_hud = (
          metil_object_hud->buffers_vertex[
            metil_object_buffer_default_index_data
          ].buffer.contents
        );

        metil_renderer_data_object_hud->noise = 2000;

        metil_object_hud->position.x = -0.9f;
        metil_object_hud->position.y = -0.7f;
        metil_object_hud->position.z = 0.0f;

        break;
      default:
        break;
    }
  }

  scene->length_textures = 1;
  clic3_memory_reallocate_raw(
    &scene->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      scene->length_textures
    )
  );

  MTKTextureLoader* texture_loader = [
    [MTKTextureLoader alloc]
    initWithDevice: metil->renderer_interface.metal_device
  ];

  textures_buildings_load(
    metil,
    texture_loader,
    scene->textures
  );

  [texture_loader release];

  struct metil_group* metil_group_players = (
    scene->renderables[
      scene_gameplay_renderables_index_group_players
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_players,
    1,
    metil_renderable_type_object
  );

  struct metil_object* metil_object_player = (
    metil_group_players->renderables[
      0
    ]->renderable
  );

  metil_object_player->index_pipeline_render = (
    c938_pipeline_index_player
  );

  mesh_player_initialize(
    &metil_object_player->mesh,
    &metil->player_defaults
  );

  metil_object_player->positioning = (
    metil_positioning_player
  );

  metil_object_buffers_initialize(
    metil_object_player,
    metil->renderer_interface.metal_device
  );

  metil_object_texture_add(
    metil_object_player,
    scene->textures[
      scene_gameplay_textures_index_player
    ]
  );

  struct metil_object* metil_object_crosshair = (
    scene->renderables[
      scene_gameplay_renderables_index_crosshair
    ].renderable
  );

  object_crosshair_initialize(
    metil_object_crosshair,
    metil->renderer_interface.metal_device
  );

  scene_gameplay_populate(
    metil,
    scene,
    1
  );

  metil_audio_io_proc_add(
    &metil->audio,
    scene_gameplay_io_proc
  );

  if (
    scene_gameplay_data->parameters->networked !=
    parameters_gameplay_networked_none
  ) {
    struct c938_data* c938_data = (
      metil->data
    );

    if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_host
    ) {
      struct network_host* network_host = (
        &c938_data->network_host
      );

      notification_manager_notification_on_add(
        &network_host->notification_manager,
        scene_gameplay_network_host_notification_on,
        metil
      );
    } else if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_client
    ) {
      struct network_client* network_client = (
        &c938_data->network_client
      );

      notification_manager_notification_on_add(
        &network_client->notification_manager,
        scene_gameplay_network_client_notification_on,
        metil
      );
    }
  }
}

void scene_gameplay_network_client_notification_on(
  char* message,
  unsigned char notification_id,
  void* data
) {
  enum network_client_notification_type network_client_notification_type = (
    notification_id
  );

  struct metil* metil = (
    data
  );

  struct c938_data* c938_data = (
    metil->data
  );

  struct network_client* network_client = &(
    c938_data->network_client
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_gameplay = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  switch (
    notification_id
  ) {
    case network_client_notification_type_data_map_sent: {
      scene_gameplay_data->action_data_map = (
        scene_gameplay_data_action_data_map_parse
      );
      break;
    }
    default:
      break;
  }
}

void scene_gameplay_network_host_notification_on(
  char* message,
  unsigned char notification_id,
  void* data
) {
  enum network_host_notification_type network_host_notification_type = (
    notification_id
  );

  struct metil* metil = (
    data
  );

  struct c938_data* c938_data = (
    metil->data
  );

  struct network_host* network_host = &(
    c938_data->network_host
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_gameplay = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  switch (
    notification_id
  ) {
    case network_host_notification_type_data_map_requested: {
      scene_gameplay_data->action_data_map = (
        scene_gameplay_data_action_data_map_set
      );
      break;
    }
    default:
      break;
  }
}

void scene_gameplay_populate(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned char reset
) {
  struct c938_data* c938_data = (
    metil->data
  );

  struct network_client* network_client = &(
    c938_data->network_client
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    scene->data
  );

  struct player_data* player_data = (
    scene->player.data
  );

  struct metil_group* metil_group_buildings = (
    scene->renderables[
      scene_gameplay_renderables_index_buildings
    ].renderable
  );

  struct metil_group* metil_group_enemies = (
    scene->renderables[
      scene_gameplay_renderables_index_enemies
    ].renderable
  );

  struct metil_group* metil_group_projectiles = (
    scene->renderables[
      scene_gameplay_renderables_index_projectiles
    ].renderable
  );

  metil_group_destroy(
    metil,
    metil_group_projectiles
  );

  metil_group_initialize(
    metil_group_projectiles
  );

  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  scene->player.velocity.x = 0.0f;
  scene->player.velocity.y = 0.0f;
  scene->player.velocity.z = 0.0f;

  player_data_initialize(
    player_data,
    metil->rendering_properties.camera.height_default
  );

  player_data->time = &(
    scene->time
  );

  scene_gameplay_data->length_projectiles = 0;

  for (
    unsigned char index_projectile = 0;
    index_projectile < scene_gameplay_data_length_projectiles_maximum;
    ++index_projectile
  ) {
    scene_gameplay_data->fired_projectiles[
      index_projectile
    ] = (
      0
    );
  }

  player_data->metal_device = (
    metil->renderer_interface.metal_device
  );

  player_data->buildings = (
    metil_group_buildings
  );

  player_data->projectiles = (
    metil_group_projectiles
  );

  player_data->height = (
    metil->rendering_properties.camera.height
  );

  struct metil_group* metil_group_players = (
    scene->renderables[
      scene_gameplay_renderables_index_group_players
    ].renderable
  );

  struct metil_object* metil_object_player = (
    metil_group_players->renderables[
      0
    ]->renderable
  );

  if (
    (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_client
    ) &&
    (
      (
        network_client->status & (
          network_client_status_disconnecting |
          network_client_status_disconnected
        )
      ) == 0 &&
      network_client->status != network_client_status_none
    )
  ) {
    unsigned char networked = (
      scene_gameplay_data->parameters->networked
    );
    
    network_data_map_parse(
      metil,
      &network_client->data_map,
      scene_gameplay_data->parameters,
      metil_group_buildings,
      metil_group_enemies,
      &scene->player.position,
      &player_data->index_target_building,
      scene->textures[
        scene_gameplay_textures_index_buildings
      ]
    );

    scene_gameplay_data->parameters->networked = (
      networked
    );

    scene_gameplay_data->speed_movement = (
      scene_gameplay_data->parameters->speed_movement
    );

    scene->player.speed_movement = (
      scene_gameplay_data->speed_movement
    );

    scene_gameplay_data->length_buildings = (
      scene_gameplay_data->parameters->length_buildings
    );

    scene_gameplay_data->length_enemies = (
      scene_gameplay_data->parameters->length_enemies
    );

    metil_object_player->position.y = (
      scene->player.position.y
    );

    static struct network_data_packet* network_data_packet;

    network_data_packet = (
      clic3_memory_allocate_raw(
        sizeof(
          struct network_data_packet
        )
      )
    );

    network_data_packet_initialize(
      network_data_packet,
      network_command_data_map_loaded,
      0
    );

    network_client_send(
      network_client,
      network_data_packet
    );

    return;
  }

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    10,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  if (
    reset != 0
  ) {
    scene_gameplay_data->speed_movement = (
      scene_gameplay_data->parameters->speed_movement
    );

    scene->player.speed_movement = (
      scene_gameplay_data->speed_movement
    );

    scene_gameplay_data->length_buildings = (
      scene_gameplay_data->parameters->length_buildings
    );

    scene_gameplay_data->length_enemies = (
      scene_gameplay_data->parameters->length_enemies
    );
  } else {
    scene->player.speed_movement = (
      scene_gameplay_data->speed_movement *
      scene_gameplay_data->parameters->multiplier_speed_movement
    );

    if (
      (
        (unsigned long int) scene_gameplay_data->length_buildings *
        (float) scene_gameplay_data->parameters->multiplier_buildings
      ) > 65000
    ) {
      scene_gameplay_data->length_buildings = (
        65000
      );
    } else if (
      (
        (long int) scene_gameplay_data->length_buildings *
        (float) scene_gameplay_data->parameters->multiplier_buildings
      ) < 3
    ) {
      scene_gameplay_data->length_buildings = 3;
    } else {
      scene_gameplay_data->length_buildings = (
        scene_gameplay_data->length_buildings *
        scene_gameplay_data->parameters->multiplier_buildings
      );
    }

    if (
      (
        (unsigned long int) scene_gameplay_data->length_enemies *
        (float) scene_gameplay_data->parameters->multiplier_enemies
      ) > 65000
    ) {
      scene_gameplay_data->length_enemies = (
        65000
      );
    } else if (
      (
        (long int) scene_gameplay_data->length_enemies *
        (float) scene_gameplay_data->parameters->multiplier_enemies
      ) < 0
    ) {
      scene_gameplay_data->length_enemies = 0;
    } else {
      scene_gameplay_data->length_enemies = (
        scene_gameplay_data->length_enemies *
        scene_gameplay_data->parameters->multiplier_enemies
      );
    }
  }

  if (
    scene_gameplay_data->parameters->objective == gameplay_objective_target
  ) {
    player_data->index_target_building = (
      (
        rand_result.bytes[0] *
        rand_result.bytes[1] +
        rand_result.bytes[2]
      ) % (
        scene_gameplay_data->length_buildings -
        2
      ) +
      2
    );
  } else {
    player_data->index_target_building = (
      scene_gameplay_data->length_buildings
    );
  }

  generate_buildings(
    metil,
    metil->renderer_interface.metal_device,
    metil_group_buildings,
    scene_gameplay_data->length_buildings,
    player_data->index_target_building,
    scene->textures[
      scene_gameplay_textures_index_buildings
    ]
  );

  struct metil_object* object = (
    metil_group_buildings->renderables[
      scene_gameplay_group_buildings_index_starting
    ]->renderable
  );

  scene->player.position.x = object->position.x;
  
  scene->player.position.y = (
    object->position.y +
    object->mesh.size.y
  );

  scene->player.position.z = (
    object->position.z
  );

  metil_object_player->position.y = (
    scene->player.position.y
  );

  metil_group_destroy(
    metil,
    metil_group_enemies
  );

  metil_group_initialize(
    metil_group_enemies
  );

  float distance_minimum = 200.0f;

  metil_group_add_length_initialize(
    metil_group_enemies,
    scene_gameplay_data->length_enemies,
    metil_renderable_type_object
  );

  for (
    unsigned int index_enemy = 0;
    index_enemy < metil_group_enemies->length;
    ++index_enemy
  ) {
    rand_get(
      &rand_source,
      &rand_result,
      &rand_parameters
    );

    struct metil_object* metil_object_enemy = (
      metil_group_enemies->renderables[
        index_enemy
      ]->renderable
    );

    struct math_c_vector3_float position_enemy = {
      .x = (
        1250 - (
          rand_result.bytes[0] *
          rand_result.bytes[1]
        ) % 2500
      ),
      .y = 1000 + (
        rand_result.bytes[2] *
        rand_result.bytes[3]
      ) % 500,
      .z = (
        1250 - (
          rand_result.bytes[4] *
          rand_result.bytes[5]
        ) % 2500
      )
    };

    if (
      position_enemy.x <= distance_minimum &&
      position_enemy.x >= -distance_minimum
    ) {
      float offset = (
        rand_result.bytes[7] +
        distance_minimum
      );

      if (
        position_enemy.x < 0.0f
      ) {
        offset = (
          offset *
          -1
        );
      }

      position_enemy.x = (
        position_enemy.x +
        offset
      );
    }

    if (
      position_enemy.z <= distance_minimum &&
      position_enemy.z >= -distance_minimum
    ) {
      float offset = (
        rand_result.bytes[6] +
        distance_minimum
      );

      if (
        position_enemy.z < 0.0f
      ) {
        offset = (
          offset *
          -1
        );
      }

      position_enemy.z = (
        position_enemy.z +
        offset
      );
    }

    float speed_enemy = (
      (float) (
        rand_result.bytes[8] +
        rand_result.bytes[9]
      ) / 255.0f *
      16.0f +
      32.0f
    );

    object_enemy_initialize(
      metil_object_enemy,
      metil->renderer_interface.metal_device,
      position_enemy,
      4,
      speed_enemy
    );
  }

  rand_clean(
    &rand_result,
    &rand_source
  );

  if (
    scene_gameplay_data->parameters->networked ==
    parameters_gameplay_networked_host
  ) {
    struct c938_data* c938_data = (
      metil->data
    );

    struct network_host* network_host = (
      &c938_data->network_host
    );

    network_data_map_set(
      &network_host->data_map,
      scene_gameplay_data->parameters,
      metil_group_buildings,
      metil_group_enemies,
      &scene->player.position,
      player_data->index_target_building
    );

    network_host_data_map_send(
      network_host
    );
  }
}

void scene_gameplay_poll(
  struct metil* metil,
  struct metil_scene* metil_scene_gameplay
) {
  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  struct player_data* player_data = (
    metil_scene_gameplay->player.data
  );

  struct metil_group* metil_group_enemies = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_enemies
    ].renderable
  );

  struct metil_group* metil_group_players = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_group_players
    ].renderable
  );

  struct metil_group* metil_group_projectiles = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_projectiles
    ].renderable
  );

  c938_logging_poll(
    metil
  );

  if (
    scene_gameplay_data->parameters->networked !=
    parameters_gameplay_networked_none
  ) {
    struct c938_data* c938_data = (
      metil->data
    );

    struct network_client* network_client = &(
      c938_data->network_client
    );

    struct network_host* network_host = &(
      c938_data->network_host
    );

    struct metil_group* metil_group_buildings = (
      metil_scene_gameplay->renderables[
        scene_gameplay_renderables_index_buildings
      ].renderable
    );

    switch (
      scene_gameplay_data->action_data_map
    ) {
      case scene_gameplay_data_action_data_map_parse: {
        scene_gameplay_populate(
          metil,
          metil_scene_gameplay,
          1
        );

        break;
      }
      case scene_gameplay_data_action_data_map_set: {
        network_data_map_set(
          &network_host->data_map,
          scene_gameplay_data->parameters,
          metil_group_buildings,
          metil_group_enemies,
          &metil_scene_gameplay->player.position,
          player_data->index_target_building
        );

        network_host_data_map_send(
          network_host
        );
        break;
      }
      default: {
        break;
      }
    }

    if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_client
    ) {
      pthread_mutex_lock(
        &network_client->mutex_poll
      );

      if (
        network_client->network_data_packet_poll != 0
      ) {
        unsigned int index_client;
        unsigned int length_players;

        network_data_packet_read(
          network_client->network_data_packet_poll,
          &index_client,
          data_length_unsigned_int
        );

        network_data_packet_read(
          network_client->network_data_packet_poll,
          &length_players,
          data_length_unsigned_int
        );

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
            
            metil_object_player->index_pipeline_render = (
              c938_pipeline_index_player
            );

            mesh_player_initialize(
              &metil_object_player->mesh,
              &metil->player_defaults
            );

            metil_object_buffers_initialize(
              metil_object_player,
              metil->renderer_interface.metal_device
            );

            metil_object_texture_add(
              metil_object_player,
              metil_scene_gameplay->textures[
                scene_gameplay_textures_index_player
              ]
            );
          }
        }
        
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

        unsigned char offset_player = 0;

        for (
          unsigned int index_player = 0;
          index_player < length_players;
          ++index_player
        ) {
          if (
            index_client == index_player
          ) {
            offset_player = 1;

            network_client->network_data_packet_poll->offset = (
              network_client->network_data_packet_poll->offset +
              data_length_math_c_vector3_float
            );

            continue;
          }

          struct metil_object* metil_object_player = (
            metil_group_players->renderables[
              index_player +
              1 -
              offset_player
            ]->renderable
          );

          network_data_packet_read(
            network_client->network_data_packet_poll,
            &metil_object_player->position,
            data_length_math_c_vector3_float
          );
        }
      }

      pthread_mutex_unlock(
        &network_client->mutex_poll
      );
    }

    scene_gameplay_data->action_data_map = (
      scene_gameplay_data_action_data_map_none
    );
  }
  
  if (
    player_data->on_ground == (
      player_data->index_target_building +
      1
    )
  ) {
    scene_gameplay_populate(
      metil,
      metil_scene_gameplay,
      0
    );

    return;
  } else if (
    metil_scene_gameplay->player.position.y <= 10.0f
  ) {
    scene_gameplay_populate(
      metil,
      metil_scene_gameplay,
      1
    );

    return;
  }

  float time_delta_percent = (
    (float) metil_scene_gameplay->time_delta /
    1000.0f
  );

  for (
    unsigned int index_projectile = 0;
    index_projectile < metil_group_projectiles->length;
  ) {
    struct metil_object* metil_object_projectile = (
      metil_group_projectiles->renderables[
        index_projectile
      ]->renderable
    );

    unsigned int collision = (
      0
    );

    for (
      unsigned int index_enemy = 0;
      index_enemy < metil_group_enemies->length;
      ++index_enemy
    ) {
      struct metil_object* metil_object_enemy = (
        metil_group_enemies->renderables[
          index_enemy
        ]->renderable
      );

      if (
        metil_object_projectile->position.x >= metil_object_enemy->position.x - (metil_object_enemy->mesh.size.x / 2.0f) &&
        metil_object_projectile->position.x <= metil_object_enemy->position.x + (metil_object_enemy->mesh.size.x / 2.0f) &&

        metil_object_projectile->position.y >= metil_object_enemy->position.y - (metil_object_enemy->mesh.size.y / 2.0f) &&
        metil_object_projectile->position.y <= metil_object_enemy->position.y + (metil_object_enemy->mesh.size.y / 2.0f) &&

        metil_object_projectile->position.z >= metil_object_enemy->position.z - (metil_object_enemy->mesh.size.z / 2.0f) &&
        metil_object_projectile->position.z <= metil_object_enemy->position.z + (metil_object_enemy->mesh.size.z / 2.0f)
      ) {
        collision = 1;

        struct enemy_data* enemy_data = (
          metil_object_enemy->buffers_vertex[
            metil_object_buffer_default_index_data
          ].buffer.contents
        );

        enemy_data->life = (
          enemy_data->life -
          1
        );

        if (
          enemy_data->life <= 0
        ) {
          metil_group_destroy_renderable_at_index(
            metil,
            metil_group_enemies,
            index_enemy
          );
        }

        break;
      }
    }

    struct projectile_data* projectile_data = (
      metil_object_projectile->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    projectile_data->time_current = (
      metil_scene_gameplay->time
    );

    projectile_data->time_delta_percent = (
      time_delta_percent
    );

    if (
      collision == 1 ||
      projectile_data->time_current -
      projectile_data->time_fired >
      projectile_data->lifespan
    ) {
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_projectiles,
        index_projectile
      );
    } else {
      index_projectile = (
        index_projectile +
        1
      );
    }
  }

  for (
    unsigned int index_enemy = 0;
    index_enemy < metil_group_enemies->length;
  ) {
    struct metil_object* metil_object_enemy = (
      metil_group_enemies->renderables[
        index_enemy
      ]->renderable
    );

    if (
      metil_scene_gameplay->player.position.x >= metil_object_enemy->position.x - (metil_object_enemy->mesh.size.x / 2.0f) &&
      metil_scene_gameplay->player.position.x <= metil_object_enemy->position.x + (metil_object_enemy->mesh.size.x / 2.0f) &&

      (metil_scene_gameplay->player.position.y + player_data->height) >= metil_object_enemy->position.y - (metil_object_enemy->mesh.size.y / 2.0f) &&
      (metil_scene_gameplay->player.position.y + player_data->height) <= metil_object_enemy->position.y + (metil_object_enemy->mesh.size.y / 2.0f) &&

      metil_scene_gameplay->player.position.z >= metil_object_enemy->position.z - (metil_object_enemy->mesh.size.z / 2.0f) &&
      metil_scene_gameplay->player.position.z <= metil_object_enemy->position.z + (metil_object_enemy->mesh.size.z / 2.0f)
    ) {
      player_data->life = (
        player_data->life -
        1
      );
      
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_enemies,
        index_enemy
      );

      if (
        player_data->life <= 0
      ) {
        scene_gameplay_populate(
          metil,
          metil_scene_gameplay,
          1
        );

        return;
      }

      continue;
    } else {
      index_enemy = (
        index_enemy +
        1
      );
    }
  }

  if (
    scene_gameplay_data->parameters->objective == gameplay_objective_enemies &&
    metil_group_enemies->length == 0
  ) {
    scene_gameplay_populate(
      metil,
      metil_scene_gameplay,
      1
    );

    return;
  }

  metil_scene_poll_default(
    metil,
    metil_scene_gameplay
  );

  struct metil_object* metil_object_player = (
    metil_group_players->renderables[
      0
    ]->renderable
  );

  metil_object_player->position.x = (
    metil_scene_gameplay->player.position.x
  );

  metil_object_player->position.y = (
    metil_scene_gameplay->player.position.y -
    metil->rendering_properties.camera.height +
    metil_object_player->mesh.size.y / 
    1.1
  );

  metil_object_player->position.z = (
    metil_scene_gameplay->player.position.z
  );

  if (
    scene_gameplay_data->parameters->networked !=
    parameters_gameplay_networked_none
  ) {
    struct c938_data* c938_data = (
      metil->data
    );

    if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_client
    ) {
      struct network_client* network_client = &(
        c938_data->network_client
      );

      static struct network_data_packet* network_data_packet;
      
      network_data_packet =(
        clic3_memory_allocate_raw(
          sizeof(
            struct network_data_packet
          )
        )
      );

      network_data_packet_initialize(
        network_data_packet,
        network_command_poll,
        sizeof(
          struct math_c_vector3_float
        )
      );

      network_data_packet_bytes_add(
        network_data_packet,
        &metil_scene_gameplay->player.position,
        sizeof(
          struct math_c_vector3_float
        )
      );

      network_client_send(
        &c938_data->network_client,
        network_data_packet
      );
    } else if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_host
    ) {
      struct network_host* network_host = &(
        c938_data->network_host
      );

      pthread_mutex_lock(
        &network_host->mutex_position
      );

      clic3_bytes_copy(
        &network_host->position,
        &metil_scene_gameplay->player.position,
        sizeof(
          struct math_c_vector3_float
        )
      );

      pthread_mutex_unlock(
        &network_host->mutex_position
      );

      network_host_send_poll(
        &c938_data->network_host
      );
    }
  }

  struct metil_object* metil_object_hud_boosted = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_hud_boosted
    ].renderable
  );

  struct metil_renderer_data_object* metil_renderer_data_object_hud_boosted = (
    metil_object_hud_boosted->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_object* metil_object_hud_jumping = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_hud_jumping
    ].renderable
  );

  struct metil_renderer_data_object* metil_renderer_data_object_hud_jumping = (
    metil_object_hud_jumping->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_object* metil_object_hud_jumping_secondary = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_hud_jumping_secondary
    ].renderable
  );

  struct metil_renderer_data_object* metil_renderer_data_object_hud_jumping_secondary = (
    metil_object_hud_jumping_secondary->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  if (
    player_data->is_boosted == 1
  ) {
    unsigned long int delta_time_boost = (
      metil_scene_gameplay->time_input -
      player_data->time_boost
    );

    metil_renderer_data_object_hud_boosted->noise = (
      delta_time_boost > 2000
      ? 2000
      : delta_time_boost
    );
  } else {
    metil_renderer_data_object_hud_boosted->noise = (
      2000
    );
  }

  metil_renderer_data_object_hud_jumping->noise = (
    player_data->is_jumping != 0
    ? 0
    : 2000
  );

  metil_renderer_data_object_hud_jumping_secondary->noise = (
    player_data->is_jumping_secondary != 0
    ? 0
    : 2000
  );
}

void scene_gameplay_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene_gameplay
) {
  metil_audio_io_proc_remove(
    &metil->audio,
    scene_gameplay_io_proc
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  clic3_memory_free_raw(
    metil_scene_gameplay->data
  );

  metil_scene_gameplay->data = 0;

  metil_scene_gameplay->length_renderables = (
    metil_scene_gameplay->length_renderables -
    1
  );

  metil_scene_destroy_default(
    metil,
    metil_scene_gameplay
  );
}

// todo: put these in gameplay data or something
unsigned int b = 100;
unsigned int d = 1000;

float scene_gameplay_io_proc_value_get(
  struct scene_gameplay_data* scene_gameplay_data,
  unsigned long int time_current,
  unsigned long int channel,
  unsigned long int frame
) {
  float value = 0.0f;

  for (
    unsigned int index_projectile = 0;
    index_projectile < scene_gameplay_data->length_projectiles;
  ) {
    unsigned long int time_fired = (
      scene_gameplay_data->fired_projectiles[
        index_projectile
      ]
    );

    unsigned long int v = (
      time_current -
      time_fired
    );

    float a = 0.0f;
    
    if (
      v <= b
    ) {
      a = (float) (
        b - v
      ) / (((float) b) / 2.0f) - 1.0f;
    } else {
      if (v > d) {
        for (
          unsigned int index_projectile_shift = index_projectile;
          index_projectile_shift < scene_gameplay_data->length_projectiles - 1;
          ++index_projectile_shift
        ) {
          scene_gameplay_data->fired_projectiles[
            index_projectile_shift
          ] = (
            scene_gameplay_data->fired_projectiles[
              index_projectile_shift +
              1
            ]
          );
        }

        scene_gameplay_data->length_projectiles = (
          scene_gameplay_data->length_projectiles -
          1
        );

        continue;
      }

      a = ((float) (
        d - v
      ) / (((float) d) / 2.0f) - 1.0f) * 0.5f;
    }

    if (
      v % 2 == 0
    ) {
      a = -a;
    }

    value = (
      value +
      a
    );

    index_projectile = (
      index_projectile +
      1
    );
  }

  if (value > 1.0f) {
    value = (
      value - (
        (float) (
          (unsigned long int) value
        )
      )
    );
  } else if (value < -1.0f) {
    value = (
      value + (
        (float) (
          (unsigned long int) (-value)
        )
      )
    );
  }

  value = (
    value
  );

  return value;
}


#if target_os_ios
int scene_gameplay_io_proc(
  unsigned char silence,
  const AudioTimeStamp* _Nonnull timestamp,
  AVAudioFrameCount frame_count,
  AudioBufferList* _Nonnull output_data,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_gameplay = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  for (
    unsigned int index_frame = 0;
    index_frame < frame_count;
    ++index_frame
  ) {
    for (
      unsigned long int index_buffer = 0;
      index_buffer < output_data->mNumberBuffers;
      ++index_buffer
    ) {
      AudioBuffer audio_buffer_current = output_data->mBuffers[
        index_buffer
      ];

      float* buffer_out = audio_buffer_current.mData;

      buffer_out[
        index_frame
      ] = scene_gameplay_io_proc_value_get(
        scene_gameplay_data,
        metil_scene_gameplay->time,
        index_buffer,
        index_frame
      );
    }
  }
  
  return 0;
}
#else
OSStatus scene_gameplay_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene_gameplay = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  for (
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      list_buffer_audio_out->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = audio_buffer_current.mData;

    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      data_length_float
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );
    
    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = (
        index_buffer_out %
        count_channel_out
      );

      buffer_out[
        index_buffer_out
      ] = (
        scene_gameplay_io_proc_value_get(
          scene_gameplay_data,
          metil_scene_gameplay->time,
          channel,
          index_buffer_out
        )
      );
    }
  }

  return 0;
}
#endif
