#include <audio/io_procs/io_proc_scene_gameplay.h>

#include <scenes/scene_gameplay/scene_gameplay.h>

unsigned int b = 100;
unsigned int d = 1000;

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

    unsigned long int v = (
      time_current -
      time_fired
    );

    float a = (
      0x00
    );

    if (
      v <=
      b
    ) {
      a = (
        (float)
        (
          (
            b -
            v
          ) /
          (
            (float)
            b /
            2.0f
          ) -
          1.0f
        )
      );
    } else {
      if (
        v >
        d
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

      a = (
        (float)
        (
          d -
          v
        ) /
        (
          (float)
          d /
          2.0f -          1.0f
        ) *
        0.5f
      );
    }

    if (
      (
        v %
        0x02
      ) ==
      0x00
    ) {
      a = (
        -a
      );
    }

    value = (
      value +
      a
    );

    index_projectile = (
      index_projectile +
      0x01
    );
  }

  if (
    value >
    1.0f
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
    -1.0f
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
