#include <player.h>

#include <player_data.h>

#include <metil_input/controller.h>
#include <metil_input/cursor.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>
#include <metil_player.h>

#include <math.h>

unsigned long int delta_time_jump_threshold = 250;

void player_poll_input(
  struct metil_player* player,
  unsigned long int time
) {
  struct player_data* player_data = (
    (struct player_data*) player->data
  );

  float speed_original = player->speed_movement;

  unsigned long int delta_time_jump = time - player_data->time_jump;

  if (
    metil_controller_state.available == 1 &&
    metil_controller_state.trigger_left >= 0.1f &&
    metil_controller_state.thumbstick_button_left == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      metil_controller_state.trigger_left +
      1.0f
    );
  } else if (
    metil_controller_state.available == 1 &&
    metil_controller_state.trigger_left < 0.1f &&
    metil_controller_state.thumbstick_button_left >= 0.1f
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

  player->rotation.y = (
    player->rotation.y + (
      metil_input_delta_cursor.x / 50.0f *
      player->speed_rotation
    )
  );

  player->rotation.x = (
    player->rotation.x + (
      metil_input_delta_cursor.y / 50.0f *
      player->speed_rotation
    )
  );

  if (metil_controller_state.available == 1) {
    if (
      metil_controller_state.input_axis_x_right >= 0.1f || 
      metil_controller_state.input_axis_x_right <= -0.1f
    ) {
      player->rotation.y = (
        player->rotation.y + (
          metil_controller_state.input_axis_x_right *
          player->speed_rotation
        )
      );
    }

    if (
      metil_controller_state.thumbstick_axis_y_right >= 0.1f || 
      metil_controller_state.thumbstick_axis_y_right <= -0.1f
    ) {
      player->rotation.x = (
        player->rotation.x + (
          -metil_controller_state.thumbstick_axis_y_right *
          player->speed_rotation
        )
      );
    }
  }

  if (
    player->rotation.x > M_PI / 2.0f
  ) {
    player->rotation.x = M_PI / 2.0f;
  } else if (
    player->rotation.x < -M_PI / 2.0f
  ) {
    player->rotation.x = -M_PI / 2.0f;
  }

  metil_input_delta_cursor.x = 0;
  metil_input_delta_cursor.y = 0;
  
  float ratio_axis = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  ) / (M_PI * 2.0f);

  if (ratio_axis >= 0.0f) {
    if (
      ratio_axis <= 0.25f
    ) {
      ratio_movement.y = (0.25f - ratio_axis) / 0.25f;
      ratio_movement.x = -(ratio_axis / 0.25f);
    } else if (
      ratio_axis >= 0.25f &&
      ratio_axis <= 0.5f 
    ) {
      ratio_axis = ratio_axis - 0.25f;

      ratio_movement.y = -(ratio_axis / 0.25f);
      ratio_movement.x = -(0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis >= 0.5f &&
      ratio_axis <= 0.75f 
    ) {
      ratio_axis = ratio_axis - 0.5f;

      ratio_movement.y = -(0.25f - ratio_axis) / 0.25f;
      ratio_movement.x = (ratio_axis / 0.25f);
    } else {
      ratio_axis = ratio_axis - 0.75f;

      ratio_movement.y = (ratio_axis / 0.25f);
      ratio_movement.x = (0.25f - ratio_axis) / 0.25f;
    }
  } else {
    if (
      ratio_axis >= -0.25f
    ) {
      ratio_movement.y = (-0.25f - ratio_axis) / -0.25f;
      ratio_movement.x = -(ratio_axis / 0.25f);
    } else if (
      ratio_axis <= -0.25f &&
      ratio_axis >= -0.5f
    ) {
      ratio_axis = ratio_axis + 0.25f;

      ratio_movement.y = -(ratio_axis / -0.25f);
      ratio_movement.x = -(-0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis <= -0.5f &&
      ratio_axis >= -0.75f 
    ) {
      ratio_axis = ratio_axis + 0.5f;

      ratio_movement.y = -(-0.25f - ratio_axis) / -0.25f;
      ratio_movement.x = (ratio_axis / 0.25f);
    } else {
      ratio_axis = ratio_axis + 0.75f;

      ratio_movement.y = (ratio_axis / -0.25f);
      ratio_movement.x = (-0.25f - ratio_axis) / 0.25f;
    }
  }

  ratio_axis = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  ) / (M_PI * 2.0f);

  if (ratio_axis >= 0.0f) {
    if (
      ratio_axis <= 0.25f
    ) {
      ratio_movement_strafe.y = -(ratio_axis / 0.25f);
      ratio_movement_strafe.x = -(0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis >= 0.25f &&
      ratio_axis <= 0.5f
    ) {
      ratio_axis = ratio_axis - 0.25f;

      ratio_movement_strafe.y = -(0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = (ratio_axis / 0.25f);
    } else if (
      ratio_axis >= 0.5f &&
      ratio_axis <= 0.75f
    ) {
      ratio_axis = ratio_axis - 0.5f;

      ratio_movement_strafe.y = (ratio_axis / 0.25f);
      ratio_movement_strafe.x = (0.25f - ratio_axis) / 0.25f;
    } else {
      ratio_axis = ratio_axis - 0.75f;

      ratio_movement_strafe.y = (0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = -(ratio_axis / 0.25f);
    }
  } else {
    if (
      ratio_axis >= -0.25f
    ) {
      ratio_movement_strafe.y = -(ratio_axis / 0.25f);
      ratio_movement_strafe.x = -(-0.25f - ratio_axis) / -0.25f;
    } else if (
      ratio_axis <= -0.25f &&
      ratio_axis >= -0.5f
    ) {
      ratio_axis = ratio_axis + 0.25f;

      ratio_movement_strafe.y = -(-0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = (ratio_axis / -0.25f);
    } else if (
      ratio_axis <= -0.5f &&
      ratio_axis >= -0.75f
    ) {
      ratio_axis = ratio_axis + 0.5f;

      ratio_movement_strafe.y = (ratio_axis / 0.25f);
      ratio_movement_strafe.x = (-0.25f - ratio_axis) / -0.25f;
    } else {
      ratio_axis = ratio_axis + 0.75f;

      ratio_movement_strafe.y = (-0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = -(ratio_axis / -0.25f);
    }
  }

  if (metil_controller_state.available == 1) {
    movement.x = (
      (metil_controller_state.thumbstick_axis_y_left * ratio_movement.x) +
      (metil_controller_state.thumbstick_axis_x_left * ratio_movement_strafe.x)
    );

    movement.z = (
      (metil_controller_state.thumbstick_axis_y_left * ratio_movement.y) +
      (metil_controller_state.thumbstick_axis_x_left * ratio_movement_strafe.y)
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
    player->velocity.y += speed_original / 1.25f;

    if (player_data->is_jumping == 0) {
      player_data->is_jumping = 1;
      player_data->time_jump = time;
    } else {
      player_data->is_jumping_secondary = 1;
    }
  }

  if (
    metil_controller_state.available == 1 &&
    metil_controller_state.trigger_right >= 0.1f
  ) {
    player->velocity.y -= metil_controller_state.trigger_right;
  } else if (
    metil_input_map_keydown[
      metil_keycode_q
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_period
    ] == 1
  ) {
    player->velocity.y -= 0.1f;
  }

  if (
    metil_input_map_keydown[
      metil_keycode_left_arrow
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_right_arrow
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_a
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_d
    ] == 1  ||
    metil_input_map_keydown[
      metil_keycode_down_arrow
    ] == 1 || 
    metil_input_map_keydown[
      metil_keycode_up_arrow
    ] == 1 || 
    metil_input_map_keydown[
      metil_keycode_s
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_w
    ] == 1
  ) {
    movement.x = (
      (
        metil_input_map_keydown[
          metil_keycode_up_arrow
        ] || metil_input_map_keydown[
          metil_keycode_w
        ]
      ) * ratio_movement.x +
      -(
        metil_input_map_keydown[
          metil_keycode_down_arrow
        ] || 
        metil_input_map_keydown[
          metil_keycode_s
        ]
      ) * ratio_movement.x +
      (
        metil_input_map_keydown[
          metil_keycode_right_arrow
        ] || metil_input_map_keydown[
          metil_keycode_d
        ]
      ) * ratio_movement_strafe.x +
      -(
        metil_input_map_keydown[
          metil_keycode_left_arrow
        ] || metil_input_map_keydown[
          metil_keycode_a
        ]
      ) * ratio_movement_strafe.x
    );

    movement.z = (
      (
        metil_input_map_keydown[
          metil_keycode_up_arrow
        ] || metil_input_map_keydown[
          metil_keycode_w
        ]
      ) * ratio_movement.y +
      -(
        metil_input_map_keydown[
          metil_keycode_down_arrow
        ] || metil_input_map_keydown[
          metil_keycode_s
        ]
      ) * ratio_movement.y +
      (
        metil_input_map_keydown[
          metil_keycode_right_arrow
        ] || 
        metil_input_map_keydown[
          metil_keycode_d
        ]
      ) * ratio_movement_strafe.y + 
      -(
        metil_input_map_keydown[
          metil_keycode_left_arrow
        ] || metil_input_map_keydown[
          metil_keycode_a
        ]
      ) * ratio_movement_strafe.y
    );
  }

  if (
    (metil_input_map_keydown[
      metil_keycode_space
    ] == 1 || (
      metil_controller_state.available == 1 &&
      metil_controller_state.button_cross >= 0.1f
    )) &&
    (
      player_data->is_jumping == 0 || 
      (player_data->is_jumping_secondary == 0 &&
      delta_time_jump >= delta_time_jump_threshold)
    )
  ) {
    player->velocity.y += speed_original / 1.25f;
    
    if (player_data->is_jumping == 0) {
      player_data->is_jumping = 1;
      player_data->time_jump = time;
    } else {
      player_data->is_jumping_secondary = 1;
    }
  }

  player_data->has_collided = 0;
  player_data->on_ground = 0;
  float position_ground_y = 0.0f;

  float addition_y = (
    movement.y *
    player->speed_movement
  ) + player->velocity.y;

  struct clic3_vector3_float position_updated = {
    .x = (
      player->position.x - (
        movement.x *
        player->speed_movement
      )
    ),
    .y = (
      player->position.y + 
      addition_y
    ),
    .z = (
      player->position.z - (
        movement.z *
        player->speed_movement
      )
    )
  };

  for (
    unsigned int index_object = 0;
    index_object < player_data->length_objects;
    ++index_object
  ) {
    if (
      position_updated.x >= player_data->objects[index_object]->position.x - 4 - player_data->objects[index_object]->mesh.size.x / 2.0f &&
      position_updated.x <= player_data->objects[index_object]->position.x + 4 + player_data->objects[index_object]->mesh.size.x / 2.0f &&
      position_updated.z >= player_data->objects[index_object]->position.z - 4 - player_data->objects[index_object]->mesh.size.z / 2.0f &&
      position_updated.z <= player_data->objects[index_object]->position.z + 4 + player_data->objects[index_object]->mesh.size.z / 2.0f  
    ) {
      if (
        position_updated.y >= player_data->objects[index_object]->position.y + player_data->objects[index_object]->mesh.size.y &&
        position_updated.y <= player_data->objects[index_object]->position.y + player_data->objects[index_object]->mesh.size.y + 4.0f
      ) {
        player_data->on_ground = index_object + 1;
        position_ground_y = player_data->objects[index_object]->position.y + player_data->objects[index_object]->mesh.size.y + 4.0f;
      } else if (
        position_updated.y >= player_data->objects[index_object]->position.y &&
        position_updated.y <= player_data->objects[index_object]->position.y + player_data->objects[index_object]->mesh.size.y
      ) {
        player_data->has_collided = index_object + 1;
      }
    }

    if (
      player_data->on_ground != 0 &&
      player_data->has_collided != 0
    ) {
      break;
    }
  }

  if (player_data->has_collided == 0) {
    player->position.x = position_updated.x;
    player->position.z = position_updated.z;
  }

  if (player_data->on_ground == 0) {
    player->position.y = position_updated.y;

    if (player->velocity.y > -1.0f) {
      player->velocity.y = (
        player->velocity.y - (
          speed_original / 50.0f
        )
      );

      if (player->velocity.y < -1.0f) {
        player->velocity.y = -1.0f;
      }
    }
  } else {
    player->position.y = position_ground_y;
    player->velocity.y = 0.0f;
    player_data->time_jump = 0;
    player_data->is_jumping = 0;
    player_data->is_jumping_secondary = 0;
  }

  if (player->velocity.y < -2.0f) {
    player->velocity.y = -2.0f;
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
