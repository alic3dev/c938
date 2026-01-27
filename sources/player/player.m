#include <player/player.h>

#include <data/c938_data.h>
#include <data/data_length.h>
#include <data/player_data.h>
#include <data/scene_gameplay_data.h>
#include <objects/object_projectile.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <metil_group.h>
#include <metil_input/metil_keycodes.h>
#include <metil_input/metil_input_map.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

const float player_speed_movement_default = 100.0f;

const float player_jump_velocity = 90.0f;

const unsigned long int delta_time_jump_threshold = 250;

void player_poll_input(
  struct metil* metil,
  struct metil_player* player,
  unsigned long int time,
  unsigned long int time_delta
) {
  struct player_data* player_data = (
    (struct player_data*) player->data
  );

  float speed_delta = (float) time_delta / 1000.0f;

  unsigned long int delta_time_jump = time - player_data->time_jump;

  if (
    player_data->is_boosted == 0 &&
    (metil->input.keydown_map[
      metil_keycode_x
    ] == 1 || 
    metil->input.keydown_map[
      metil_keycode_period
    ] == 1 || (
      metil->input.controller_state.available == 1 &&
      metil->input.controller_state.r1 >= 0.1f
    ))
  ) {
    player->speed_movement = (
      player_speed_movement_default * 4.0f
    );

    player_data->is_boosted = 1;
    player_data->time_boost = time;
  } else if (
    player_data->is_boosted == 1
  ) {
    unsigned long int delta_time_boost = time - player_data->time_boost;

    if (
      delta_time_boost >= 2000
    ) {
      player_data->is_boosted = 0;
      player->speed_movement = player_speed_movement_default;
    } else {
      if (delta_time_boost > 1000) {
        delta_time_boost = 1000;
      }

      player->speed_movement = (
        player_speed_movement_default * (
          4.0f - (((float) delta_time_boost / 1000.0f) * 3.0f)
        )
      );
    }
  }

  float speed_original = player->speed_movement;

  player->speed_movement = (
    player->speed_movement *
    (float) time_delta / 1000.0f
  );

  if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.l2 >= 0.1f &&
    metil->input.controller_state.l3 == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      (metil->input.controller_state.l2 + 1.0f)
    );
  } else if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.l2 < 0.1f &&
    metil->input.controller_state.l3 >= 0.1f
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      metil->input.keydown_map[
        metil_keycode_option_right
      ] == 1 ||
      metil->input.keydown_map[
        metil_keycode_control
      ] == 1
    )  && (
      metil->input.keydown_map[
        metil_keycode_shift_left
      ] == 0 &&
      metil->input.keydown_map[
        metil_keycode_shift_right
      ] == 0
    )
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      metil->input.keydown_map[
        metil_keycode_option_right
      ] == 0 &&
      metil->input.keydown_map[
        metil_keycode_control
      ] == 0
    ) && (
      metil->input.keydown_map[
        metil_keycode_shift_left
      ] == 1 ||
      metil->input.keydown_map[
        metil_keycode_shift_right
      ] == 1 
    )
  ) {
    player->speed_movement = (
      player->speed_movement * 2.0f
    );
  }

  struct math_c_vector3_float movement = {
    .x = 0.0f,
    .y = 0.0f,
    .z = 0.0f
  };

  struct math_c_vector2_float ratio_movement = {
    .x = 0.0f,
    .y = 0.0f
  };

  struct math_c_vector2_float ratio_movement_strafe = {
    .x = 0.0f,
    .y = 0.0f
  };

  if (
    metil->input.cursor.locked == 1
  ) {
    player->rotation.y = (
      player->rotation.y - (
        metil->input.cursor.delta.x / 50.0f *
        player->speed_rotation
      )
    );

    player->rotation.x = (
      player->rotation.x - (
        metil->input.cursor.delta.y / 50.0f *
        player->speed_rotation
      )
    );

    metil->input.cursor.delta.x = 0;
    metil->input.cursor.delta.y = 0;
  }

  if (metil->input.controller_state.available == 1) {
    if (
      metil->input.controller_state.right_stick.x != 0.0f
    ) {
      player->rotation.y = (
        player->rotation.y - (
          metil->input.controller_state.right_stick.x *
          player->speed_rotation
        )
      );
    }

    if (
      metil->input.controller_state.right_stick.y != 0.0f
    ) {
      player->rotation.x = (
        player->rotation.x + (
          metil->input.controller_state.right_stick.y *
          player->speed_rotation
        )
      );
    }
  }

  if (
    player->rotation.x > M_PI_2
  ) {
    player->rotation.x = M_PI_2;
  } else if (
    player->rotation.x < -M_PI_2
  ) {
    player->rotation.x = -M_PI_2;
  }

  player->rotation.y = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  );
  
  float ratio_axis = -(
    player->rotation.y / (
      M_PI *
      2.0f
    )
  );

  if (
    ratio_axis >= 0.0f &&
    ratio_axis <= 0.25f
  ) {
    ratio_movement.y = (0.25f - ratio_axis) / 0.25f;
    ratio_movement.x = (ratio_axis / 0.25f);

    ratio_movement_strafe.y = -(ratio_axis / 0.25f);
    ratio_movement_strafe.x = (0.25f - ratio_axis) / 0.25f;
  } else if (
    ratio_axis >= 0.25f &&
    ratio_axis <= 0.5f 
  ) {
    ratio_axis = ratio_axis - 0.25f;

    ratio_movement.y = -(ratio_axis / 0.25f);
    ratio_movement.x = (0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = -(0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = -(ratio_axis / 0.25f);
  } else if (
    ratio_axis >= 0.5f &&
    ratio_axis <= 0.75f 
  ) {
    ratio_axis = ratio_axis - 0.5f;

    ratio_movement.y = -(0.25f - ratio_axis) / 0.25f;
    ratio_movement.x = -(ratio_axis / 0.25f);

    ratio_movement_strafe.y = (ratio_axis / 0.25f);
    ratio_movement_strafe.x = -(0.25f - ratio_axis) / 0.25f;
  } else if (
    ratio_axis > 0.75f
  ) {
    ratio_axis = ratio_axis - 0.75f;

    ratio_movement.y = (ratio_axis / 0.25f);
    ratio_movement.x = -(0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = (0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = (ratio_axis / 0.25f);
  } else if (
    ratio_axis >= -0.25f
  ) {
    ratio_movement.y = (-0.25f - ratio_axis) / -0.25f;
    ratio_movement.x = (ratio_axis / 0.25f);

    ratio_movement_strafe.y = -(ratio_axis / 0.25f);
    ratio_movement_strafe.x = (-0.25f - ratio_axis) / -0.25f;
  } else if (
    ratio_axis <= -0.25f &&
    ratio_axis >= -0.5f
  ) {
    ratio_axis = ratio_axis + 0.25f;

    ratio_movement.y = -(ratio_axis / -0.25f);
    ratio_movement.x = (-0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = -(-0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = -(ratio_axis / -0.25f);
  } else if (
    ratio_axis <= -0.5f &&
    ratio_axis >= -0.75f 
  ) {
    ratio_axis = ratio_axis + 0.5f;

    ratio_movement.y = -(-0.25f - ratio_axis) / -0.25f;
    ratio_movement.x = -(ratio_axis / 0.25f);

    ratio_movement_strafe.y = (ratio_axis / 0.25f);
    ratio_movement_strafe.x = -(-0.25f - ratio_axis) / -0.25f;
  } else {
    ratio_axis = ratio_axis + 0.75f;

    ratio_movement.y = (ratio_axis / -0.25f);
    ratio_movement.x = -(-0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = (-0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = (ratio_axis / -0.25f);
  }

  if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.left_stick.x != 0.0f ||
    metil->input.controller_state.left_stick.y != 0.0f
  ) {
    movement.x = (
      (metil->input.controller_state.left_stick.y * ratio_movement.x) +
      (metil->input.controller_state.left_stick.x * ratio_movement_strafe.x)
    );

    movement.z = (
      (metil->input.controller_state.left_stick.y * ratio_movement.y) +
      (metil->input.controller_state.left_stick.x * ratio_movement_strafe.y)
    );
  } else {
    struct math_c_vector2_float direction_arrows = {
      .x = (
        (
          metil->input.keydown_map[
            metil_keycode_single_quote
          ] || metil->input.keydown_map[
            metil_keycode_d
          ]
        ) - (
          metil->input.keydown_map[
            metil_keycode_l
          ] || metil->input.keydown_map[
            metil_keycode_a
          ]
        )
      ),
      .y = (
        (
          metil->input.keydown_map[
            metil_keycode_p
          ] || metil->input.keydown_map[
            metil_keycode_w
          ]
        ) - (
          metil->input.keydown_map[
            metil_keycode_semi_colon
          ] || 
          metil->input.keydown_map[
            metil_keycode_s
          ]
        )
      )
    };

    if (
      direction_arrows.x != 0.0f &&
      direction_arrows.y != 0.0f
    ) {
      direction_arrows.x = (
        direction_arrows.x * 0.82f
      );

      direction_arrows.y = (
        direction_arrows.y * 0.82f
      );
    }

    movement.x = (
      direction_arrows.y * ratio_movement.x +
      direction_arrows.x * ratio_movement_strafe.x
    );

    movement.z = (
      direction_arrows.y * ratio_movement.y +
      direction_arrows.x * ratio_movement_strafe.y
    );
  }

  if (
    (metil->input.keydown_map[
      metil_keycode_e
    ] == 1 ||
    metil->input.keydown_map[
      metil_keycode_o
    ] == 1) && (
      player_data->is_jumping == 0 ||
      (player_data->is_jumping_secondary == 0 && delta_time_jump >= delta_time_jump_threshold)
    )
  ) {
    player->velocity.y += player_jump_velocity;

    if (player_data->is_jumping == 0) {
      player_data->is_jumping = 1;
      player_data->time_jump = time;
    } else {
      player_data->is_jumping_secondary = 1;
    }
  }

  if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.l1 >= 0.1f
  ) {
    player->velocity.y = (
      player->velocity.y -
      (metil->input.controller_state.l1 * time_delta * 5.0f)
    );
  } else if (
    metil->input.keydown_map[
      metil_keycode_q
    ] == 1 ||
    metil->input.keydown_map[
      metil_keycode_opening_square_bracket
    ] == 1
  ) {
    player->velocity.y = (
      player->velocity.y -
      time_delta * 5.0f
    );
  }

  if (
    (metil->input.keydown_map[
      metil_keycode_space
    ] == 1 || (
      metil->input.controller_state.available == 1 &&
      metil->input.controller_state.cross >= 0.1f
    )) &&
    (
      player_data->is_jumping == 0 || 
      (player_data->is_jumping_secondary == 0 &&
      delta_time_jump >= delta_time_jump_threshold)
    )
  ) {
    player->velocity.y = (
      player->velocity.y + 
      player_jump_velocity
    );
    
    if (player_data->is_jumping == 0) {
      player_data->is_jumping = 1;
      player_data->time_jump = time;
    } else {
      player_data->is_jumping_secondary = 1;
    }
  }

  player_data->on_ground = 0;
  float position_ground_y = 0.0f;

  float addition_y = ((
      movement.y *
      player->speed_movement
    ) + (
      player->velocity.y * speed_delta
    )
  );

  struct math_c_vector3_float position_updated = {
    .x = (
      player->position.x + (
        movement.x *
        player->speed_movement
      )
    ),
    .y = (
      player->position.y + 
      addition_y
    ),
    .z = (
      player->position.z + (
        movement.z *
        player->speed_movement
      )
    )
  };

  struct math_c_vector2_float size_half_player = {
    .x = player->size.x / 2.0f,
    .y = player->size.z / 2.0f
  };

  struct metil_object* object = 0;

  for (
    unsigned int index_renderable = 0;
    index_renderable < player_data->buildings->length;
    ++index_renderable
  ) {
    object = player_data->buildings->renderables[
      index_renderable
    ]->renderable;

    struct math_c_vector2_float size_half_object = {
      .x = object->mesh.size.x / 2.0f,
      .y = object->mesh.size.z / 2.0f
    };

    struct math_c_vector2_float position_minimum_object = {
      .x = object->position.x - size_half_object.x,
      .y = object->position.z - size_half_object.y
    };

    struct math_c_vector2_float position_maximum_object = {
      .x = object->position.x + size_half_object.x,
      .y = object->position.z + size_half_object.y
    };

    if (
      position_updated.x >= position_minimum_object.x - player->size.x &&
      position_updated.x <= position_maximum_object.x + player->size.x &&
      position_updated.z >= position_minimum_object.y - player->size.z &&
      position_updated.z <= position_maximum_object.y + player->size.z &&
      position_updated.y <= (
        object->position.y +
        object->mesh.size.y
      ) &&
      position_updated.y >= (
        object->position.y +
        player->size.y
      )
    ) {
      // todo: this should be updated to use line intersections with applied rotations
      if (
        position_updated.y <= (
          object->position.y +
          object->mesh.size.y
        ) &&
        player->position.y >= (
          object->position.y +
          object->mesh.size.y
        )
      ) {
        player_data->on_ground = index_renderable + 1;
        position_updated.y = (
          object->position.y +
          object->mesh.size.y
        );

        if (
          position_updated.x == player->position.x &&
          position_updated.z == player->position.z
        ) {
          break;
        }

        continue;
      }

      if (
        player->position.x < position_minimum_object.x - size_half_player.x &&
        player->position.x > position_maximum_object.x + size_half_player.x &&
        position_updated.z < position_minimum_object.y - size_half_player.y &&
        position_updated.z > position_maximum_object.y + size_half_player.y
      ) {
        position_updated.x = player->position.x;
      } else if (
        position_updated.x < position_minimum_object.x - size_half_player.x &&
        position_updated.x > position_maximum_object.x + size_half_player.x &&
        player->position.z < position_minimum_object.y - size_half_player.y &&
        player->position.z > position_maximum_object.y + size_half_player.y
      ) {
        position_updated.z = player->position.z;
      } else {
        position_updated.x = player->position.x;
        position_updated.z = player->position.z;

        if (
          player_data->on_ground != 0
        ) {
          break;
        }
      }
    }
  }

  player->position.x = position_updated.x;
  player->position.y = position_updated.y;
  player->position.z = position_updated.z;

  if (
    player_data->on_ground == 0
  ) {
    if (
      player->velocity.y > -1000.0f
    ) {
      player->velocity.y = (
        player->velocity.y - (
          player_speed_movement_default
        ) * speed_delta * 1.5f
      );

      if (player->velocity.y < -1000.0f) {
        player->velocity.y = -1000.0f;
      }
    }
  } else {
    player->velocity.y = 0.0f;
    player_data->time_jump = 0;
    player_data->is_jumping = 0;
    player_data->is_jumping_secondary = 0;
  }

  if (player->velocity.y < -1000.0f) {
    player->velocity.y = -1000.0f;
  }

  player->speed_movement = speed_original;

  if (
    player_data->shooting == 0 && (
      metil->input.controller_state.available == 1 &&
      metil->input.controller_state.r2 >= 0.1f ||
      metil->input.cursor.down == 1
    )
  ) {
    player_data->shooting = 1;
  }
}

void player_poll(
  struct metil* metil,
  struct metil_player* player
) {
  struct player_data* player_data = (
    (struct player_data*) player->data
  );

  if (
    player_data->shooting == 1
  ) {
    metil_group_add_initialize(
      player_data->projectiles,
      metil_renderable_type_object
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

    if (
      scene_gameplay_data->length_projectiles == scene_gameplay_data_length_projectiles_maximum
    ) {
      for (
        unsigned int index_projectile_shift = 0;
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
    } else {
      scene_gameplay_data->length_projectiles = (
        scene_gameplay_data->length_projectiles +
        1
      );
    }
    
    scene_gameplay_data->fired_projectiles[
      scene_gameplay_data->length_projectiles -
      1
    ] = (
      *player_data->time
    );

    struct metil_renderable* metil_renderable_projectile = (
      player_data->projectiles->renderables[
        player_data->projectiles->length - 1
      ]
    );

    struct metil_object* metil_object_projectile = (
      metil_renderable_projectile->renderable
    );

    player_data->time_shot = (
      *player_data->time
    );

    struct math_c_vector3_float position_projectile = {
      .x = player->position.x,
      .y = (
        player->position.y +
        player_data->height
      ),
      .z = player->position.z
    };

    struct math_c_vector3_float angle_projectile = {
      .x = player->rotation.x,
      .y = -player->rotation.y,
      .z = player->rotation.z
    };

    if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_client
    ) {
      struct c938_data* c938_data = (
        metil->data
      );

      struct network_client* network_client = &(
        c938_data->network_client
      );

      pthread_mutex_lock(
        &network_client->mutex_shots_fired
      );

      network_client->length_shots_fired = (
        network_client->length_shots_fired +
        1
      );

      clic3_memory_reallocate_raw(
        &network_client->shots_fired,
        (
          data_length_network_data_shot_fired *
          network_client->length_shots_fired
        )
      );

      struct network_data_shot_fired* network_data_shot_fired = &(
        network_client->shots_fired[
          network_client->length_shots_fired -
          1
        ]
      );

      clic3_bytes_copy(
        &network_data_shot_fired->position,
        &position_projectile,
        data_length_math_c_vector3_float
      );

      clic3_bytes_copy(
        &network_data_shot_fired->angle,
        &angle_projectile,
        data_length_math_c_vector2_float
      );

      clic3_bytes_copy(
        &network_data_shot_fired->time,
        &player_data->time_shot,
        data_length_unsigned_long_int
      );

      pthread_mutex_unlock(
        &network_client->mutex_shots_fired
      );
    } else if (
      scene_gameplay_data->parameters->networked ==
      parameters_gameplay_networked_host
    ) {
      struct c938_data* c938_data = (
        metil->data
      );

      struct network_host* network_host = &(
        c938_data->network_host
      );

      pthread_mutex_lock(
        &network_host->mutex_shots_fired
      );

      network_host->length_shots_fired = (
        network_host->length_shots_fired +
        1
      );

      clic3_memory_reallocate_raw(
        &network_host->shots_fired,
        (
          data_length_network_data_shot_fired *
          network_host->length_shots_fired
        )
      );

      struct network_data_shot_fired* network_data_shot_fired = &(
        network_host->shots_fired[
          network_host->length_shots_fired -
          1
        ]
      );

      clic3_bytes_copy(
        &network_data_shot_fired->position,
        &position_projectile,
        data_length_math_c_vector3_float
      );

      clic3_bytes_copy(
        &network_data_shot_fired->angle,
        &angle_projectile,
        data_length_math_c_vector2_float
      );

      clic3_bytes_copy(
        &network_data_shot_fired->time,
        &player_data->time_shot,
        data_length_unsigned_long_int
      );

      for (
        unsigned int index_client = 0;
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
          ) == 0
        ) {
          continue;
        }

        pthread_mutex_lock(
          &network_host_client->mutex_shots_fired_outgoing
        );

        network_host_client_shots_fired_outgoing_add(
          network_host_client,
          1
        );

        clic3_bytes_copy(
          &network_host_client->shots_fired_outgoing[
            network_host_client->length_shots_fired_outgoing -
            1
          ],
          network_data_shot_fired,
          data_length_network_data_shot_fired
        );

        pthread_mutex_unlock(
          &network_host_client->mutex_shots_fired_outgoing
        );
      }

      pthread_mutex_unlock(
        &network_host->mutex_shots_fired
      );
    }

    object_projectile_initialize(
      metil_object_projectile,
      player_data->metal_device,
      position_projectile,
      angle_projectile,
      *player_data->time,
      player_data->is_boosted == 0
      ? 200.0f :
      800.0f
    );

    player_data->shooting = 2;
  } else if (
    player_data->shooting > 1
  ) {
    if (
      *player_data->time -
      player_data->time_shot > (
        player_data->is_boosted == 0
        ? player_data->rate_fire
        : player_data->rate_fire / 8
      )
    ) {
      player_data->shooting = 0;
    }
  }
}

void player_destroy(
  struct metil* metil,
  struct metil_player* player
) {
  free(
    player->data
  );

  metil_player_destroy(
    metil,
    player
  );
}
