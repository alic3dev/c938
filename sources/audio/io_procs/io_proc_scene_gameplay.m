#include <audio/io_procs/io_proc_scene_gameplay.h>

#include <data/data_length.h>
#include <scenes/scene_gameplay/scene_gameplay.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

float c938_audio_io_proc_scene_gameplay_frame_get(
  struct scene_gameplay_data* scene_gameplay_data,
  unsigned long int time_current,
  unsigned long int channel,
  unsigned long int frame
) {
  float value = (
    0x00
  );

  for (
    unsigned int index_projectile = (
      0x00
    );
    (
      index_projectile <
      scene_gameplay_data->length_projectiles
    );
  ) {
    unsigned long int time_fired = (
      scene_gameplay_data->fired_projectiles[
        index_projectile
      ]
    );

    unsigned long int time_alive = (
      time_current -
      time_fired
    );

    float value_additive = (
      0x00
    );

    if (
      time_alive <=
      c938_audio_io_proc_scene_gameplay_length_time_switch
    ) {
      value_additive = (
        (float)
        (
          (
            c938_audio_io_proc_scene_gameplay_length_time_switch -
            time_alive
          ) /
          (
            (float)
            c938_audio_io_proc_scene_gameplay_length_time_switch /
            2.0f
          ) -
          1.0f
        )
      );
    } else {
      if (
        time_alive >
        c938_audio_io_proc_scene_gameplay_length_time_life
      ) {
        for (
          unsigned int index_projectile_shift = (
            index_projectile
          );
          (
            index_projectile_shift <
            (
              scene_gameplay_data->length_projectiles -
              0x01
            )
          );
          ++index_projectile_shift
        ) {
          scene_gameplay_data->fired_projectiles[
            index_projectile_shift
          ] = (
            scene_gameplay_data->fired_projectiles[
              index_projectile_shift +
              0x01
            ]
          );
        }

        scene_gameplay_data->length_projectiles = (
          scene_gameplay_data->length_projectiles -
          0x01
        );

        continue;
      }

      value_additive = (
        (float)
        (
          c938_audio_io_proc_scene_gameplay_length_time_life -
          time_alive
        ) /
        (
          (float)
          c938_audio_io_proc_scene_gameplay_length_time_life /
          2.0f -
          1.0f
        ) *
        0.5f
      );
    }

    if (
      (
        time_alive %
        0x02
      ) ==
      0x00
    ) {
      value_additive = (
        -value_additive
      );
    }

    value = (
      value +
      value_additive
    );

    index_projectile = (
      index_projectile +
      0x01
    );
  }

  if (
    value >
    0x01
  ) {
    value = (
      value -
      (
        (float)
        (
          (unsigned long int)
          value
        )
      )
    );
  } else if (
    value <
    -0x01
  ) {
    value = (
      value +
      (
        (float)
        (
          (unsigned long int)
          -value
        )
      )
    );
  }

  return (
    value
  );
}

metil_audio_io_proc_macro_definition(
  c938_audio_io_proc_scene_gameplay
) {
  metil_audio_io_proc_macro_definition_initializer

  struct metil_scene_controller* metil_scene_controller
= (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  struct scene_gameplay_data* scene_gameplay_data = (
    metil_scene->data
  );
  metil_audio_io_proc_macro_definition_frame_loop {
    metil_audio_io_proc_macro_definition_index_channel

    metil_audio_io_proc_macro_definition_frame_set(
      c938_audio_io_proc_scene_gameplay_frame_get(
        scene_gameplay_data,
        metil_scene->time,
        index_channel,
        index_frame
      )
    )      }

  metil_audio_io_proc_macro_definition_return
}
