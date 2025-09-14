#include <player.h>

#include <input/controller.h>
#include <input/cursor.h>
#include <input/keycodes.h>
#include <input/map.h>

#include <math.h>

unsigned long int delta_time_jump_threshold = 250;

void player_initialize(
  struct player* player
) {
  player->position.x = 0.0f;
  player->position.y = 0.0f;
  player->position.z = 0.0f;

  player->speed_movement = 0.8f;
  player->speed_rotation = (
    player->speed_movement / 4.0f
  );

  player->velocity.x = 0.0f;
  player->velocity.y = 0.0f;
  player->velocity.z = 0.0f;

  player->objects = (void*)0;
  player->length_objects = 0;

  player->time_jump = 0;

  player->is_jumping = 0;
  player->is_jumping_secondary = 0;
}

void player_poll_input(
  struct player* player,
  unsigned long int time
) {
  float speed_original = player->speed_movement;

  unsigned long int delta_time_jump = time - player->time_jump;

  if (
    controller_state.available == 1 &&
    controller_state.trigger_left >= 0.1f &&
    controller_state.thumbstick_button_left == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      controller_state.trigger_left +
      1.0f
    );
  } else if (
    controller_state.available == 1 &&
    controller_state.trigger_left < 0.1f &&
    controller_state.thumbstick_button_left >= 0.1f
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      input_map_keydown[
        keycode_option_right
      ] == 1 ||
      input_map_keydown[
        keycode_control
      ] == 1
    )  && (
      input_map_keydown[
        keycode_shift_left
      ] == 0 &&
      input_map_keydown[
        keycode_shift_right
      ] == 0
    )
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      input_map_keydown[
        keycode_option_right
      ] == 0 &&
      input_map_keydown[
        keycode_control
      ] == 0
    ) && (
      input_map_keydown[
        keycode_shift_left
      ] == 1 ||
      input_map_keydown[
        keycode_shift_right
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
      input_delta_cursor.x / 50.0f *
      player->speed_rotation
    )
  );

  player->rotation.x = (
    player->rotation.x + (
      input_delta_cursor.y / 50.0f *
      player->speed_rotation
    )
  );

  if (controller_state.available == 1) {
    if (
      controller_state.input_axis_x_right >= 0.1f || 
      controller_state.input_axis_x_right <= -0.1f
    ) {
      player->rotation.y = (
        player->rotation.y + (
          controller_state.input_axis_x_right *
          player->speed_rotation
        )
      );
    }

    if (
      controller_state.thumbstick_axis_y_right >= 0.1f || 
      controller_state.thumbstick_axis_y_right <= -0.1f
    ) {
      player->rotation.x = (
        player->rotation.x + (
          -controller_state.thumbstick_axis_y_right *
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

  input_delta_cursor.x = 0;
  input_delta_cursor.y = 0;
  
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

  if (controller_state.available == 1) {
    movement.x = (
      (controller_state.thumbstick_axis_y_left * ratio_movement.x) +
      (controller_state.thumbstick_axis_x_left * ratio_movement_strafe.x)
    );

    movement.z = (
      (controller_state.thumbstick_axis_y_left * ratio_movement.y) +
      (controller_state.thumbstick_axis_x_left * ratio_movement_strafe.y)
    );
  }

  if (
    (input_map_keydown[
      keycode_e
    ] == 1 ||
    input_map_keydown[
      keycode_slash
    ] == 1) && (
      player->is_jumping == 0 ||
      (player->is_jumping_secondary == 0 && delta_time_jump >= delta_time_jump_threshold)
    )
  ) {
    player->velocity.y += speed_original / 1.25f;

    if (player->is_jumping == 0) {
      player->is_jumping = 1;
      player->time_jump = time;
    } else {
      player->is_jumping_secondary = 1;
    }
  }

  if (
    controller_state.available == 1 &&
    controller_state.trigger_right >= 0.1f
  ) {
    player->velocity.y -= controller_state.trigger_right;
  } else if (
    input_map_keydown[
      keycode_q
    ] == 1 ||
    input_map_keydown[
      keycode_period
    ] == 1
  ) {
    player->velocity.y -= 0.1f;
  }

  if (
    input_map_keydown[
      keycode_left_arrow
    ] == 1 ||
    input_map_keydown[
      keycode_right_arrow
    ] == 1 ||
    input_map_keydown[
      keycode_a
    ] == 1 ||
    input_map_keydown[
      keycode_d
    ] == 1  ||
    input_map_keydown[
      keycode_down_arrow
    ] == 1 || 
    input_map_keydown[
      keycode_up_arrow
    ] == 1 || 
    input_map_keydown[
      keycode_s
    ] == 1 ||
    input_map_keydown[
      keycode_w
    ] == 1
  ) {
    movement.x = (
      (
        input_map_keydown[
          keycode_up_arrow
        ] || input_map_keydown[
          keycode_w
        ]
      ) * ratio_movement.x +
      -(
        input_map_keydown[
          keycode_down_arrow
        ] || 
        input_map_keydown[
          keycode_s
        ]
      ) * ratio_movement.x +
      (
        input_map_keydown[
          keycode_right_arrow
        ] || input_map_keydown[
          keycode_d
        ]
      ) * ratio_movement_strafe.x +
      -(
        input_map_keydown[
          keycode_left_arrow
        ] || input_map_keydown[
          keycode_a
        ]
      ) * ratio_movement_strafe.x
    );

    movement.z = (
      (
        input_map_keydown[
          keycode_up_arrow
        ] || input_map_keydown[
          keycode_w
        ]
      ) * ratio_movement.y +
      -(
        input_map_keydown[
          keycode_down_arrow
        ] || input_map_keydown[
          keycode_s
        ]
      ) * ratio_movement.y +
      (
        input_map_keydown[
          keycode_right_arrow
        ] || 
        input_map_keydown[
          keycode_d
        ]
      ) * ratio_movement_strafe.y + 
      -(
        input_map_keydown[
          keycode_left_arrow
        ] || input_map_keydown[
          keycode_a
        ]
      ) * ratio_movement_strafe.y
    );
  }

  if (
    (input_map_keydown[
      keycode_space
    ] == 1 || (
      controller_state.available == 1 &&
      controller_state.button_cross >= 0.1f
    )) &&
    (
      player->is_jumping == 0 || 
      (player->is_jumping_secondary == 0 &&
      delta_time_jump >= delta_time_jump_threshold)
    )
  ) {
    player->velocity.y += speed_original / 1.25f;
    
    if (player->is_jumping == 0) {
      player->is_jumping = 1;
      player->time_jump = time;
    } else {
      player->is_jumping_secondary = 1;
    }
  }

  player->has_collided = 0;
  player->on_ground = 0;
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
    index_object < player->length_objects;
    ++index_object
  ) {
    if (
      position_updated.x >= player->objects[index_object]->position.x - 4 - player->objects[index_object]->mesh.size.x / 2.0f &&
      position_updated.x <= player->objects[index_object]->position.x + 4 + player->objects[index_object]->mesh.size.x / 2.0f &&
      position_updated.z >= player->objects[index_object]->position.z - 4 - player->objects[index_object]->mesh.size.z / 2.0f &&
      position_updated.z <= player->objects[index_object]->position.z + 4 + player->objects[index_object]->mesh.size.z / 2.0f  
    ) {
      if (
        position_updated.y >= player->objects[index_object]->position.y + player->objects[index_object]->mesh.size.y &&
        position_updated.y <= player->objects[index_object]->position.y + player->objects[index_object]->mesh.size.y + 4.0f
      ) {
        player->on_ground = index_object + 1;
        position_ground_y = player->objects[index_object]->position.y + player->objects[index_object]->mesh.size.y + 4.0f;
      } else if (
        position_updated.y >= player->objects[index_object]->position.y &&
        position_updated.y <= player->objects[index_object]->position.y + player->objects[index_object]->mesh.size.y
      ) {
        player->has_collided = index_object + 1;
      }
    }

    if (
      player->on_ground != 0 &&
      player->has_collided != 0
    ) {
      break;
    }
  }

  if (player->has_collided == 0) {
    player->position.x = position_updated.x;
    player->position.z = position_updated.z;
  }

  if (player->on_ground == 0) {
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
    player->time_jump = 0;
    player->is_jumping = 0;
    player->is_jumping_secondary = 0;
  }

  if (player->velocity.y < -2.0f) {
    player->velocity.y = -2.0f;
  }

  player->speed_movement = speed_original;
}

void player_poll(
  struct player* player
) {}

void player_destroy(
  struct player* player
) {}
