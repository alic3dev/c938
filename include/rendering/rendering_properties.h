#ifndef __rendering_properties_h
#define __rendering_properties_h

#include <rendering/camera/camera.h>

#include <pthread.h>

static const unsigned int count_max_frames = 5;
static const unsigned int length_buffers_visibility = count_max_frames + 1;

struct rendering_properties {
  struct camera camera;

  unsigned int frame;
  signed char count_completed_frames;
  pthread_mutex_t mutex_frame;

  float brightness;
  float brightness_text;
};

void rendering_properties_initialize(
  struct rendering_properties*
);

void rendering_properties_destory(
  struct rendering_properties*
);

#endif
