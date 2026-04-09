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
          2.0f -
          1.0f
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

#if target_os_ios
int c938_audio_io_proc_scene_gameplay(
  unsigned char silence,
  const AudioTimeStamp* timestamp,
  AVAudioFrameCount frame_count,
  AudioBufferList* output_data,
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
    unsigned int index_frame = (
      0x00
    );
    (
      index_frame <
      frame_count
    );
    ++index_frame
  ) {
    for (
      unsigned long int index_buffer = (
        0x00
      );
      (
        index_buffer <
        output_data->mNumberBuffers
      );
      ++index_buffer
    ) {
      AudioBuffer audio_buffer_current = (
        output_data->mBuffers[
          index_buffer
        ]
      );
      
      float* buffer_out = (
        audio_buffer_current.mData
      );

      buffer_out[
        index_frame
      ] = (
        c938_audio_io_proc_scene_gameplay_frame_get(
          scene_gameplay_data,
          metil_scene_gameplay->time,
          index_buffer,
          index_frame
        )
      );
    }
  }
  
  return (
    0x00
  );
}
#else
OSStatus c938_audio_io_proc_scene_gameplay(
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
    unsigned long int index_buffer = (
      0x00
    );
    (
      index_buffer <
      list_buffer_audio_out->mNumberBuffers
    );
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      list_buffer_audio_out->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = (
      audio_buffer_current.mData
    );

    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      data_length_float
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );

    for (
      unsigned long int index_buffer_out = (
        0x00
      );
      (
        index_buffer_out <
        size_buffer_out
      );
      ++index_buffer_out
    ) {
      unsigned long int channel = (
        index_buffer_out %
        count_channel_out
      );

      buffer_out[
        index_buffer_out
      ] = (
        c938_audio_io_proc_scene_gameplay_frame_get(
          scene_gameplay_data,
          metil_scene_gameplay->time,
          channel,
          index_buffer_out
        )
      );
    }
  }

  return (
    0x00
  );
}
#endif
