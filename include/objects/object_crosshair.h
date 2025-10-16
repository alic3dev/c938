#ifndef __c938_objects_object_crosshair_h
#define __c938_objects_object_crosshair_h

#include <metil_object.h>

#include <Metal/MTLDevice.h>

void object_crosshair_initialize(
  struct metil_object*,
  id<MTLDevice>
);

#endif