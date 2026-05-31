#include <mesh/mesh_gun.h>

#include <enumerations/c938_handedness.h>

#include <metil_mesh/metil_mesh.h>

void mesh_gun_initialize(
  struct metil_mesh* mesh_gun,
  unsigned char handedness
) {
  metil_mesh_initialize_with_lengths(
    mesh_gun,
    0x64,
    0x27c
  );

  mesh_gun->size.x = (
    0.000000f
  );

  mesh_gun->size.y = (
    0.000000f
  );

  mesh_gun->size.z = (
    0.000000f
  );

  mesh_gun->vertices[
    0x00
  ].x = (
    1.997070f
  );

  mesh_gun->vertices[
    0x00
  ].y = (
    0.000000f
  );

  mesh_gun->vertices[
    0x00
  ].z = (
    -0.503822f
  );

  mesh_gun->vertices[
    0x00
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x01
  ].x = (
    1.992789f
  );

  mesh_gun->vertices[
    0x01
  ].y = (
    0.000000f
  );

  mesh_gun->vertices[
    0x01
  ].z = (
    0.510772f
  );

  mesh_gun->vertices[
    0x01
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x02
  ].x = (
    0.965872f
  );

  mesh_gun->vertices[
    0x02
  ].y = (
    0.000000f
  );

  mesh_gun->vertices[
    0x02
  ].z = (
    0.506438f
  );

  mesh_gun->vertices[
    0x02
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x03
  ].x = (
    0.970188f
  );

  mesh_gun->vertices[
    0x03
  ].y = (
    0.000000f
  );

  mesh_gun->vertices[
    0x03
  ].z = (
    -0.516371f
  );

  mesh_gun->vertices[
    0x03
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x04
  ].x = (
    1.039590f
  );

  mesh_gun->vertices[
    0x04
  ].y = (
    0.536250f
  );

  mesh_gun->vertices[
    0x04
  ].z = (
    -0.517094f
  );

  mesh_gun->vertices[
    0x04
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x05
  ].x = (
    1.954063f
  );

  mesh_gun->vertices[
    0x05
  ].y = (
    0.536250f
  );

  mesh_gun->vertices[
    0x05
  ].z = (
    -0.526620f
  );

  mesh_gun->vertices[
    0x05
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x06
  ].x = (
    1.971125f
  );

  mesh_gun->vertices[
    0x06
  ].y = (
    0.536250f
  );

  mesh_gun->vertices[
    0x06
  ].z = (
    0.367943f
  );

  mesh_gun->vertices[
    0x06
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x07
  ].x = (
    1.103095f
  );

  mesh_gun->vertices[
    0x07
  ].y = (
    0.536250f
  );

  mesh_gun->vertices[
    0x07
  ].z = (
    0.370237f
  );

  mesh_gun->vertices[
    0x07
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x08
  ].x = (
    1.100868f
  );

  mesh_gun->vertices[
    0x08
  ].y = (
    0.940500f
  );

  mesh_gun->vertices[
    0x08
  ].z = (
    0.434009f
  );

  mesh_gun->vertices[
    0x08
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x09
  ].x = (
    1.133441f
  );

  mesh_gun->vertices[
    0x09
  ].y = (
    0.940500f
  );

  mesh_gun->vertices[
    0x09
  ].z = (
    -0.498668f
  );

  mesh_gun->vertices[
    0x09
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x0a
  ].x = (
    1.933953f
  );

  mesh_gun->vertices[
    0x0a
  ].y = (
    0.940500f
  );

  mesh_gun->vertices[
    0x0a
  ].z = (
    -0.470055f
  );

  mesh_gun->vertices[
    0x0a
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x0b
  ].x = (
    1.920350f
  );

  mesh_gun->vertices[
    0x0b
  ].y = (
    0.940500f
  );

  mesh_gun->vertices[
    0x0b
  ].z = (
    0.295966f
  );

  mesh_gun->vertices[
    0x0b
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x0c
  ].x = (
    1.920068f
  );

  mesh_gun->vertices[
    0x0c
  ].y = (
    1.353000f
  );

  mesh_gun->vertices[
    0x0c
  ].z = (
    0.355496f
  );

  mesh_gun->vertices[
    0x0c
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x0d
  ].x = (
    1.107796f
  );

  mesh_gun->vertices[
    0x0d
  ].y = (
    1.353000f
  );

  mesh_gun->vertices[
    0x0d
  ].z = (
    0.351018f
  );

  mesh_gun->vertices[
    0x0d
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x0e
  ].x = (
    1.115017f
  );

  mesh_gun->vertices[
    0x0e
  ].y = (
    1.353000f
  );

  mesh_gun->vertices[
    0x0e
  ].z = (
    -0.462636f
  );

  mesh_gun->vertices[
    0x0e
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x0f
  ].x = (
    1.923430f
  );

  mesh_gun->vertices[
    0x0f
  ].y = (
    1.353000f
  );

  mesh_gun->vertices[
    0x0f
  ].z = (
    -0.450173f
  );

  mesh_gun->vertices[
    0x0f
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x10
  ].x = (
    1.997427f
  );

  mesh_gun->vertices[
    0x10
  ].y = (
    1.769625f
  );

  mesh_gun->vertices[
    0x10
  ].z = (
    -0.421046f
  );

  mesh_gun->vertices[
    0x10
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x11
  ].x = (
    1.021056f
  );

  mesh_gun->vertices[
    0x11
  ].y = (
    1.769625f
  );

  mesh_gun->vertices[
    0x11
  ].z = (
    -0.451176f
  );

  mesh_gun->vertices[
    0x11
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x12
  ].x = (
    1.027272f
  );

  mesh_gun->vertices[
    0x12
  ].y = (
    1.777875f
  );

  mesh_gun->vertices[
    0x12
  ].z = (
    0.371734f
  );

  mesh_gun->vertices[
    0x12
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x13
  ].x = (
    1.985892f
  );

  mesh_gun->vertices[
    0x13
  ].y = (
    1.777875f
  );

  mesh_gun->vertices[
    0x13
  ].z = (
    0.375503f
  );

  mesh_gun->vertices[
    0x13
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x14
  ].x = (
    2.133919f
  );

  mesh_gun->vertices[
    0x14
  ].y = (
    1.782000f
  );

  mesh_gun->vertices[
    0x14
  ].z = (
    0.165175f
  );

  mesh_gun->vertices[
    0x14
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x15
  ].x = (
    2.138615f
  );

  mesh_gun->vertices[
    0x15
  ].y = (
    1.782000f
  );

  mesh_gun->vertices[
    0x15
  ].z = (
    -0.321005f
  );

  mesh_gun->vertices[
    0x15
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x16
  ].x = (
    2.134876f
  );

  mesh_gun->vertices[
    0x16
  ].y = (
    2.058375f
  );

  mesh_gun->vertices[
    0x16
  ].z = (
    -0.196869f
  );

  mesh_gun->vertices[
    0x16
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x17
  ].x = (
    2.127646f
  );

  mesh_gun->vertices[
    0x17
  ].y = (
    2.058375f
  );

  mesh_gun->vertices[
    0x17
  ].z = (
    0.109401f
  );

  mesh_gun->vertices[
    0x17
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x18
  ].x = (
    2.002451f
  );

  mesh_gun->vertices[
    0x18
  ].y = (
    1.988250f
  );

  mesh_gun->vertices[
    0x18
  ].z = (
    0.116206f
  );

  mesh_gun->vertices[
    0x18
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x19
  ].x = (
    1.986502f
  );

  mesh_gun->vertices[
    0x19
  ].y = (
    1.988250f
  );

  mesh_gun->vertices[
    0x19
  ].z = (
    -0.177220f
  );

  mesh_gun->vertices[
    0x19
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x1a
  ].x = (
    1.733754f
  );

  mesh_gun->vertices[
    0x1a
  ].y = (
    1.852125f
  );

  mesh_gun->vertices[
    0x1a
  ].z = (
    0.012326f
  );

  mesh_gun->vertices[
    0x1a
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x1b
  ].x = (
    1.041024f
  );

  mesh_gun->vertices[
    0x1b
  ].y = (
    1.852125f
  );

  mesh_gun->vertices[
    0x1b
  ].z = (
    0.012055f
  );

  mesh_gun->vertices[
    0x1b
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x1c
  ].x = (
    -0.010440f
  );

  mesh_gun->vertices[
    0x1c
  ].y = (
    1.852125f
  );

  mesh_gun->vertices[
    0x1c
  ].z = (
    0.011645f
  );

  mesh_gun->vertices[
    0x1c
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x1d
  ].x = (
    -0.987684f
  );

  mesh_gun->vertices[
    0x1d
  ].y = (
    1.965562f
  );

  mesh_gun->vertices[
    0x1d
  ].z = (
    0.011264f
  );

  mesh_gun->vertices[
    0x1d
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x1e
  ].x = (
    -1.742265f
  );

  mesh_gun->vertices[
    0x1e
  ].y = (
    1.862437f
  );

  mesh_gun->vertices[
    0x1e
  ].z = (
    0.010969f
  );

  mesh_gun->vertices[
    0x1e
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x1f
  ].x = (
    -1.991730f
  );

  mesh_gun->vertices[
    0x1f
  ].y = (
    1.862437f
  );

  mesh_gun->vertices[
    0x1f
  ].z = (
    0.010872f
  );

  mesh_gun->vertices[
    0x1f
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x20
  ].x = (
    -1.994235f
  );

  mesh_gun->vertices[
    0x20
  ].y = (
    1.794375f
  );

  mesh_gun->vertices[
    0x20
  ].z = (
    0.140367f
  );

  mesh_gun->vertices[
    0x20
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x21
  ].x = (
    -1.989381f
  );

  mesh_gun->vertices[
    0x21
  ].y = (
    1.794375f
  );

  mesh_gun->vertices[
    0x21
  ].z = (
    -0.110529f
  );

  mesh_gun->vertices[
    0x21
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x22
  ].x = (
    -1.989381f
  );

  mesh_gun->vertices[
    0x22
  ].y = (
    1.652062f
  );

  mesh_gun->vertices[
    0x22
  ].z = (
    -0.110529f
  );

  mesh_gun->vertices[
    0x22
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x23
  ].x = (
    -1.994470f
  );

  mesh_gun->vertices[
    0x23
  ].y = (
    1.652062f
  );

  mesh_gun->vertices[
    0x23
  ].z = (
    0.152507f
  );

  mesh_gun->vertices[
    0x23
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x24
  ].x = (
    -1.947750f
  );

  mesh_gun->vertices[
    0x24
  ].y = (
    1.610812f
  );

  mesh_gun->vertices[
    0x24
  ].z = (
    0.254287f
  );

  mesh_gun->vertices[
    0x24
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x25
  ].x = (
    -1.949375f
  );

  mesh_gun->vertices[
    0x25
  ].y = (
    1.629375f
  );

  mesh_gun->vertices[
    0x25
  ].z = (
    -0.156587f
  );

  mesh_gun->vertices[
    0x25
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x26
  ].x = (
    -1.949375f
  );

  mesh_gun->vertices[
    0x26
  ].y = (
    1.893375f
  );

  mesh_gun->vertices[
    0x26
  ].z = (
    -0.156587f
  );

  mesh_gun->vertices[
    0x26
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x27
  ].x = (
    -1.950779f
  );

  mesh_gun->vertices[
    0x27
  ].y = (
    1.893375f
  );

  mesh_gun->vertices[
    0x27
  ].z = (
    0.221509f
  );

  mesh_gun->vertices[
    0x27
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x28
  ].x = (
    -1.933295f
  );

  mesh_gun->vertices[
    0x28
  ].y = (
    1.559250f
  );

  mesh_gun->vertices[
    0x28
  ].z = (
    0.254915f
  );

  mesh_gun->vertices[
    0x28
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x29
  ].x = (
    -1.930720f
  );

  mesh_gun->vertices[
    0x29
  ].y = (
    1.559250f
  );

  mesh_gun->vertices[
    0x29
  ].z = (
    -0.155010f
  );

  mesh_gun->vertices[
    0x29
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x2a
  ].x = (
    -1.932703f
  );

  mesh_gun->vertices[
    0x2a
  ].y = (
    1.524187f
  );

  mesh_gun->vertices[
    0x2a
  ].z = (
    0.160632f
  );

  mesh_gun->vertices[
    0x2a
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x2b
  ].x = (
    -1.931183f
  );

  mesh_gun->vertices[
    0x2b
  ].y = (
    1.524187f
  );

  mesh_gun->vertices[
    0x2b
  ].z = (
    -0.081223f
  );

  mesh_gun->vertices[
    0x2b
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x2c
  ].x = (
    -1.931183f
  );

  mesh_gun->vertices[
    0x2c
  ].y = (
    1.447875f
  );

  mesh_gun->vertices[
    0x2c
  ].z = (
    -0.081223f
  );

  mesh_gun->vertices[
    0x2c
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x2d
  ].x = (
    -1.932406f
  );

  mesh_gun->vertices[
    0x2d
  ].y = (
    1.449937f
  );

  mesh_gun->vertices[
    0x2d
  ].z = (
    0.113491f
  );

  mesh_gun->vertices[
    0x2d
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x2e
  ].x = (
    -1.928979f
  );

  mesh_gun->vertices[
    0x2e
  ].y = (
    1.449937f
  );

  mesh_gun->vertices[
    0x2e
  ].z = (
    0.217314f
  );

  mesh_gun->vertices[
    0x2e
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x2f
  ].x = (
    -1.941237f
  );

  mesh_gun->vertices[
    0x2f
  ].y = (
    1.449937f
  );

  mesh_gun->vertices[
    0x2f
  ].z = (
    -0.154053f
  );

  mesh_gun->vertices[
    0x2f
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x30
  ].x = (
    -1.940842f
  );

  mesh_gun->vertices[
    0x30
  ].y = (
    1.344750f
  );

  mesh_gun->vertices[
    0x30
  ].z = (
    -0.142073f
  );

  mesh_gun->vertices[
    0x30
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x31
  ].x = (
    -1.931155f
  );

  mesh_gun->vertices[
    0x31
  ].y = (
    1.344750f
  );

  mesh_gun->vertices[
    0x31
  ].z = (
    0.151426f
  );

  mesh_gun->vertices[
    0x31
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x32
  ].x = (
    -1.268266f
  );

  mesh_gun->vertices[
    0x32
  ].y = (
    1.344750f
  );

  mesh_gun->vertices[
    0x32
  ].z = (
    0.156788f
  );

  mesh_gun->vertices[
    0x32
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x33
  ].x = (
    -0.543999f
  );

  mesh_gun->vertices[
    0x33
  ].y = (
    1.266375f
  );

  mesh_gun->vertices[
    0x33
  ].z = (
    0.162646f
  );

  mesh_gun->vertices[
    0x33
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x34
  ].x = (
    0.077970f
  );

  mesh_gun->vertices[
    0x34
  ].y = (
    1.336500f
  );

  mesh_gun->vertices[
    0x34
  ].z = (
    0.167677f
  );

  mesh_gun->vertices[
    0x34
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x35
  ].x = (
    0.896351f
  );

  mesh_gun->vertices[
    0x35
  ].y = (
    1.282875f
  );

  mesh_gun->vertices[
    0x35
  ].z = (
    0.174296f
  );

  mesh_gun->vertices[
    0x35
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x36
  ].x = (
    0.899814f
  );

  mesh_gun->vertices[
    0x36
  ].y = (
    1.282875f
  );

  mesh_gun->vertices[
    0x36
  ].z = (
    -0.377053f
  );

  mesh_gun->vertices[
    0x36
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x37
  ].x = (
    0.056875f
  );

  mesh_gun->vertices[
    0x37
  ].y = (
    1.328250f
  );

  mesh_gun->vertices[
    0x37
  ].z = (
    -0.374367f
  );

  mesh_gun->vertices[
    0x37
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x38
  ].x = (
    -0.527014f
  );

  mesh_gun->vertices[
    0x38
  ].y = (
    1.258125f
  );

  mesh_gun->vertices[
    0x38
  ].z = (
    -0.372507f
  );

  mesh_gun->vertices[
    0x38
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x39
  ].x = (
    -1.164358f
  );

  mesh_gun->vertices[
    0x39
  ].y = (
    1.361250f
  );

  mesh_gun->vertices[
    0x39
  ].z = (
    -0.370476f
  );

  mesh_gun->vertices[
    0x39
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x3a
  ].x = (
    -1.949604f
  );

  mesh_gun->vertices[
    0x3a
  ].y = (
    1.361250f
  );

  mesh_gun->vertices[
    0x3a
  ].z = (
    -0.363727f
  );

  mesh_gun->vertices[
    0x3a
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x3b
  ].x = (
    0.739886f
  );

  mesh_gun->vertices[
    0x3b
  ].y = (
    1.567500f
  );

  mesh_gun->vertices[
    0x3b
  ].z = (
    0.344501f
  );

  mesh_gun->vertices[
    0x3b
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x3c
  ].x = (
    -0.139760f
  );

  mesh_gun->vertices[
    0x3c
  ].y = (
    1.559250f
  );

  mesh_gun->vertices[
    0x3c
  ].z = (
    0.372356f
  );

  mesh_gun->vertices[
    0x3c
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x3d
  ].x = (
    -0.543597f
  );

  mesh_gun->vertices[
    0x3d
  ].y = (
    1.633500f
  );

  mesh_gun->vertices[
    0x3d
  ].z = (
    0.385143f
  );

  mesh_gun->vertices[
    0x3d
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x3e
  ].x = (
    -1.139357f
  );

  mesh_gun->vertices[
    0x3e
  ].y = (
    1.536562f
  );

  mesh_gun->vertices[
    0x3e
  ].z = (
    0.404008f
  );

  mesh_gun->vertices[
    0x3e
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x3f
  ].x = (
    -1.659148f
  );

  mesh_gun->vertices[
    0x3f
  ].y = (
    1.536562f
  );

  mesh_gun->vertices[
    0x3f
  ].z = (
    0.420468f
  );

  mesh_gun->vertices[
    0x3f
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x40
  ].x = (
    -1.487637f
  );

  mesh_gun->vertices[
    0x40
  ].y = (
    1.619062f
  );

  mesh_gun->vertices[
    0x40
  ].z = (
    -0.341928f
  );

  mesh_gun->vertices[
    0x40
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x41
  ].x = (
    -0.762850f
  );

  mesh_gun->vertices[
    0x41
  ].y = (
    1.614937f
  );

  mesh_gun->vertices[
    0x41
  ].z = (
    -0.343141f
  );

  mesh_gun->vertices[
    0x41
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x42
  ].x = (
    0.003119f
  );

  mesh_gun->vertices[
    0x42
  ].y = (
    1.610812f
  );

  mesh_gun->vertices[
    0x42
  ].z = (
    -0.344422f
  );

  mesh_gun->vertices[
    0x42
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x43
  ].x = (
    0.818505f
  );

  mesh_gun->vertices[
    0x43
  ].y = (
    1.507688f
  );

  mesh_gun->vertices[
    0x43
  ].z = (
    -0.345786f
  );

  mesh_gun->vertices[
    0x43
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x44
  ].x = (
    0.928616f
  );

  mesh_gun->vertices[
    0x44
  ].y = (
    0.946686f
  );

  mesh_gun->vertices[
    0x44
  ].z = (
    0.180845f
  );

  mesh_gun->vertices[
    0x44
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x45
  ].x = (
    0.930702f
  );

  mesh_gun->vertices[
    0x45
  ].y = (
    0.946686f
  );

  mesh_gun->vertices[
    0x45
  ].z = (
    -0.221320f
  );

  mesh_gun->vertices[
    0x45
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x46
  ].x = (
    0.857156f
  );

  mesh_gun->vertices[
    0x46
  ].y = (
    0.954936f
  );

  mesh_gun->vertices[
    0x46
  ].z = (
    -0.222024f
  );

  mesh_gun->vertices[
    0x46
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x47
  ].x = (
    0.869617f
  );

  mesh_gun->vertices[
    0x47
  ].y = (
    0.954936f
  );

  mesh_gun->vertices[
    0x47
  ].z = (
    0.037765f
  );

  mesh_gun->vertices[
    0x47
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x48
  ].x = (
    0.931449f
  );

  mesh_gun->vertices[
    0x48
  ].y = (
    1.025061f
  );

  mesh_gun->vertices[
    0x48
  ].z = (
    0.037722f
  );

  mesh_gun->vertices[
    0x48
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x49
  ].x = (
    0.931449f
  );

  mesh_gun->vertices[
    0x49
  ].y = (
    1.231311f
  );

  mesh_gun->vertices[
    0x49
  ].z = (
    0.037722f
  );

  mesh_gun->vertices[
    0x49
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x4a
  ].x = (
    0.982381f
  );

  mesh_gun->vertices[
    0x4a
  ].y = (
    0.827061f
  );

  mesh_gun->vertices[
    0x4a
  ].z = (
    0.178116f
  );

  mesh_gun->vertices[
    0x4a
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x4b
  ].x = (
    0.987286f
  );

  mesh_gun->vertices[
    0x4b
  ].y = (
    0.827061f
  );

  mesh_gun->vertices[
    0x4b
  ].z = (
    -0.295479f
  );

  mesh_gun->vertices[
    0x4b
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x4c
  ].x = (
    0.852296f
  );

  mesh_gun->vertices[
    0x4c
  ].y = (
    0.827061f
  );

  mesh_gun->vertices[
    0x4c
  ].z = (
    -0.294343f
  );

  mesh_gun->vertices[
    0x4c
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x4d
  ].x = (
    0.643676f
  );

  mesh_gun->vertices[
    0x4d
  ].y = (
    1.099311f
  );

  mesh_gun->vertices[
    0x4d
  ].z = (
    -0.292589f
  );

  mesh_gun->vertices[
    0x4d
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x4e
  ].x = (
    0.649386f
  );

  mesh_gun->vertices[
    0x4e
  ].y = (
    1.099311f
  );

  mesh_gun->vertices[
    0x4e
  ].z = (
    0.386451f
  );

  mesh_gun->vertices[
    0x4e
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x4f
  ].x = (
    0.784376f
  );

  mesh_gun->vertices[
    0x4f
  ].y = (
    0.827061f
  );

  mesh_gun->vertices[
    0x4f
  ].z = (
    0.385316f
  );

  mesh_gun->vertices[
    0x4f
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x50
  ].x = (
    0.911184f
  );

  mesh_gun->vertices[
    0x50
  ].y = (
    0.827061f
  );

  mesh_gun->vertices[
    0x50
  ].z = (
    0.384249f
  );

  mesh_gun->vertices[
    0x50
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x51
  ].x = (
    -1.106449f
  );

  mesh_gun->vertices[
    0x51
  ].y = (
    1.173561f
  );

  mesh_gun->vertices[
    0x51
  ].z = (
    -0.285371f
  );

  mesh_gun->vertices[
    0x51
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x52
  ].x = (
    -1.106484f
  );

  mesh_gun->vertices[
    0x52
  ].y = (
    1.173561f
  );

  mesh_gun->vertices[
    0x52
  ].z = (
    0.267344f
  );

  mesh_gun->vertices[
    0x52
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x53
  ].x = (
    -0.581994f
  );

  mesh_gun->vertices[
    0x53
  ].y = (
    1.045686f
  );

  mesh_gun->vertices[
    0x53
  ].z = (
    0.243209f
  );

  mesh_gun->vertices[
    0x53
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x54
  ].x = (
    -0.581994f
  );

  mesh_gun->vertices[
    0x54
  ].y = (
    0.769311f
  );

  mesh_gun->vertices[
    0x54
  ].z = (
    0.243209f
  );

  mesh_gun->vertices[
    0x54
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x55
  ].x = (
    -0.846211f
  );

  mesh_gun->vertices[
    0x55
  ].y = (
    0.422811f
  );

  mesh_gun->vertices[
    0x55
  ].z = (
    0.255367f
  );

  mesh_gun->vertices[
    0x55
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x56
  ].x = (
    -1.240564f
  );

  mesh_gun->vertices[
    0x56
  ].y = (
    0.216561f
  );

  mesh_gun->vertices[
    0x56
  ].z = (
    0.273514f
  );

  mesh_gun->vertices[
    0x56
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x57
  ].x = (
    -1.445628f
  );

  mesh_gun->vertices[
    0x57
  ].y = (
    0.216561f
  );

  mesh_gun->vertices[
    0x57
  ].z = (
    0.282950f
  );

  mesh_gun->vertices[
    0x57
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x58
  ].x = (
    -1.445628f
  );

  mesh_gun->vertices[
    0x58
  ].y = (
    0.488811f
  );

  mesh_gun->vertices[
    0x58
  ].z = (
    0.282950f
  );

  mesh_gun->vertices[
    0x58
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x59
  ].x = (
    -1.116088f
  );

  mesh_gun->vertices[
    0x59
  ].y = (
    0.690936f
  );

  mesh_gun->vertices[
    0x59
  ].z = (
    0.402150f
  );

  mesh_gun->vertices[
    0x59
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x5a
  ].x = (
    -1.116088f
  );

  mesh_gun->vertices[
    0x5a
  ].y = (
    0.971436f
  );

  mesh_gun->vertices[
    0x5a
  ].z = (
    0.402150f
  );

  mesh_gun->vertices[
    0x5a
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x5b
  ].x = (
    -1.116088f
  );

  mesh_gun->vertices[
    0x5b
  ].y = (
    1.173561f
  );

  mesh_gun->vertices[
    0x5b
  ].z = (
    0.402150f
  );

  mesh_gun->vertices[
    0x5b
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x5c
  ].x = (
    -0.518687f
  );

  mesh_gun->vertices[
    0x5c
  ].y = (
    0.703311f
  );

  mesh_gun->vertices[
    0x5c
  ].z = (
    -0.163699f
  );

  mesh_gun->vertices[
    0x5c
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x5d
  ].x = (
    -0.780370f
  );

  mesh_gun->vertices[
    0x5d
  ].y = (
    0.356811f
  );

  mesh_gun->vertices[
    0x5d
  ].z = (
    -0.245859f
  );

  mesh_gun->vertices[
    0x5d
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x5e
  ].x = (
    -1.115111f
  );

  mesh_gun->vertices[
    0x5e
  ].y = (
    0.356811f
  );

  mesh_gun->vertices[
    0x5e
  ].z = (
    -0.257618f
  );

  mesh_gun->vertices[
    0x5e
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x5f
  ].x = (
    -1.374137f
  );

  mesh_gun->vertices[
    0x5f
  ].y = (
    0.356811f
  );

  mesh_gun->vertices[
    0x5f
  ].z = (
    -0.266717f
  );

  mesh_gun->vertices[
    0x5f
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x60
  ].x = (
    -1.374137f
  );

  mesh_gun->vertices[
    0x60
  ].y = (
    0.699186f
  );

  mesh_gun->vertices[
    0x60
  ].z = (
    -0.266717f
  );

  mesh_gun->vertices[
    0x60
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x61
  ].x = (
    -0.979621f
  );

  mesh_gun->vertices[
    0x61
  ].y = (
    0.699186f
  );

  mesh_gun->vertices[
    0x61
  ].z = (
    -0.252858f
  );

  mesh_gun->vertices[
    0x61
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x62
  ].x = (
    -0.979621f
  );

  mesh_gun->vertices[
    0x62
  ].y = (
    1.111686f
  );

  mesh_gun->vertices[
    0x62
  ].z = (
    -0.252858f
  );

  mesh_gun->vertices[
    0x62
  ].w = (
    1.000000f
  );

  mesh_gun->vertices[
    0x63
  ].x = (
    -1.111126f
  );

  mesh_gun->vertices[
    0x63
  ].y = (
    1.177686f
  );

  mesh_gun->vertices[
    0x63
  ].z = (
    -0.257478f
  );

  mesh_gun->vertices[
    0x63
  ].w = (
    1.000000f
  );
  
  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      mesh_gun->length_vertices
    );
    ++index_vertex
  ) {
    float z = (
      mesh_gun->vertices[
        index_vertex
      ].x
    );  
    
    mesh_gun->vertices[
      index_vertex
    ].x = (
      mesh_gun->vertices[
        index_vertex
      ].z +
      0x04
    );
    
    mesh_gun->vertices[
      index_vertex
    ].z = (
      z -
      0x06
    );
    
    if (
      handedness ==
      c938_handedness_right
    ) {
      mesh_gun->vertices[
        index_vertex
      ].x = -(
        mesh_gun->vertices[
          index_vertex
        ].x
      );
    }
  }

  mesh_gun->indices[
    0x00
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x01
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x02
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x03
  ] = (
    0x30
  );

  mesh_gun->indices[
    0x04
  ] = (
    0x31
  );

  mesh_gun->indices[
    0x05
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0x06
  ] = (
    0x00
  );

  mesh_gun->indices[
    0x07
  ] = (
    0x01
  );

  mesh_gun->indices[
    0x08
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x09
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x0a
  ] = (
    0x03
  );

  mesh_gun->indices[
    0x0b
  ] = (
    0x00
  );

  mesh_gun->indices[
    0x0c
  ] = (
    0x00
  );

  mesh_gun->indices[
    0x0d
  ] = (
    0x03
  );

  mesh_gun->indices[
    0x0e
  ] = (
    0x04
  );

  mesh_gun->indices[
    0x0f
  ] = (
    0x04
  );

  mesh_gun->indices[
    0x10
  ] = (
    0x05
  );

  mesh_gun->indices[
    0x11
  ] = (
    0x00
  );

  mesh_gun->indices[
    0x12
  ] = (
    0x00
  );

  mesh_gun->indices[
    0x13
  ] = (
    0x01
  );

  mesh_gun->indices[
    0x14
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x15
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x16
  ] = (
    0x05
  );

  mesh_gun->indices[
    0x17
  ] = (
    0x00
  );

  mesh_gun->indices[
    0x18
  ] = (
    0x03
  );

  mesh_gun->indices[
    0x19
  ] = (
    0x04
  );

  mesh_gun->indices[
    0x1a
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x1b
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x1c
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x1d
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x1e
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x1f
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x20
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x21
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x22
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x23
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x24
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x25
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x26
  ] = (
    0x03
  );

  mesh_gun->indices[
    0x27
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x28
  ] = (
    0x01
  );

  mesh_gun->indices[
    0x29
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x2a
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x2b
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x2c
  ] = (
    0x02
  );

  mesh_gun->indices[
    0x2d
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x2e
  ] = (
    0x05
  );

  mesh_gun->indices[
    0x2f
  ] = (
    0x0a
  );

  mesh_gun->indices[
    0x30
  ] = (
    0x0a
  );

  mesh_gun->indices[
    0x31
  ] = (
    0x0b
  );

  mesh_gun->indices[
    0x32
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x33
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x34
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x35
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x36
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x37
  ] = (
    0x0b
  );

  mesh_gun->indices[
    0x38
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x39
  ] = (
    0x0b
  );

  mesh_gun->indices[
    0x3a
  ] = (
    0x0a
  );

  mesh_gun->indices[
    0x3b
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x3c
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x3d
  ] = (
    0x0f
  );

  mesh_gun->indices[
    0x3e
  ] = (
    0x0a
  );

  mesh_gun->indices[
    0x3f
  ] = (
    0x0a
  );

  mesh_gun->indices[
    0x40
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x41
  ] = (
    0x0e
  );

  mesh_gun->indices[
    0x42
  ] = (
    0x0e
  );

  mesh_gun->indices[
    0x43
  ] = (
    0x0f
  );

  mesh_gun->indices[
    0x44
  ] = (
    0x05
  );

  mesh_gun->indices[
    0x45
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x46
  ] = (
    0x04
  );

  mesh_gun->indices[
    0x47
  ] = (
    0x05
  );

  mesh_gun->indices[
    0x48
  ] = (
    0x05
  );

  mesh_gun->indices[
    0x49
  ] = (
    0x0a
  );

  mesh_gun->indices[
    0x4a
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x4b
  ] = (
    0x04
  );

  mesh_gun->indices[
    0x4c
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x4d
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x4e
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x4f
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x50
  ] = (
    0x04
  );

  mesh_gun->indices[
    0x51
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x52
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x53
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x54
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x55
  ] = (
    0x36
  );

  mesh_gun->indices[
    0x56
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x57
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x58
  ] = (
    0x0e
  );

  mesh_gun->indices[
    0x59
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x5a
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x5b
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x5c
  ] = (
    0x36
  );

  mesh_gun->indices[
    0x5d
  ] = (
    0x36
  );

  mesh_gun->indices[
    0x5e
  ] = (
    0x0e
  );

  mesh_gun->indices[
    0x5f
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x60
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x61
  ] = (
    0x06
  );

  mesh_gun->indices[
    0x62
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x63
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x64
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x65
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x66
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x67
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x68
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x69
  ] = (
    0x08
  );

  mesh_gun->indices[
    0x6a
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x6b
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x6c
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x6d
  ] = (
    0x0f
  );

  mesh_gun->indices[
    0x6e
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x6f
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x70
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x71
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x72
  ] = (
    0x0c
  );

  mesh_gun->indices[
    0x73
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x74
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x75
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x76
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x77
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x78
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x79
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x7a
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x7b
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x7c
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x7d
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x7e
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x7f
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x80
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x81
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x82
  ] = (
    0x0d
  );

  mesh_gun->indices[
    0x83
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x84
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x85
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x86
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x87
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x88
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x89
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x8a
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x8b
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x8c
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x8d
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x8e
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x8f
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0x90
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0x91
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x92
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x93
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x94
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0x95
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x96
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x97
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x98
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x99
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x9a
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x9b
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x9c
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x9d
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x9e
  ] = (
    0x23
  );

  mesh_gun->indices[
    0x9f
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0xa0
  ] = (
    0x33
  );

  mesh_gun->indices[
    0xa1
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0xa2
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0xa3
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0xa4
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0xa5
  ] = (
    0x23
  );

  mesh_gun->indices[
    0xa6
  ] = (
    0x23
  );

  mesh_gun->indices[
    0xa7
  ] = (
    0x23
  );

  mesh_gun->indices[
    0xa8
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xa9
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xaa
  ] = (
    0x20
  );

  mesh_gun->indices[
    0xab
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xac
  ] = (
    0x21
  );

  mesh_gun->indices[
    0xad
  ] = (
    0x20
  );

  mesh_gun->indices[
    0xae
  ] = (
    0x21
  );

  mesh_gun->indices[
    0xaf
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xb0
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xb1
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xb2
  ] = (
    0x23
  );

  mesh_gun->indices[
    0xb3
  ] = (
    0x22
  );

  mesh_gun->indices[
    0xb4
  ] = (
    0x21
  );

  mesh_gun->indices[
    0xb5
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xb6
  ] = (
    0x2a
  );

  mesh_gun->indices[
    0xb7
  ] = (
    0x31
  );

  mesh_gun->indices[
    0xb8
  ] = (
    0x20
  );

  mesh_gun->indices[
    0xb9
  ] = (
    0x24
  );

  mesh_gun->indices[
    0xba
  ] = (
    0x2a
  );

  mesh_gun->indices[
    0xbb
  ] = (
    0x2a
  );

  mesh_gun->indices[
    0xbc
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xbd
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xbe
  ] = (
    0x2e
  );

  mesh_gun->indices[
    0xbf
  ] = (
    0x28
  );

  mesh_gun->indices[
    0xc0
  ] = (
    0x28
  );

  mesh_gun->indices[
    0xc1
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xc2
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xc3
  ] = (
    0x27
  );

  mesh_gun->indices[
    0xc4
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xc5
  ] = (
    0x25
  );

  mesh_gun->indices[
    0xc6
  ] = (
    0x25
  );

  mesh_gun->indices[
    0xc7
  ] = (
    0x24
  );

  mesh_gun->indices[
    0xc8
  ] = (
    0x2e
  );

  mesh_gun->indices[
    0xc9
  ] = (
    0x2e
  );

  mesh_gun->indices[
    0xca
  ] = (
    0x2c
  );

  mesh_gun->indices[
    0xcb
  ] = (
    0x31
  );

  mesh_gun->indices[
    0xcc
  ] = (
    0x31
  );

  mesh_gun->indices[
    0xcd
  ] = (
    0x30
  );

  mesh_gun->indices[
    0xce
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xcf
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xd0
  ] = (
    0x2d
  );

  mesh_gun->indices[
    0xd1
  ] = (
    0x28
  );

  mesh_gun->indices[
    0xd2
  ] = (
    0x22
  );

  mesh_gun->indices[
    0xd3
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xd4
  ] = (
    0x21
  );

  mesh_gun->indices[
    0xd5
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xd6
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xd7
  ] = (
    0x22
  );

  mesh_gun->indices[
    0xd8
  ] = (
    0x22
  );

  mesh_gun->indices[
    0xd9
  ] = (
    0x2c
  );

  mesh_gun->indices[
    0xda
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xdb
  ] = (
    0x2f
  );

  mesh_gun->indices[
    0xdc
  ] = (
    0x2d
  );

  mesh_gun->indices[
    0xdd
  ] = (
    0x20
  );

  mesh_gun->indices[
    0xde
  ] = (
    0x2b
  );

  mesh_gun->indices[
    0xdf
  ] = (
    0x40
  );

  mesh_gun->indices[
    0xe0
  ] = (
    0x41
  );

  mesh_gun->indices[
    0xe1
  ] = (
    0x42
  );

  mesh_gun->indices[
    0xe2
  ] = (
    0x40
  );

  mesh_gun->indices[
    0xe3
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0xe4
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0xe5
  ] = (
    0x25
  );

  mesh_gun->indices[
    0xe6
  ] = (
    0x40
  );

  mesh_gun->indices[
    0xe7
  ] = (
    0x40
  );

  mesh_gun->indices[
    0xe8
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0xe9
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xea
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xeb
  ] = (
    0x42
  );

  mesh_gun->indices[
    0xec
  ] = (
    0x11
  );

  mesh_gun->indices[
    0xed
  ] = (
    0x11
  );

  mesh_gun->indices[
    0xee
  ] = (
    0x42
  );

  mesh_gun->indices[
    0xef
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0xf0
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0xf1
  ] = (
    0x39
  );

  mesh_gun->indices[
    0xf2
  ] = (
    0x38
  );

  mesh_gun->indices[
    0xf3
  ] = (
    0x38
  );

  mesh_gun->indices[
    0xf4
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0xf5
  ] = (
    0x39
  );

  mesh_gun->indices[
    0xf6
  ] = (
    0x39
  );

  mesh_gun->indices[
    0xf7
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0xf8
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xf9
  ] = (
    0x26
  );

  mesh_gun->indices[
    0xfa
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0xfb
  ] = (
    0x39
  );

  mesh_gun->indices[
    0xfc
  ] = (
    0x39
  );

  mesh_gun->indices[
    0xfd
  ] = (
    0x37
  );

  mesh_gun->indices[
    0xfe
  ] = (
    0x42
  );

  mesh_gun->indices[
    0xff
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x100
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0x101
  ] = (
    0x41
  );

  mesh_gun->indices[
    0x102
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x103
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x104
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x105
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x106
  ] = (
    0x14
  );

  mesh_gun->indices[
    0x107
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x108
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x109
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x10a
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x10b
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x10c
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x10d
  ] = (
    0x14
  );

  mesh_gun->indices[
    0x10e
  ] = (
    0x14
  );

  mesh_gun->indices[
    0x10f
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x110
  ] = (
    0x16
  );

  mesh_gun->indices[
    0x111
  ] = (
    0x16
  );

  mesh_gun->indices[
    0x112
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x113
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x114
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x115
  ] = (
    0x19
  );

  mesh_gun->indices[
    0x116
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x117
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x118
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x119
  ] = (
    0x19
  );

  mesh_gun->indices[
    0x11a
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x11b
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x11c
  ] = (
    0x1b
  );

  mesh_gun->indices[
    0x11d
  ] = (
    0x1b
  );

  mesh_gun->indices[
    0x11e
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x11f
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x120
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x121
  ] = (
    0x14
  );

  mesh_gun->indices[
    0x122
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x123
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x124
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x125
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x126
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x127
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x128
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x129
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x12a
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x12b
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x12c
  ] = (
    0x36
  );

  mesh_gun->indices[
    0x12d
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x12e
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x12f
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x130
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x131
  ] = (
    0x36
  );

  mesh_gun->indices[
    0x132
  ] = (
    0x36
  );

  mesh_gun->indices[
    0x133
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x134
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x135
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x136
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x137
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x138
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x139
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x13a
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x13b
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x13c
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x13d
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x13e
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x13f
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x140
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x141
  ] = (
    0x1c
  );

  mesh_gun->indices[
    0x142
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x143
  ] = (
    0x27
  );

  mesh_gun->indices[
    0x144
  ] = (
    0x2e
  );

  mesh_gun->indices[
    0x145
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x146
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x147
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x148
  ] = (
    0x2e
  );

  mesh_gun->indices[
    0x149
  ] = (
    0x2d
  );

  mesh_gun->indices[
    0x14a
  ] = (
    0x2d
  );

  mesh_gun->indices[
    0x14b
  ] = (
    0x28
  );

  mesh_gun->indices[
    0x14c
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x14d
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x14e
  ] = (
    0x24
  );

  mesh_gun->indices[
    0x14f
  ] = (
    0x27
  );

  mesh_gun->indices[
    0x150
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x151
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x152
  ] = (
    0x2a
  );

  mesh_gun->indices[
    0x153
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x154
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x155
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x156
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x157
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x158
  ] = (
    0x27
  );

  mesh_gun->indices[
    0x159
  ] = (
    0x31
  );

  mesh_gun->indices[
    0x15a
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x15b
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0x15c
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0x15d
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x15e
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x15f
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0x160
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0x161
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x162
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x163
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x164
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x165
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x166
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x167
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x168
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x169
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x16a
  ] = (
    0x39
  );

  mesh_gun->indices[
    0x16b
  ] = (
    0x39
  );

  mesh_gun->indices[
    0x16c
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x16d
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x16e
  ] = (
    0x3c
  );

  mesh_gun->indices[
    0x16f
  ] = (
    0x39
  );

  mesh_gun->indices[
    0x170
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x171
  ] = (
    0x31
  );

  mesh_gun->indices[
    0x172
  ] = (
    0x3e
  );

  mesh_gun->indices[
    0x173
  ] = (
    0x37
  );

  mesh_gun->indices[
    0x174
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x175
  ] = (
    0x39
  );

  mesh_gun->indices[
    0x176
  ] = (
    0x3a
  );

  mesh_gun->indices[
    0x177
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x178
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x179
  ] = (
    0x32
  );

  mesh_gun->indices[
    0x17a
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x17b
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x17c
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x17d
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x17e
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x17f
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x180
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x181
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x182
  ] = (
    0x1b
  );

  mesh_gun->indices[
    0x183
  ] = (
    0x1b
  );

  mesh_gun->indices[
    0x184
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x185
  ] = (
    0x1c
  );

  mesh_gun->indices[
    0x186
  ] = (
    0x1c
  );

  mesh_gun->indices[
    0x187
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x188
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x189
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x18a
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x18b
  ] = (
    0x16
  );

  mesh_gun->indices[
    0x18c
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x18d
  ] = (
    0x16
  );

  mesh_gun->indices[
    0x18e
  ] = (
    0x12
  );

  mesh_gun->indices[
    0x18f
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x190
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x191
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x192
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x193
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x194
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x195
  ] = (
    0x14
  );

  mesh_gun->indices[
    0x196
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x197
  ] = (
    0x1a
  );

  mesh_gun->indices[
    0x198
  ] = (
    0x10
  );

  mesh_gun->indices[
    0x199
  ] = (
    0x16
  );

  mesh_gun->indices[
    0x19a
  ] = (
    0x1b
  );

  mesh_gun->indices[
    0x19b
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x19c
  ] = (
    0x14
  );

  mesh_gun->indices[
    0x19d
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x19e
  ] = (
    0x15
  );

  mesh_gun->indices[
    0x19f
  ] = (
    0x13
  );

  mesh_gun->indices[
    0x1a0
  ] = (
    0x3b
  );

  mesh_gun->indices[
    0x1a1
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x1a2
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x1a3
  ] = (
    0x0b
  );

  mesh_gun->indices[
    0x1a4
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x1a5
  ] = (
    0x09
  );

  mesh_gun->indices[
    0x1a6
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x1a7
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x1a8
  ] = (
    0x1c
  );

  mesh_gun->indices[
    0x1a9
  ] = (
    0x1c
  );

  mesh_gun->indices[
    0x1aa
  ] = (
    0x43
  );

  mesh_gun->indices[
    0x1ab
  ] = (
    0x1c
  );

  mesh_gun->indices[
    0x1ac
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0x1ad
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0x1ae
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0x1af
  ] = (
    0x26
  );

  mesh_gun->indices[
    0x1b0
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0x1b1
  ] = (
    0x41
  );

  mesh_gun->indices[
    0x1b2
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x1b3
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x1b4
  ] = (
    0x18
  );

  mesh_gun->indices[
    0x1b5
  ] = (
    0x17
  );

  mesh_gun->indices[
    0x1b6
  ] = (
    0x16
  );

  mesh_gun->indices[
    0x1b7
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x1b8
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x1b9
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x1ba
  ] = (
    0x41
  );

  mesh_gun->indices[
    0x1bb
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x1bc
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x1bd
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0x1be
  ] = (
    0x1e
  );

  mesh_gun->indices[
    0x1bf
  ] = (
    0x1d
  );

  mesh_gun->indices[
    0x1c0
  ] = (
    0x42
  );

  mesh_gun->indices[
    0x1c1
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x1c2
  ] = (
    0x11
  );

  mesh_gun->indices[
    0x1c3
  ] = (
    0x49
  );

  mesh_gun->indices[
    0x1c4
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1c5
  ] = (
    0x47
  );

  mesh_gun->indices[
    0x1c6
  ] = (
    0x47
  );

  mesh_gun->indices[
    0x1c7
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1c8
  ] = (
    0x47
  );

  mesh_gun->indices[
    0x1c9
  ] = (
    0x47
  );

  mesh_gun->indices[
    0x1ca
  ] = (
    0x46
  );

  mesh_gun->indices[
    0x1cb
  ] = (
    0x44
  );

  mesh_gun->indices[
    0x1cc
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1cd
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1ce
  ] = (
    0x46
  );

  mesh_gun->indices[
    0x1cf
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1d0
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1d1
  ] = (
    0x49
  );

  mesh_gun->indices[
    0x1d2
  ] = (
    0x46
  );

  mesh_gun->indices[
    0x1d3
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1d4
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1d5
  ] = (
    0x48
  );

  mesh_gun->indices[
    0x1d6
  ] = (
    0x35
  );

  mesh_gun->indices[
    0x1d7
  ] = (
    0x46
  );

  mesh_gun->indices[
    0x1d8
  ] = (
    0x50
  );

  mesh_gun->indices[
    0x1d9
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x1da
  ] = (
    0x07
  );

  mesh_gun->indices[
    0x1db
  ] = (
    0x4f
  );

  mesh_gun->indices[
    0x1dc
  ] = (
    0x50
  );

  mesh_gun->indices[
    0x1dd
  ] = (
    0x4f
  );

  mesh_gun->indices[
    0x1de
  ] = (
    0x4e
  );

  mesh_gun->indices[
    0x1df
  ] = (
    0x4e
  );

  mesh_gun->indices[
    0x1e0
  ] = (
    0x4e
  );

  mesh_gun->indices[
    0x1e1
  ] = (
    0x4d
  );

  mesh_gun->indices[
    0x1e2
  ] = (
    0x46
  );

  mesh_gun->indices[
    0x1e3
  ] = (
    0x46
  );

  mesh_gun->indices[
    0x1e4
  ] = (
    0x4c
  );

  mesh_gun->indices[
    0x1e5
  ] = (
    0x4a
  );

  mesh_gun->indices[
    0x1e6
  ] = (
    0x4a
  );

  mesh_gun->indices[
    0x1e7
  ] = (
    0x4c
  );

  mesh_gun->indices[
    0x1e8
  ] = (
    0x4d
  );

  mesh_gun->indices[
    0x1e9
  ] = (
    0x5b
  );

  mesh_gun->indices[
    0x1ea
  ] = (
    0x5a
  );

  mesh_gun->indices[
    0x1eb
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x1ec
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x1ed
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x1ee
  ] = (
    0x59
  );

  mesh_gun->indices[
    0x1ef
  ] = (
    0x59
  );

  mesh_gun->indices[
    0x1f0
  ] = (
    0x5a
  );

  mesh_gun->indices[
    0x1f1
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x1f2
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x1f3
  ] = (
    0x5a
  );

  mesh_gun->indices[
    0x1f4
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x1f5
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x1f6
  ] = (
    0x3d
  );

  mesh_gun->indices[
    0x1f7
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x1f8
  ] = (
    0x3f
  );

  mesh_gun->indices[
    0x1f9
  ] = (
    0x5a
  );

  mesh_gun->indices[
    0x1fa
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x1fb
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x1fc
  ] = (
    0x59
  );

  mesh_gun->indices[
    0x1fd
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x1fe
  ] = (
    0x57
  );

  mesh_gun->indices[
    0x1ff
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x200
  ] = (
    0x59
  );

  mesh_gun->indices[
    0x201
  ] = (
    0x59
  );

  mesh_gun->indices[
    0x202
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x203
  ] = (
    0x57
  );

  mesh_gun->indices[
    0x204
  ] = (
    0x57
  );

  mesh_gun->indices[
    0x205
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x206
  ] = (
    0x5a
  );

  mesh_gun->indices[
    0x207
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x208
  ] = (
    0x55
  );

  mesh_gun->indices[
    0x209
  ] = (
    0x5b
  );

  mesh_gun->indices[
    0x20a
  ] = (
    0x5b
  );

  mesh_gun->indices[
    0x20b
  ] = (
    0x55
  );

  mesh_gun->indices[
    0x20c
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x20d
  ] = (
    0x63
  );

  mesh_gun->indices[
    0x20e
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x20f
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x210
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x211
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x212
  ] = (
    0x60
  );

  mesh_gun->indices[
    0x213
  ] = (
    0x60
  );

  mesh_gun->indices[
    0x214
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x215
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x216
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x217
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x218
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x219
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x21a
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x21b
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x21c
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x21d
  ] = (
    0x60
  );

  mesh_gun->indices[
    0x21e
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x21f
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x220
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x221
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x222
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x223
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x224
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x225
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x226
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x227
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x228
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x229
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x22a
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x22b
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x22c
  ] = (
    0x60
  );

  mesh_gun->indices[
    0x22d
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x22e
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x22f
  ] = (
    0x57
  );

  mesh_gun->indices[
    0x230
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x231
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x232
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x233
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x234
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x235
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x236
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x237
  ] = (
    0x58
  );

  mesh_gun->indices[
    0x238
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x239
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x23a
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x23b
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x23c
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x23d
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x23e
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x23f
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x240
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x241
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x242
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x243
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x244
  ] = (
    0x55
  );

  mesh_gun->indices[
    0x245
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x246
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x247
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x248
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x249
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x24a
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x24b
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x24c
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x24d
  ] = (
    0x53
  );

  mesh_gun->indices[
    0x24e
  ] = (
    0x34
  );

  mesh_gun->indices[
    0x24f
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x250
  ] = (
    0x51
  );

  mesh_gun->indices[
    0x251
  ] = (
    0x63
  );

  mesh_gun->indices[
    0x252
  ] = (
    0x63
  );

  mesh_gun->indices[
    0x253
  ] = (
    0x52
  );

  mesh_gun->indices[
    0x254
  ] = (
    0x31
  );

  mesh_gun->indices[
    0x255
  ] = (
    0x31
  );

  mesh_gun->indices[
    0x256
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x257
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x258
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x259
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x25a
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x25b
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x25c
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x25d
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x25e
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x25f
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x260
  ] = (
    0x59
  );

  mesh_gun->indices[
    0x261
  ] = (
    0x5c
  );

  mesh_gun->indices[
    0x262
  ] = (
    0x33
  );

  mesh_gun->indices[
    0x263
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x264
  ] = (
    0x60
  );

  mesh_gun->indices[
    0x265
  ] = (
    0x41
  );

  mesh_gun->indices[
    0x266
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x267
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x268
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x269
  ] = (
    0x55
  );

  mesh_gun->indices[
    0x26a
  ] = (
    0x55
  );

  mesh_gun->indices[
    0x26b
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x26c
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x26d
  ] = (
    0x5d
  );

  mesh_gun->indices[
    0x26e
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x26f
  ] = (
    0x56
  );

  mesh_gun->indices[
    0x270
  ] = (
    0x57
  );

  mesh_gun->indices[
    0x271
  ] = (
    0x5f
  );

  mesh_gun->indices[
    0x272
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x273
  ] = (
    0x62
  );

  mesh_gun->indices[
    0x274
  ] = (
    0x38
  );

  mesh_gun->indices[
    0x275
  ] = (
    0x30
  );

  mesh_gun->indices[
    0x276
  ] = (
    0x30
  );

  mesh_gun->indices[
    0x277
  ] = (
    0x5a
  );

  mesh_gun->indices[
    0x278
  ] = (
    0x61
  );

  mesh_gun->indices[
    0x279
  ] = (
    0x5e
  );

  mesh_gun->indices[
    0x27a
  ] = (
    0x54
  );

  mesh_gun->indices[
    0x27b
  ] = (
    0x61
  );

}

