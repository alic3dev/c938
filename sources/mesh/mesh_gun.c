#include <mesh/mesh_gun.h>

#include <enumerations/c938_handedness.h>

void mesh_gun_initialize(
  struct metil_mesh* c938_mesh_gun,
  unsigned char handedness
) {
  float inverter_x;

  if (
    handedness !=
    c938_handedness_left
  ) {
    inverter_x = -(
      0x01
    );
  } else {
    inverter_x = (
      0x01
    );
  }

  metil_mesh_initialize_with_lengths(
    c938_mesh_gun,
    0x04,
    0x08
  );
  
  unsigned short int index_vertex = (
    0x00
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].x = (
    0.5f
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].y = -(
    0x02
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].z = -(
    0x02
  );
  
  index_vertex = (
    index_vertex +
    0x01
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].x = (
    0.5f
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].y = -(
    0x02
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].z = -(
    0x01
  );
  
  index_vertex = (
    index_vertex +
    0x01
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].x = -(
    0.5f
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].y = -(
    0x02
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].z = -(
    0x01
  );
  
  index_vertex = (
    index_vertex +
    0x01
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].x = -(
    0.5f
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].y = -(
    0x02
  );
  
  c938_mesh_gun->vertices[
    index_vertex
  ].z = -(
    0x02
  );
  
  index_vertex = (
    index_vertex +
    0x01
  );
  
  for (
    index_vertex = (
      0x00
    );
    (
      index_vertex <
      c938_mesh_gun->length_vertices
    );
    ++index_vertex
  ) {
    c938_mesh_gun->vertices[
      index_vertex
    ].x = (
      c938_mesh_gun->vertices[
        index_vertex
      ].x *
      inverter_x
    );
    
    c938_mesh_gun->vertices[
      index_vertex
    ].w = (
      0x01
    );
  }
  
  c938_mesh_gun->indices[
    0x00
  ] = (
    0x00
  );
  
  c938_mesh_gun->indices[
    0x01
  ] = (
    0x01
  );
  
  c938_mesh_gun->indices[
    0x02
  ] = (
    0x01
  );
  
  c938_mesh_gun->indices[
    0x03
  ] = (
    0x02
  );
  
  c938_mesh_gun->indices[
    0x04
  ] = (
    0x02
  );
  
  c938_mesh_gun->indices[
    0x05
  ] = (
    0x03
  );
  
  c938_mesh_gun->indices[
    0x06
  ] = (
    0x03
  );
  
  c938_mesh_gun->indices[
    0x07
  ] = (
    0x00
  );
}

/*
  
  2 1 0 1 2
2
1 : ____|_
0 | . . . o
1 |_}  |_\
2
  


  _|______:__.
 |_^__,:__ _|o/
 |_||(_/ | |\
|:_|/     \_/
  
  
            .          .
       *      .   *    .  /
           ^     / .  .
        .   \.\ / /      .
       _    __/__   .
          /.|. /|  .
         / _  / /
       / _  ///|\
     //    / /_\./
    _|__|_//|
   |  []  |/(|
    |__  |/|/
    |___ |/|
    |____|\/




      .__|:|_.
      |||(*)||
       \_____/
       |\__/|
        \___/
        \___/
        
        gun
*/

/*

    .
   . . .
  .   .
  
  
   .. 
   ===|o
  /   \
   
*/

