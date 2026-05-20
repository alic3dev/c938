#include <scenes/scene_gameplay/scene_gameplay.h>

#include <audio/io_procs/io_proc_scene_gameplay.h>
#include <rendering/c938_pipeline_index.h>
#include <data/c938_data.h>
#include <data/data_length.h>
#include <data/enemy_data.h>
#include <data/parameters_gameplay.h>
#include <data/player_data.h>
#include <data/projectile_data.h>
#include <data/scene_gameplay_data.h>
#include <enumerations/c938_handedness.h>
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
#include <objects/object_gun.h>
#include <objects/object_player.h>
#include <objects/object_projectile.h>
#include <player/player.h>
#include <scenes/scene_gameplay/scene_gameplay_group_enemies.h>
#include <scenes/scene_gameplay/scene_gameplay_group_players.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <math_c_minimum.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
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
  struct metil_scene* metil_scene_gameplay
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
    metil_scene_gameplay,
    scene_gameplay_length_renderables
  );

  metil_scene_gameplay->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct scene_gameplay_data
      )
    )
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  scene_gameplay_data->parameters = (
    parameters_gameplay
  );

  scene_gameplay_data->length_projectiles = (
    0x00
  );

  scene_gameplay_data->action_data_map = (
    scene_gameplay_data_action_data_map_none
  );

  for (
    unsigned char index_projectile = (
      0x00
    );
    (
      index_projectile <
      scene_gameplay_data_length_projectiles_maximum
    );
    ++index_projectile
  ) {
    scene_gameplay_data->fired_projectiles[
      index_projectile
    ] = (
      0x00
    );
  }

  metil_scene_gameplay->player.poll = (
    player_poll
  );

  metil_scene_gameplay->player.poll_input = (
    player_poll_input
  );

  metil_scene_gameplay->player.destroy = (
    player_destroy
  );

  static struct player_data* player_data;

  player_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct player_data
      )
    )
  );

  metil_scene_gameplay->player.data = (
    player_data
  );

  metil_scene_gameplay->poll = (
    scene_gameplay_poll
  );

  metil_scene_gameplay->destroy = (
    scene_gameplay_destroy
  );

  for (
    unsigned char index_renderable = (
      0x00
    );
    (
      index_renderable <
      metil_scene_gameplay->length_renderables
    );
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case scene_gameplay_renderables_index_buildings:
      case scene_gameplay_renderables_index_group_players:
      case scene_gameplay_renderables_index_group_guns:
      case scene_gameplay_renderables_index_projectiles:
      case scene_gameplay_renderables_index_enemies:
      case scene_gameplay_renderables_index_group_hud_health: {
        metil_renderable_initialize_at_index(
          metil_scene_gameplay->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        break;
      }
      case scene_gameplay_renderables_index_group_logging: {
        break;
      }
      default: {
        metil_renderable_initialize_at_index(
          metil_scene_gameplay->renderables,
          index_renderable,
          metil_renderable_type_object
        );

        break;
      }
    }
  }

  metil_scene_gameplay->renderables[
    scene_gameplay_renderables_index_group_logging
  ].type = (
    metil_renderable_type_group
  );

  metil_scene_gameplay->renderables[
    scene_gameplay_renderables_index_group_logging
  ].renderable = &(
    c938_data->logging.group
  );

  for (
    unsigned char index_renderable = (
      scene_gameplay_renderables_index_range_hud_start
    );
    (
      index_renderable <
      (
        scene_gameplay_renderables_index_range_hud_end +
        0x01
      )
    );
    ++index_renderable
  ) {
    struct metil_object* metil_object_hud = (
      metil_scene_gameplay->renderables[
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

    metil_object_hud->type_primitive = (
      MTLPrimitiveTypeLine
    );

    metil_object_hud->positioning = (
      metil_positioning_static
    );

    metil_object_hud->index_pipeline_render = (
      c938_pipeline_index_hud_item
    );

    struct metil_renderer_data_object* metil_renderer_data_object_hud = (
      metil_object_hud->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_renderer_data_object_hud->noise = (
      0x07d0
    );

    metil_object_hud->position.x = -(
      0.9f
    );

    metil_object_hud->position.y = -(
      0.9f -
      (float)
      (
        index_renderable -
        scene_gameplay_renderables_index_range_hud_start
      ) /
      0x0a
    );

    metil_object_hud->position.z = (
      0x00
    );
  }

  struct metil_group* metil_group_players = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_group_players
    ].renderable
  );
  
  struct metil_group* metil_group_guns = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_group_guns
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_players,
    0x01,
    metil_renderable_type_object
  );

  struct metil_object* metil_object_player = (
    metil_group_players->renderables[
      0x00
    ]->renderable
  );

  object_player_initialize(
    metil,
    metil_object_player,
    0x01
  );
  
  metil_group_add_length_initialize(
    metil_group_guns,
    0x02,
    metil_renderable_type_object
  );
  
  struct metil_object* c938_gun_right = (
    metil_group_guns->renderables[
      0x00
    ]->renderable
  );
  
  struct metil_object* c938_gun_left = (
    metil_group_guns->renderables[
      0x01
    ]->renderable
  );
  
  object_gun_initialize(
    metil,
    c938_gun_right,
    c938_handedness_right
  );
  
  object_gun_initialize(
    metil,
    c938_gun_left,
    c938_handedness_left
  );
    
  struct metil_object* metil_object_crosshair = (    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_crosshair
    ].renderable
  );

  object_crosshair_initialize(
    metil_object_crosshair,
    metil->renderer_interface.metal_device
  );

  scene_gameplay_populate(
    metil,
    metil_scene_gameplay,
    1
  );

  metil_audio_io_proc_add(
    &metil->audio,
    c938_audio_io_proc_scene_gameplay
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
  struct metil_scene* metil_scene_gameplay,
  unsigned char reset
) {
  struct c938_data* c938_data = (
    metil->data
  );

  struct network_client* network_client = &(
    c938_data->network_client
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  struct player_data* player_data = (
    metil_scene_gameplay->player.data
  );

  struct metil_group* metil_group_buildings = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_buildings
    ].renderable
  );

  struct metil_group* metil_group_enemies = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_enemies
    ].renderable
  );

  struct metil_group* metil_group_projectiles = (
    metil_scene_gameplay->renderables[
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

  metil_scene_gameplay->player.rotation.x = (
    0x00
  );

  metil_scene_gameplay->player.rotation.y = (
    0x00
  );

  metil_scene_gameplay->player.rotation.z = (
    0x00
  );

  metil_scene_gameplay->player.velocity.x = (
    0x00
  );

  metil_scene_gameplay->player.velocity.y = (
    0x00
  );

  metil_scene_gameplay->player.velocity.z = (
    0x00
  );

  player_data_initialize(
    player_data,
    metil->rendering_properties.camera.height_default
  );

  player_data->time = &(
    metil_scene_gameplay->time
  );

  scene_gameplay_data->length_projectiles = (
    0x00
  );

  for (
    unsigned char index_projectile = (
      0x00
    );
    (
      index_projectile <
      scene_gameplay_data_length_projectiles_maximum
    );
    ++index_projectile
  ) {
    scene_gameplay_data->fired_projectiles[
      index_projectile
    ] = (
      0x00
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
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_group_players
    ].renderable
  );
  
  struct metil_group* metil_group_guns = (
    metil_scene_gameplay->renderables[
      scene_gameplay_renderables_index_group_guns
    ].renderable
  );
  struct metil_object* metil_object_player = (
    metil_group_players->renderables[
      0x00
    ]->renderable
  );
  
  struct metil_object* c938_object_gun_right = (
    metil_group_guns->renderables[
      0x00
    ]->renderable
  );
  
  struct metil_object* c938_object_gun_left = (
    metil_group_guns->renderables[
      0x01
    ]->renderable
  );

  if (
    (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_client
    ) &&
    (
      (
        (
          network_client->status & (
            network_client_status_disconnecting |
            network_client_status_disconnected
          )
        ) ==
        0x00
      ) &&
      (
        network_client->status !=
        network_client_status_none
      )
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
      &metil_scene_gameplay->player.position,
      &player_data->index_target_building,
      metil_scene_gameplay->textures[
        scene_gameplay_textures_index_buildings
      ]
    );

    scene_gameplay_data->parameters->networked = (
      networked
    );

    scene_gameplay_data->speed_movement = (
      scene_gameplay_data->parameters->speed_movement
    );

    metil_scene_gameplay->player.speed_movement = (
      scene_gameplay_data->speed_movement
    );

    scene_gameplay_data->length_buildings = (
      scene_gameplay_data->parameters->length_buildings
    );

    scene_gameplay_data->length_enemies = (
      scene_gameplay_data->parameters->length_enemies
    );

    metil_object_player->position.y = (
      metil_scene_gameplay->player.position.y
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
      0x00
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
    0x0a,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  if (
    reset !=
    0x00
  ) {
    scene_gameplay_data->speed_movement = (
      scene_gameplay_data->parameters->speed_movement
    );

    metil_scene_gameplay->player.speed_movement = (
      scene_gameplay_data->speed_movement
    );

    scene_gameplay_data->length_buildings = (
      scene_gameplay_data->parameters->length_buildings
    );

    scene_gameplay_data->length_enemies = (
      scene_gameplay_data->parameters->length_enemies
    );
  } else {
    metil_scene_gameplay->player.speed_movement = (
      scene_gameplay_data->speed_movement *
      scene_gameplay_data->parameters->multiplier_speed_movement
    );

    if (
      (unsigned int)
      (
        scene_gameplay_data->length_buildings *
        scene_gameplay_data->parameters->multiplier_buildings
      ) >
      0xfde8
    ) {
      scene_gameplay_data->length_buildings = (
        0xfde8
      );
    } else if (
      (unsigned int)
      (
        scene_gameplay_data->length_buildings *
        scene_gameplay_data->parameters->multiplier_buildings
      ) <
      0x03
    ) {
      scene_gameplay_data->length_buildings = (
        0x03
      );
    } else {
      scene_gameplay_data->length_buildings = (
        scene_gameplay_data->length_buildings *
        scene_gameplay_data->parameters->multiplier_buildings
      );
    }

    if (
      (unsigned int)
      (
        scene_gameplay_data->length_enemies *
        scene_gameplay_data->parameters->multiplier_enemies
      ) >
      0xfde8
    ) {
      scene_gameplay_data->length_enemies = (
        0xfde8
      );
    } else {
      scene_gameplay_data->length_enemies = (
        scene_gameplay_data->length_enemies *
        scene_gameplay_data->parameters->multiplier_enemies
      );
    }
  }

  if (
    scene_gameplay_data->parameters->objective ==
    gameplay_objective_target
  ) {
    player_data->index_target_building = (
      (
        rand_result.bytes[
          0x00
        ] *
        rand_result.bytes[
          0x01
        ] +
        rand_result.bytes[
          0x02
        ]
      ) % (
        scene_gameplay_data->length_buildings -
        0x02
      ) +
      0x02
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
    player_data->index_target_building
  );

  struct metil_object* object = (
    metil_group_buildings->renderables[
      scene_gameplay_group_buildings_index_starting
    ]->renderable
  );

  metil_scene_gameplay->player.position.x = (
    object->position.x
  );

  metil_scene_gameplay->player.position.y = (
    object->position.y +
    object->mesh.size.y
  );

  metil_scene_gameplay->player.position.z = (
    object->position.z
  );

  metil_object_player->position.y = (
    metil_scene_gameplay->player.position.y
  );
  
  c938_object_gun_right->position.x = (
    0x04
  );
  
  c938_object_gun_right->position.y = (
    metil_object_player->position.y +
    0x06
  );
  
  c938_object_gun_left->position.x = -(
    0x04
  );
  
  c938_object_gun_left->position.y = (
    metil_object_player->position.y +
    0x06
  );   
      metil_group_destroy(
    metil,
    metil_group_enemies
  );

  metil_group_initialize(
    metil_group_enemies
  );

  float distance_minimum = (
    0xc8
  );

  metil_group_add_length_initialize(
    metil_group_enemies,
    scene_gameplay_data->length_enemies,
    metil_renderable_type_object
  );

  for (
    unsigned int index_enemy = (
      0x00
    );
    (
      index_enemy <
      metil_group_enemies->length
    );
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
        0x04e2 -
        (
          rand_result.bytes[
            0x00
          ] *
          rand_result.bytes[
            0x01
          ]
        ) %
        0x09c4
      ),
      .y = (
        0x03e8 +
        (
          (
            rand_result.bytes[
              0x02
            ] *
            rand_result.bytes[
              0x03
            ]
          ) %
          0x01f4
        )
      ),
      .z = (
        0x04e2 -
        (
          rand_result.bytes[
            0x04
          ] *
          rand_result.bytes[
            0x05
          ]
        ) %
        0x09c4
      )
    };

    if (
      (
        position_enemy.x <=
        distance_minimum
      ) &&
      (
        position_enemy.x >=
        -distance_minimum
      )
    ) {
      float offset = (
        rand_result.bytes[
          0x07
        ] +
        distance_minimum
      );

      if (
        position_enemy.x <
        0x00
      ) {
        offset = -(
          offset
        );
      }

      position_enemy.x = (
        position_enemy.x +
        offset
      );
    }

    if (
      (
        position_enemy.z <=
        distance_minimum
      ) &&
      (
        position_enemy.z >=
        -distance_minimum
      )
    ) {
      float offset = (
        rand_result.bytes[
          0x06
        ] +
        distance_minimum
      );

      if (
        position_enemy.z <
        0x00
      ) {
        offset = -(
          offset
        );
      }

      position_enemy.z = (
        position_enemy.z +
        offset
      );
    }

    float speed_enemy = (
      (float)
      (
        rand_result.bytes[
          0x08
        ] +
        rand_result.bytes[
          0x09
        ]
      ) /
      0xff *
      0x10 +
      0x20
    );

    object_enemy_initialize(
      metil_object_enemy,
      metil->renderer_interface.metal_device,
      position_enemy,
      0x04,
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
      &metil_scene_gameplay->player.position,
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
          0x01
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
        network_client->network_data_packet_poll !=
        0x00
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

        scene_gameplay_group_players_resize(
          metil,
          metil_group_players,
          length_players
        );

        unsigned char offset_player = (
          0x00
        );

        for (
          unsigned int index_player = (
            0x00
          );
          (
            index_player <
            length_players
          );
          ++index_player
        ) {
          if (
            index_client ==
            index_player
          ) {
            offset_player = (
              0x01
            );

            network_client->network_data_packet_poll->offset = (
              network_client->network_data_packet_poll->offset +
              data_length_math_c_vector3_float
            );

            continue;
          }

          struct metil_object* metil_object_player = (
            metil_group_players->renderables[
              index_player +
              0x01 -
              offset_player
            ]->renderable
          );

          network_data_packet_read(
            network_client->network_data_packet_poll,
            &metil_object_player->position,
            data_length_math_c_vector3_float
          );
        }

        unsigned int length_shots_fired = (
          0x00
        );

        network_data_packet_read(
          network_client->network_data_packet_poll,
          &length_shots_fired,
          data_length_unsigned_int
        );

        unsigned int index_projectile = (
          metil_group_projectiles->length
        );

        metil_group_add_length_initialize(
          metil_group_projectiles,
          length_shots_fired,
          metil_renderable_type_object
        );

        struct network_data_shot_fired network_data_shot_fired;

        for (
          unsigned int index_shot_fired = (
            0x00
          );
          (
            index_shot_fired <
            length_shots_fired
          );
          ++index_shot_fired
        ) {
          network_data_packet_read(
            network_client->network_data_packet_poll,
            &network_data_shot_fired,
            data_length_network_data_shot_fired
          );

          struct metil_object* metil_object_projectile = (
            metil_group_projectiles->renderables[
              index_projectile
            ]->renderable
          );

          index_projectile = (
            index_projectile +
            0x01
          );

          object_projectile_initialize(
            metil_object_projectile,
            metil->renderer_interface.metal_device,
            network_data_shot_fired.position,
            (struct math_c_vector3_float) {
              .x = (
                network_data_shot_fired.angle.x
              ),
              .y = (
                network_data_shot_fired.angle.y
              ),
              .z = (
                0x00
              )
            },
            network_data_shot_fired.time,
            0xc8
          );
        }

        network_data_packet_destroy(
          network_client->network_data_packet_poll
        );

        clic3_memory_free_raw(
          network_client->network_data_packet_poll
        );

        network_client->network_data_packet_poll = (
          0x00
        );
      }

      pthread_mutex_unlock(
        &network_client->mutex_poll
      );

      pthread_mutex_lock(
        &network_client->mutex_enemies
      );

      if (
        network_client->network_data_packet_enemies !=
        0x00
      ) {
        unsigned int length_enemies;

        network_data_packet_read(
          network_client->network_data_packet_enemies,
          &length_enemies,
          data_length_unsigned_int
        );

        scene_gameplay_group_enemies_resize(
          metil,
          metil_group_enemies,
          length_enemies
        );

        for (
          unsigned int index_enemy = (
            0x00
          );
          (
            index_enemy <
            length_enemies
          );
          ++index_enemy
        ) {
          struct metil_object* metil_object_enemy = (
            metil_group_enemies->renderables[
              index_enemy
            ]->renderable
          );

          struct enemy_data* enemy_data = (
            metil_object_enemy->buffers_vertex[
              metil_object_buffer_default_index_data
            ].buffer.contents
          );

          network_data_packet_read(
            network_client->network_data_packet_enemies,
            &enemy_data->life,
            0x01
          );

          network_data_packet_read(
            network_client->network_data_packet_enemies,
            &metil_object_enemy->position,
            data_length_math_c_vector3_float
          );

          network_data_packet_read(
            network_client->network_data_packet_enemies,
            &enemy_data->speed,
            data_length_float
          );
        }

        network_data_packet_destroy(
          network_client->network_data_packet_enemies
        );

        clic3_memory_free_raw(
          network_client->network_data_packet_enemies
        );

        network_client->network_data_packet_enemies = (
          0x00
        );
      }

      pthread_mutex_unlock(
        &network_client->mutex_enemies
      );
    } else if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_host
    ) {
      unsigned int length_players = (
        network_host->connected_players +
        0x01
      );

      scene_gameplay_group_players_resize(
        metil,
        metil_group_players,
        length_players
      );

      unsigned int offset_network_host_client = (
        0x00
      );

      for (
        unsigned int index_player = (
          0x01
        );
        (
          index_player <
          metil_group_players->length
        );
        ++index_player
      ) {
        struct metil_object* metil_object_player = (
          metil_group_players->renderables[
            index_player
          ]->renderable
        );

        for (
          unsigned int index_client = offset_network_host_client;
          index_client < network_host->length_clients;
          ++index_client
        ) {
          struct network_host_client* network_host_client = (
            network_host->clients[
              index_client
            ]
          );

          if (
            (
              network_host_client->status &
              network_client_status_connected
            ) ==
            0x00
          ) {
            continue;
          }

          offset_network_host_client = (
            index_client +
            0x01
          );

          pthread_mutex_lock(
            &network_host_client->mutex_position
          );

          metil_object_player->position.x = (
            network_host_client->position.x
          );

          metil_object_player->position.y = (
            network_host_client->position.y
          );

          metil_object_player->position.z = (
            network_host_client->position.z
          );

          pthread_mutex_unlock(
            &network_host_client->mutex_position
          );

          struct metil_object* metil_object_building = (
            metil_group_buildings->renderables[
              player_data->index_target_building
            ]->renderable
          );

          if (
            metil_object_player->position.y == (
              metil_object_building->position.y +
              metil_object_building->mesh.size.y
            )
          ) {
            struct math_c_vector2_float size_half_object = {
              .x = (
                metil_object_building->mesh.size.x /
                0x02
              ),
              .y = (
                metil_object_building->mesh.size.z /
                0x02
              )
            };

            struct math_c_vector2_float position_minimum_object = {
              .x = (
                metil_object_building->position.x -
                size_half_object.x
              ),
              .y = (
                metil_object_building->position.z -
                size_half_object.y
              )
            };

            struct math_c_vector2_float position_maximum_object = {
              .x = (
                metil_object_building->position.x +
                size_half_object.x
              ),
              .y = (
                metil_object_building->position.z +
                size_half_object.y
              )
            };

            if (
              (
                metil_object_player->position.x >=
                (
                  position_minimum_object.x -
                  metil_object_player->mesh.size.x
                )
              ) &&
              (
                metil_object_player->position.x <=
                (
                  position_maximum_object.x +
                  metil_object_player->mesh.size.x
                )
              ) &&
              (
                metil_object_player->position.z >=
                (
                  position_minimum_object.y -
                  metil_object_player->mesh.size.z
                )
              ) &&
              (
                metil_object_player->position.z <=
                (
                  position_maximum_object.y +
                  metil_object_player->mesh.size.z
                )
              )
            ) {
              scene_gameplay_populate(
                metil,
                metil_scene_gameplay,
                0x00
              );

              return;
            }
          }

          break;
        }
      }
    }

    scene_gameplay_data->action_data_map = (
      scene_gameplay_data_action_data_map_none
    );
  }

  if (
    scene_gameplay_data->parameters->networked !=
    parameters_gameplay_networked_client &&
    player_data->on_ground == (
      player_data->index_target_building +
      0x01
    )
  ) {
    scene_gameplay_populate(
      metil,
      metil_scene_gameplay,
      0x00
    );

    return;
  } else if (
    metil_scene_gameplay->player.position.y <=
    0x0a
  ) {
    scene_gameplay_populate(
      metil,
      metil_scene_gameplay,
      0x01
    );

    return;
  }

  float time_delta_percent = (
    (float)
    metil_scene_gameplay->time_delta /
    0x03e8
  );

  for (
    unsigned int index_projectile = (
      0x00
    );
    (
      index_projectile <
      metil_group_projectiles->length
    );
  ) {
    struct metil_object* metil_object_projectile = (
      metil_group_projectiles->renderables[
        index_projectile
      ]->renderable
    );

    unsigned int collision = (
      0x00
    );

    if (
      scene_gameplay_data->parameters->networked !=
      parameters_gameplay_networked_client
    ) {
      for (
        unsigned int index_enemy = (
          0x00
        );
        (
          index_enemy <
          metil_group_enemies->length
        );
        ++index_enemy
      ) {
        struct metil_object* metil_object_enemy = (
          metil_group_enemies->renderables[
            index_enemy
          ]->renderable
        );

        if (
          (
            metil_object_projectile->position.x >=
            (
              metil_object_enemy->position.x -
              metil_object_enemy->mesh.size.x /
              0x02
            )
          ) &&
          (
            metil_object_projectile->position.x <=
            (
              metil_object_enemy->position.x +
              metil_object_enemy->mesh.size.x /
              0x02
            )
          ) &&
          (
            metil_object_projectile->position.y >=
            (
              metil_object_enemy->position.y -
              metil_object_enemy->mesh.size.y /
              0x02
            )
          ) &&
          (
            metil_object_projectile->position.y <=
            (
              metil_object_enemy->position.y +
              metil_object_enemy->mesh.size.y /
              0x02
            )
          ) &&
          (
            metil_object_projectile->position.z >=
            (
              metil_object_enemy->position.z -
              metil_object_enemy->mesh.size.z /
              0x02
            )
          ) &&
          (
            metil_object_projectile->position.z <=
            (
              metil_object_enemy->position.z +
              metil_object_enemy->mesh.size.z /
              0x02
            )
          )
        ) {
          collision = (
            0x01
          );

          struct enemy_data* enemy_data = (
            metil_object_enemy->buffers_vertex[
              metil_object_buffer_default_index_data
            ].buffer.contents
          );

          enemy_data->life = (
            enemy_data->life -
            0x01
          );

          if (
            enemy_data->life <=
            0x00
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
      (
        collision ==
        0x01
      ) ||
      (
        (
          projectile_data->time_current -
          projectile_data->time_fired
        ) >
        projectile_data->lifespan
      )
    ) {
      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_projectiles,
        index_projectile
      );
    } else {
      index_projectile = (
        index_projectile +
        0x01
      );
    }
  }

  for (
    unsigned int index_enemy = (
      0x00
    );
    (
      index_enemy <
      metil_group_enemies->length
    );
  ) {
    struct metil_object* metil_object_enemy = (
      metil_group_enemies->renderables[
        index_enemy
      ]->renderable
    );

    if (
      (
        metil_scene_gameplay->player.position.x >=
        (
          metil_object_enemy->position.x -
          metil_object_enemy->mesh.size.x /
          0x02
        )
      ) &&
      (
        metil_scene_gameplay->player.position.x <=
        (
          metil_object_enemy->position.x +
          metil_object_enemy->mesh.size.x /
          0x02
        )
      ) &&
      (
        (
          metil_scene_gameplay->player.position.y +
          player_data->height
        ) >=
        (
          metil_object_enemy->position.y -
          metil_object_enemy->mesh.size.y /
          0x02
        )
      ) &&
      (
        (
          metil_scene_gameplay->player.position.y +
          player_data->height
        ) <=
        (
          metil_object_enemy->position.y +
          metil_object_enemy->mesh.size.y /
          0x02
        )
      ) &&
      (
        metil_scene_gameplay->player.position.z >=
        (
          metil_object_enemy->position.z -
          metil_object_enemy->mesh.size.z /
          0x02
        )
      ) &&
      (
        metil_scene_gameplay->player.position.z <=
        (
          metil_object_enemy->position.z +
          metil_object_enemy->mesh.size.z /
          0x02
        )
      )
    ) {
      player_data->life = (
        player_data->life -
        0x01
      );

      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_enemies,
        index_enemy
      );

      if (
        player_data->life <=
        0x00
      ) {
        scene_gameplay_populate(
          metil,
          metil_scene_gameplay,
          0x01
        );

        return;
      }

      continue;
    } else {
      index_enemy = (
        index_enemy +
        0x01
      );
    }
  }

  if (
    (
      scene_gameplay_data->parameters->objective ==
      gameplay_objective_enemies
    ) &&
    (
      metil_group_enemies->length ==
      0x00
    )
  ) {
    scene_gameplay_populate(
      metil,
      metil_scene_gameplay,
      0x01
    );

    return;
  }

  metil_scene_poll_default(
    metil,
    metil_scene_gameplay
  );

  struct metil_object* metil_object_player = (
    metil_group_players->renderables[
      0x00
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

      network_data_packet = (
        clic3_memory_allocate_raw(
          sizeof(
            struct network_data_packet
          )
        )
      );

      pthread_mutex_lock(
        &network_client->mutex_shots_fired
      );

      network_data_packet_initialize(
        network_data_packet,
        network_command_poll,
        (
          data_length_math_c_vector3_float +
          data_length_unsigned_int +
          (
            data_length_network_data_shot_fired *
            network_client->length_shots_fired
          )
        )
      );

      network_data_packet_bytes_add(
        network_data_packet,
        &metil_scene_gameplay->player.position,
        data_length_math_c_vector3_float
      );

      network_data_packet_bytes_add(
        network_data_packet,
        &network_client->length_shots_fired,
        data_length_unsigned_int
      );

      for (
        unsigned int index_shot_fired = (
          0x00
        );
        (
          index_shot_fired <
          network_client->length_shots_fired
        );
        ++index_shot_fired
      ) {
        network_data_packet_bytes_add(
          network_data_packet,
          &network_client->shots_fired[
            index_shot_fired
          ],
          data_length_network_data_shot_fired
        );
      }

      network_client->length_shots_fired = (
        0x00
      );

      clic3_memory_reallocate_raw(
        &network_client->shots_fired,
        0x00
      );

      pthread_mutex_unlock(
        &network_client->mutex_shots_fired
      );

      network_client_send(
        network_client,
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

      for (
        unsigned int index_network_host_client = (
          0x00
        );
        (
          index_network_host_client <
          network_host->length_clients
        );
        ++index_network_host_client
      ) {
        struct network_host_client* network_host_client = (
          network_host->clients[
            index_network_host_client
          ]
        );

        if (
          (
            network_host_client->status &
            network_client_status_connected
          ) ==
          0x00
        ) {
          continue;
        }

        pthread_mutex_lock(
          &network_host_client->mutex_shots_fired
        );

        unsigned int index_projectile = (
          metil_group_projectiles->length
        );

        metil_group_add_length_initialize(
          metil_group_projectiles,
          network_host_client->length_shots_fired,
          metil_renderable_type_object
        );

        for (
          unsigned int index_shot_fired = (
            0x00
          );
          (
            index_shot_fired <
            network_host_client->length_shots_fired
          );
          ++index_shot_fired
        ) {
          struct network_data_shot_fired* network_data_shot_fired = &(
            network_host_client->shots_fired[
              index_shot_fired
            ]
          );

          struct metil_object* metil_object_projectile = (
            metil_group_projectiles->renderables[
              index_projectile
            ]->renderable
          );

          index_projectile = (
            index_projectile +
            0x01
          );

          object_projectile_initialize(
            metil_object_projectile,
            metil->renderer_interface.metal_device,
            network_data_shot_fired->position,
            (struct math_c_vector3_float) {
              .x = (
                network_data_shot_fired->angle.x
              ),
              .y = (
                network_data_shot_fired->angle.y
              ),
              .z = (
                0x00
              )
            },
            network_data_shot_fired->time,
            0xc8
          );
        }

        network_host_client->length_shots_fired = (
          0x00
        );

        clic3_memory_reallocate_raw(
          &network_host_client->shots_fired,
          0x00
        );

        pthread_mutex_unlock(
          &network_host_client->mutex_shots_fired
        );
      }

      network_host_send_poll(
        network_host
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
    player_data->is_boosted ==
    0x01
  ) {
    unsigned long int delta_time_boost = (
      metil_scene_gameplay->time_input -
      player_data->time_boost
    );

    metil_renderer_data_object_hud_boosted->noise = (
      math_c_minimum_unsigned_int(
        delta_time_boost,
        0x07d0
      )
    );
  } else {
    metil_renderer_data_object_hud_boosted->noise = (
      0x07d0
    );
  }

  metil_renderer_data_object_hud_jumping->noise = (
    (
      player_data->is_jumping !=
      0x00
    )
    ? 0x00
    : 0x07d0
  );

  metil_renderer_data_object_hud_jumping_secondary->noise = (
    (
      player_data->is_jumping_secondary !=
      0x00
    )
    ? 0x00
    : 0x07d0
  );

  if (
    scene_gameplay_data->parameters->networked ==
    parameters_gameplay_networked_host
  ) {
    struct c938_data* c938_data = (
      metil->data
    );

    struct network_host* network_host = &(
      c938_data->network_host
    );

    struct network_data_packet network_data_packet_enemies;

    network_data_packet_initialize(
      &network_data_packet_enemies,
      network_command_enemies,
      (
        data_length_unsigned_int +
        metil_group_enemies->length *
        (
          0x01 +
          data_length_math_c_vector3_float +
          data_length_float
        )
      )
    );

    network_data_packet_bytes_add(
      &network_data_packet_enemies,
      &metil_group_enemies->length,
      data_length_unsigned_int
    );

    for (
      unsigned int index_enemy = (
        0x00
      );
      (
        index_enemy <
        metil_group_enemies->length
      );
      ++index_enemy
    ) {
      struct metil_object* metil_object_enemies = (
        metil_group_enemies->renderables[
          index_enemy
        ]->renderable
      );

      struct enemy_data* enemy_data = (
        metil_object_enemies->buffers_vertex[
          metil_object_buffer_default_index_data
        ].buffer.contents
      );

      network_data_packet_bytes_add(
        &network_data_packet_enemies,
        &enemy_data->life,
        1
      );

      network_data_packet_bytes_add(
        &network_data_packet_enemies,
        &metil_object_enemies->position,
        data_length_math_c_vector3_float
      );

      network_data_packet_bytes_add(
        &network_data_packet_enemies,
        &enemy_data->speed,
        data_length_float
      );
    }

    for (
      unsigned int index_network_host_client = (
        0x00
      );
      (
        index_network_host_client <
        network_host->length_clients
      );
      ++index_network_host_client
    ) {
      struct network_host_client* network_host_client = (
        network_host->clients[
          index_network_host_client
        ]
      );

      if (
        (
          network_host_client->status &
          network_client_status_connected
        ) ==
        0x00
      ) {
        continue;
      }

      network_data_packet_send(
        &network_data_packet_enemies,
        network_host_client->socket
      );
    }

    network_data_packet_destroy(
      &network_data_packet_enemies
    );
  }
}

void scene_gameplay_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene_gameplay
) {
  metil_audio_io_proc_remove(
    &metil->audio,
    c938_audio_io_proc_scene_gameplay
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene_gameplay->data
  );

  clic3_memory_free_raw(
    metil_scene_gameplay->data
  );

  metil_scene_gameplay->data = (
    0x00
  );

  metil_scene_gameplay->length_renderables = (
    metil_scene_gameplay->length_renderables -
    0x01
  );

  metil_scene_destroy_default(
    metil,
    metil_scene_gameplay
  );
}
