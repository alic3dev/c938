#include <rendering/rendering_properties.h>

#include <configuration/configuration_rendering_properties.h>
#include <rendering/camera/camera.h>

#include <pthread.h>

void rendering_properties_initialize(
  struct rendering_properties* rendering_properties
) {
  pthread_mutex_init(
    &rendering_properties->mutex_frame,
    (void*)0
  );

  rendering_properties->count_completed_frames = (
    count_max_frames
  );

  camera_initialize(
    &rendering_properties->camera
  );

  rendering_properties->brightness = configuration_default_rendering_properties_brightness;
  rendering_properties->brightness_text = configuration_default_rendering_properties_brightness_text;
}

void rendering_properties_destory(
  struct rendering_properties* rendering_properties
) {
  pthread_mutex_destroy(
    &rendering_properties->mutex_frame
  );
}
