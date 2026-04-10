#ifndef __c938_audio_io_procs_io_proc_scene_gameplay_h
#define __c938_audio_io_procs_io_proc_scene_gameplay_h

#include <scenes/scene_gameplay/scene_gameplay.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

#define c938_audio_io_proc_scene_gameplay_length_time_switch 0x0064
#define c938_audio_io_proc_scene_gameplay_length_time_life   0x03e8

float c938_audio_io_proc_scene_gameplay_frame_get(
  struct scene_gameplay_data*,
  unsigned long int,
  unsigned long int,
  unsigned long int
);

#if target_os_ios
int c938_audio_io_proc_scene_gameplay(
  unsigned char,
  const AudioTimeStamp*,
  unsigned int,
  AudioBufferList*,
  void*
);
#else
OSStatus c938_audio_io_proc_scene_gameplay(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);
#endif

#endif

