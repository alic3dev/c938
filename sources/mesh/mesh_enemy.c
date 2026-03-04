#include <metil_mesh/metil_mesh.h>

#include <metil_mesh/metil_mesh_box.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void mesh_enemy_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_box_initialize(
    mesh,
    (struct math_c_vector3_float) {
      .x = 30.0f,
      .y = 30.0f,
      .z = 30.0f
    }
  );

  mesh->length_indices = (
    24
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
  
  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
  mesh->indices[2] = 1;
  mesh->indices[3] = 2;
  mesh->indices[4] = 2;
  mesh->indices[5] = 3;
  mesh->indices[6] = 3;
  mesh->indices[7] = 0;

  mesh->indices[8] = 4;
  mesh->indices[9] = 5;
  mesh->indices[10] = 5;
  mesh->indices[11] = 6;
  mesh->indices[12] = 6;
  mesh->indices[13] = 7;
  mesh->indices[14] = 7;
  mesh->indices[15] = 4;

  mesh->indices[16] = 0;
  mesh->indices[17] = 4;
  mesh->indices[18] = 1;
  mesh->indices[19] = 5;
  mesh->indices[20] = 2;
  mesh->indices[21] = 6;
  mesh->indices[22] = 3;
  mesh->indices[23] = 7;
}
