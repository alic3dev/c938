#ifndef __c938_audio_io_procs_io_proc_scene_gameplay_h
#define __c938_audio_io_procs_io_proc_scene_gameplay_h

#include <scenes/scene_gameplay/scene_gameplay.h>

#include <metil_audio/metil_audio_io_proc.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

#define c938_audio_io_proc_scene_gameplay_length_time_switch 0x0064
#define c938_audio_io_proc_scene_gameplay_length_time_life   0x03e8

float c938_audio_io_proc_scene_gameplay_frame_get(
  struct scene_gameplay_data* _Nonnull,
  unsigned long int,
  unsigned long int,
  unsigned long int
);

metil_audio_io_proc_macro_type(
  c938_audio_io_proc_scene_gameplay
);

#endif
