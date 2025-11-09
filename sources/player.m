#include <player.h>

#include <player_data.h>

#include <metil_input/controller_state.h>
#include <metil_input/cursor.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>
#include <metil_object.h>
#include <metil_player.h>

#include <math.h>
#include <stdlib.h>

const float player_speed_movement_default = 100.0f;

const float player_jump_velocity = 90.0f;

const unsigned long int delta_time_jump_threshold = 250;

void player_poll_input(
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
    (metil_input_map_keydown[
      metil_keycode_x
    ] == 1 || (
      metil_controller_state.available == 1 &&
      metil_controller_state.r1 >= 0.1f
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
    metil_controller_state.available == 1 &&
    metil_controller_state.l2 >= 0.1f &&
    metil_controller_state.l3 == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      (metil_controller_state.l2 + 1.0f)
    );
  } else if (
    metil_controller_state.available == 1 &&
    metil_controller_state.l2 < 0.1f &&
    metil_controller_state.l3 >= 0.1f
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      metil_input_map_keydown[
        metil_keycode_option_right
      ] == 1 ||
      metil_input_map_keydown[
        metil_keycode_control
      ] == 1
    )  && (
      metil_input_map_keydown[
        metil_keycode_shift_left
      ] == 0 &&
      metil_input_map_keydown[
        metil_keycode_shift_right
      ] == 0
    )
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      metil_input_map_keydown[
        metil_keycode_option_right
      ] == 0 &&
      metil_input_map_keydown[
        metil_keycode_control
      ] == 0
    ) && (
      metil_input_map_keydown[
        metil_keycode_shift_left
      ] == 1 ||
      metil_input_map_keydown[
        metil_keycode_shift_right
      ] == 1 
    )
  ) {
    player->speed_movement = (
      player->speed_movement * 2.0f
    );
  }

  struct clic3_vector3_float movement = {
    .x = 0.0f,
    .y = 0.0f,
    .z = 0.0f
  };

  struct clic3_vector2_float ratio_movement = {
    .x = 0.0f,
    .y = 0.0f
  };

  struct clic3_vector2_float ratio_movement_strafe = {
    .x = 0.0f,
    .y = 0.0f
  };

  if (
    metil_input_cursor.locked == 1
  ) {
    player->rotation.y = (
      player->rotation.y + (
        metil_input_cursor.delta.x / 50.0f *
        player->speed_rotation
      )
    );

    player->rotation.x = (
      player->rotation.x - (
        metil_input_cursor.delta.y / 50.0f *
        player->speed_rotation
      )
    );

    metil_input_cursor.delta.x = 0;
    metil_input_cursor.delta.y = 0;
  }

  if (metil_controller_state.available == 1) {
    if (
      metil_controller_state.right_stick.x >= 0.1f || 
      metil_controller_state.right_stick.x <= -0.1f
    ) {
      player->rotation.y = (
        player->rotation.y + (
          metil_controller_state.right_stick.x *
          player->speed_rotation
        )
      );
    }

    if (
      metil_controller_state.right_stick.y >= 0.1f || 
      metil_controller_state.right_stick.y <= -0.1f
    ) {
      player->rotation.x = (
        player->rotation.x + (
          metil_controller_state.right_stick.y *
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
  
  float ratio_axis = player->rotation.y / (M_PI * 2.0f);

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
    metil_controller_state.available == 1 &&
    metil_controller_state.left_stick.x != 0.0f ||
    metil_controller_state.left_stick.y != 0.0f
  ) {
    movement.x = (
      (metil_controller_state.left_stick.y * ratio_movement.x) +
      (metil_controller_state.left_stick.x * ratio_movement_strafe.x)
    );

    movement.z = (
      (metil_controller_state.left_stick.y * ratio_movement.y) +
      (metil_controller_state.left_stick.x * ratio_movement_strafe.y)
    );
  } else {
    struct clic3_vector2_float direction_arrows = {
      .x = (
        (
          metil_input_map_keydown[
            metil_keycode_right_arrow
          ] || metil_input_map_keydown[
            metil_keycode_d
          ]
        ) - (
          metil_input_map_keydown[
            metil_keycode_left_arrow
          ] || metil_input_map_keydown[
            metil_keycode_a
          ]
        )
      ),
      .y = (
        (
          metil_input_map_keydown[
            metil_keycode_up_arrow
          ] || metil_input_map_keydown[
            metil_keycode_w
          ]
        ) - (
          metil_input_map_keydown[
            metil_keycode_down_arrow
          ] || 
          metil_input_map_keydown[
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
    (metil_input_map_keydown[
      metil_keycode_e
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_slash
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
    metil_controller_state.available == 1 &&
    metil_controller_state.r2 >= 0.1f
  ) {
    player->velocity.y = (
      player->velocity.y -
      (metil_controller_state.r2 * time_delta * 5.0f)
    );
  } else if (
    metil_input_map_keydown[
      metil_keycode_q
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_period
    ] == 1
  ) {
    player->velocity.y = (
      player->velocity.y -
      time_delta * 5.0f
    );
  }

  if (
    (metil_input_map_keydown[
      metil_keycode_space
    ] == 1 || (
      metil_controller_state.available == 1 &&
      metil_controller_state.cross >= 0.1f
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

  struct clic3_vector3_float position_updated = {
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

  struct clic3_vector2_float size_half_player = {
    .x = player->size.x / 2.0f,
    .y = player->size.z / 2.0f
  };

  struct metil_object* object = (void*)0;

  for (
    unsigned int index_renderable = 0;
    index_renderable < player_data->length_renderables;
    ++index_renderable
  ) {
    object = player_data->renderables[
      index_renderable
    ].renderable;

    struct clic3_vector2_float size_half_object = {
      .x = object->mesh.size.x / 2.0f,
      .y = object->mesh.size.z / 2.0f
    };

    struct clic3_vector2_float position_minimum_object = {
      .x = object->position.x - size_half_object.x,
      .y = object->position.z - size_half_object.y
    };

    struct clic3_vector2_float position_maximum_object = {
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
}

void player_poll(
  struct metil_player* player
) {}

void player_destroy(
  struct metil_player* player
) {
  free(player->data);

  metil_player_destroy(
    player
  );
}
