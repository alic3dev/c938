#include <object.h>

#include <mesh/mesh.h>

void object_destroy(
  struct object* object
) {
  mesh_destroy(&object->mesh);
}
