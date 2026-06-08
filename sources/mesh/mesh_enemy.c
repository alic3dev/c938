#include <metil_mesh/metil_mesh.h>

#include <metil_mesh/metil_mesh_sphere.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_vector.h>

void mesh_enemy_initialize(
  struct metil_mesh* mesh,
  float offset
) {
  metil_mesh_sphere_initialize(
    mesh,
    0x1e,
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x1e
      ),
     .y = (
       0x1e
      )

    }
  );

  mesh->length_indices = (
    0x64
  );

  clic3_memory_reallocate_raw(
    &mesh->indices,
    (
      sizeof(
        unsigned int
      ) *
      mesh->length_indices
    )
  );

  for (
    unsigned char index_index = (
      0x00
    );
    (
      index_index <
      mesh->length_indices
    );
    ++index_index
  ) {
    mesh->indices[
      index_index
    ] = (
      (unsigned int)
      math_c_absolute_float(
        index_index *
        index_index +
        index_index *
        0x03 +
        0x01 +
        index_index *
        offset +
        offset
      ) %
      mesh->length_vertices
    );
  }
}
