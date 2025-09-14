#ifndef __audio_audio_h
#define __audio_audio_h

#include <cer0_audio_output.h>

#include <CoreAudio/CoreAudio.h>

struct audio_data;

extern struct cer0_audio_output audio_output;
extern struct audio_data audio_data;

struct audio_data {
  cer0_audio_output_io_proc* io_procs;
  unsigned char length_io_procs;

  float volume;

  unsigned char muted;
};

void audio_initialize();

void audio_io_proc_add(
  cer0_audio_output_io_proc
);

unsigned char audio_io_proc_remove(
  cer0_audio_output_io_proc
);

void audio_destroy();

OSStatus audio_output_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);

#endif
