#include <mesh/mesh_building.h>

#include <mesh/mesh.h>

#include <clic3_vector.h>

#include <math.h>
#include <stdlib.h>

void mesh_building_initialize(
  struct mesh* mesh,
  float width,
  float height,
  float depth
) {
  mesh_initialize(mesh);

  struct clic3_vector3_float size_half = {
    .x = width / 2.0f,
    .y = height / 2.0f,
    .z = depth / 2.0f
  };

  mesh->size.x = width;
  mesh->size.y = height;
  mesh->size.z = depth;

  mesh->length_vertices = 8;
  mesh->length_indices = 36;

  mesh->indices = realloc(
    mesh->indices,
    sizeof(unsigned int) *
    mesh->length_indices
  );

  mesh->vertices = realloc(
    mesh->vertices,
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );

  //   6----7
  // 4/___5/|
  // |    | |
  // | 2__|_3
  // 0/___1/

  /* I think this might actually be impossible, or I'm just dumb ._.

   like, if i make each vertex seperate, then it's disjointed

   i'll figure it out

    0,1    1,1   

  0,0    1,0


    0,0    1,1

  1,1    0,0
  
  */

  mesh->vertices[0].x = -size_half.x;
  mesh->vertices[0].y = 0;
  mesh->vertices[0].z = -size_half.z;
  mesh->vertices[0].w = 1.0f;

  mesh->vertices[1].x = size_half.x;
  mesh->vertices[1].y = 0;
  mesh->vertices[1].z = -size_half.z;
  mesh->vertices[1].w = 1.0f;

  mesh->vertices[2].x = -size_half.x;
  mesh->vertices[2].y = 0;
  mesh->vertices[2].z = size_half.z;
  mesh->vertices[2].w = 1.0f;

  mesh->vertices[3].x = size_half.x;
  mesh->vertices[3].y = 0;
  mesh->vertices[3].z = size_half.z;
  mesh->vertices[3].w = 1.0f;

  mesh->vertices[4].x = -size_half.x;
  mesh->vertices[4].y = mesh->size.y;
  mesh->vertices[4].z = -size_half.z;
  mesh->vertices[4].w = 1.0f;

  mesh->vertices[5].x = size_half.x;
  mesh->vertices[5].y = mesh->size.y;
  mesh->vertices[5].z = -size_half.z;
  mesh->vertices[5].w = 1.0f;

  mesh->vertices[6].x = -size_half.x;
  mesh->vertices[6].y = mesh->size.y;
  mesh->vertices[6].z = size_half.z;
  mesh->vertices[6].w = 1.0f;

  mesh->vertices[7].x = size_half.x;
  mesh->vertices[7].y = mesh->size.y;
  mesh->vertices[7].z = size_half.z;
  mesh->vertices[7].w = 1.0f;

  // mesh->vertices[0].x = -size_half.x;
  // mesh->vertices[0].y = 0;
  // mesh->vertices[0].z = -size_half.z;
  // mesh->vertices[0].w = 1.0f;

  // mesh->vertices[1].x = size_half.x;
  // mesh->vertices[1].y = 0;
  // mesh->vertices[1].z = -size_half.z;
  // mesh->vertices[1].w = 1.0f;

  // mesh->vertices[2].x = -size_half.x;
  // mesh->vertices[2].y = 0;
  // mesh->vertices[2].z = size_half.z;
  // mesh->vertices[2].w = 1.0f;

  // mesh->vertices[3].x = -size_half.x;
  // mesh->vertices[3].y = 0;
  // mesh->vertices[3].z = size_half.z;
  // mesh->vertices[3].w = 1.0f;

  // mesh->vertices[4].x = size_half.x;
  // mesh->vertices[4].y = 0;
  // mesh->vertices[4].z = size_half.z;
  // mesh->vertices[4].w = 1.0f;

  // mesh->vertices[5].x = size_half.x;
  // mesh->vertices[5].y = 0;
  // mesh->vertices[5].z = -size_half.z;
  // mesh->vertices[5].w = 1.0f;

  // mesh->vertices[6].x = size_half.x;
  // mesh->vertices[6].y = 0;
  // mesh->vertices[6].z = -size_half.z;
  // mesh->vertices[6].w = 1.0f;

  // mesh->vertices[7].x = -size_half.x;
  // mesh->vertices[7].y = 0;
  // mesh->vertices[7].z = -size_half.z;
  // mesh->vertices[7].w = 1.0f;

  // mesh->vertices[8].x = -size_half.x;
  // mesh->vertices[8].y = mesh->size.y;
  // mesh->vertices[8].z = -size_half.z;
  // mesh->vertices[8].w = 1.0f;

  // mesh->vertices[9].x = -size_half.x;
  // mesh->vertices[9].y = mesh->size.y;
  // mesh->vertices[9].z = -size_half.z;
  // mesh->vertices[9].w = 1.0f;

  // mesh->vertices[10].x = size_half.x;
  // mesh->vertices[10].y = mesh->size.y;
  // mesh->vertices[10].z = -size_half.z;
  // mesh->vertices[10].w = 1.0f;

  // mesh->vertices[11].x = size_half.x;
  // mesh->vertices[11].y = 0;
  // mesh->vertices[11].z = -size_half.z;
  // mesh->vertices[11].w = 1.0f;

  // mesh->vertices[12].x = size_half.x;
  // mesh->vertices[12].y = 0;
  // mesh->vertices[12].z = -size_half.z;
  // mesh->vertices[12].w = 1.0f;

  // mesh->vertices[13].x = size_half.x;
  // mesh->vertices[13].y = 0;
  // mesh->vertices[13].z = size_half.z;
  // mesh->vertices[13].w = 1.0f;

  // mesh->vertices[14].x = size_half.x;
  // mesh->vertices[14].y = mesh->size.y;
  // mesh->vertices[14].z = -size_half.z;
  // mesh->vertices[14].w = 1.0f;

  // mesh->vertices[15].x = size_half.x;
  // mesh->vertices[15].y = mesh->size.y;
  // mesh->vertices[15].z = -size_half.z;
  // mesh->vertices[15].w = 1.0f;

  // mesh->vertices[16].x = size_half.x;
  // mesh->vertices[16].y = mesh->size.y;
  // mesh->vertices[16].z = size_half.z;
  // mesh->vertices[16].w = 1.0f;

  // mesh->vertices[17].x = size_half.x;
  // mesh->vertices[17].y = 0;
  // mesh->vertices[17].z = size_half.z;
  // mesh->vertices[17].w = 1.0f;

  // mesh->vertices[18].x = size_half.x;
  // mesh->vertices[18].y = 0;
  // mesh->vertices[18].z = size_half.z;
  // mesh->vertices[18].w = 1.0f;

  // mesh->vertices[19].x = -size_half.x;
  // mesh->vertices[19].y = 0;
  // mesh->vertices[19].z = size_half.z;
  // mesh->vertices[19].w = 1.0f;

  // mesh->vertices[20].x = size_half.x;
  // mesh->vertices[20].y = mesh->size.y;
  // mesh->vertices[20].z = size_half.z;
  // mesh->vertices[20].w = 1.0f;

  // mesh->vertices[21].x = size_half.x;
  // mesh->vertices[21].y = mesh->size.y;
  // mesh->vertices[21].z = size_half.z;
  // mesh->vertices[21].w = 1.0f;

  // mesh->vertices[22].x = -size_half.x;
  // mesh->vertices[22].y = mesh->size.y;
  // mesh->vertices[22].z = size_half.z;
  // mesh->vertices[22].w = 1.0f;

  // mesh->vertices[23].x = -size_half.x;
  // mesh->vertices[23].y = 0;
  // mesh->vertices[23].z = size_half.z;
  // mesh->vertices[23].w = 1.0f;

  // mesh->vertices[24].x = -size_half.x;
  // mesh->vertices[24].y = 0;
  // mesh->vertices[24].z = size_half.z;
  // mesh->vertices[24].w = 1.0f;

  // mesh->vertices[25].x = -size_half.x;
  // mesh->vertices[25].y = 0;
  // mesh->vertices[25].z = -size_half.z;
  // mesh->vertices[25].w = 1.0f;

  // mesh->vertices[26].x = -size_half.x;
  // mesh->vertices[26].y = mesh->size.y;
  // mesh->vertices[26].z = -size_half.z;
  // mesh->vertices[26].w = 1.0f;

  // mesh->vertices[27].x = -size_half.x;
  // mesh->vertices[27].y = mesh->size.y;
  // mesh->vertices[27].z = -size_half.z;
  // mesh->vertices[27].w = 1.0f;

  // mesh->vertices[28].x = -size_half.x;
  // mesh->vertices[28].y = 0;
  // mesh->vertices[28].z = size_half.z;
  // mesh->vertices[28].w = 1.0f;

  // mesh->vertices[29].x = -size_half.x;
  // mesh->vertices[29].y = mesh->size.y;
  // mesh->vertices[29].z = size_half.z;
  // mesh->vertices[29].w = 1.0f;

  // mesh->vertices[30].x = -size_half.x;
  // mesh->vertices[30].y = mesh->size.y;
  // mesh->vertices[30].z = size_half.z;
  // mesh->vertices[30].w = 1.0f;

  // mesh->vertices[31].x = -size_half.x;
  // mesh->vertices[31].y = mesh->size.y;
  // mesh->vertices[31].z = -size_half.z;
  // mesh->vertices[31].w = 1.0f;

  // mesh->vertices[32].x = size_half.x;
  // mesh->vertices[32].y = mesh->size.y;
  // mesh->vertices[32].z = -size_half.z;
  // mesh->vertices[32].w = 1.0f;

  // mesh->vertices[33].x = size_half.x;
  // mesh->vertices[33].y = mesh->size.y;
  // mesh->vertices[33].z = -size_half.z;
  // mesh->vertices[33].w = 1.0f;

  // mesh->vertices[34].x = -size_half.x;
  // mesh->vertices[34].y = mesh->size.y;
  // mesh->vertices[34].z = size_half.z;
  // mesh->vertices[34].w = 1.0f;

  // mesh->vertices[35].x = size_half.x;
  // mesh->vertices[35].y = mesh->size.y;
  // mesh->vertices[35].z = size_half.z;
  // mesh->vertices[35].w = 1.0f;

  // for (
  //   unsigned char index = 0;
  //   index < mesh->length_indices;
  //   ++index
  // ) {
  //   mesh->indices[
  //     index
  //   ] = index;
  // }

  mesh->indices[0] = 0;
  mesh->indices[1] = 1;
  mesh->indices[2] = 2;

  mesh->indices[3] = 2;
  mesh->indices[4] = 3;
  mesh->indices[5] = 1;

  mesh->indices[6] = 1;
  mesh->indices[7] = 0;
  mesh->indices[8] = 4;

  mesh->indices[9] = 4;
  mesh->indices[10] = 5;
  mesh->indices[11] = 1;

  mesh->indices[12] = 1;
  mesh->indices[13] = 3;
  mesh->indices[14] = 5;

  mesh->indices[15] = 5;
  mesh->indices[16] = 7;
  mesh->indices[17] = 3;

  mesh->indices[18] = 3;
  mesh->indices[19] = 2;
  mesh->indices[20] = 7;

  mesh->indices[21] = 7;
  mesh->indices[22] = 6;
  mesh->indices[23] = 2;

  mesh->indices[24] = 2;
  mesh->indices[25] = 0;
  mesh->indices[26] = 4;

  mesh->indices[27] = 4;
  mesh->indices[28] = 2;
  mesh->indices[29] = 6;

  mesh->indices[30] = 6;
  mesh->indices[31] = 4;
  mesh->indices[32] = 5;

  mesh->indices[33] = 5;
  mesh->indices[34] = 6;
  mesh->indices[35] = 7;
}
