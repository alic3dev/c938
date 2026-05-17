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
    0x0f,
    (
      0x0f *
      0x02
    )
  );
  
  for (
    unsigned int index_vertex = (
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
}

/*

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

