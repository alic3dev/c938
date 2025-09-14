#include <rendering/c938_renderer.h>

#include <audio/audio.h>
#include <configuration/configuration.h>
#include <input/controller.h>
#include <input/map.h>
#include <input/keycodes.h>
#include <mesh/mesh.h>
#include <metal_kit_shader_types.h>
#include <object.h>
#include <rendering/camera/camera.h>
#include <scenes/scene_controller.h>
#include <scenes/scene_menu_main.h>
#include <scenes/scene_gameplay.h>
#include <termination.h>
#include <utilities/time.h>

#include <clic3.h>

#include <limits.h>

#include <MetalKit/MetalKit.h>

@implementation c938_renderer

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view {
  self = [super init];

  if (!self) {
    return self;
  }

  metal_kit_device = metal_kit_view.device;

  rendering_properties_initialize(
    &self->rendering_properties
  );

  self->rendering_properties.brightness = (
    configuration.rendering_properties.brightness
  );
  self->rendering_properties.brightness_text = (
    configuration.rendering_properties.brightness_text
  );

  scene_menu_main_initialize(
    &self->scene,
    metal_kit_device
  );

  metal_kit_view.depthStencilPixelFormat = MTLPixelFormatDepth32Float_Stencil8;
  metal_kit_view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
  metal_kit_view.sampleCount = 1;

  id<MTLLibrary> library_default = [metal_kit_device newDefaultLibrary];
  id<MTLFunction> function_vertex = [library_default newFunctionWithName: @"c938_vertex"];
  id<MTLFunction> function_fragment = [library_default newFunctionWithName: @"c938_fragment"];

  MTLRenderPipelineDescriptor* descriptor_state_pipeline = [[MTLRenderPipelineDescriptor alloc] init];
  descriptor_state_pipeline.rasterSampleCount = metal_kit_view.sampleCount;
  descriptor_state_pipeline.vertexFunction = function_vertex;
  descriptor_state_pipeline.fragmentFunction = function_fragment;
  descriptor_state_pipeline.colorAttachments[0].pixelFormat = metal_kit_view.colorPixelFormat;
  descriptor_state_pipeline.colorAttachments[0].blendingEnabled = 1;
  descriptor_state_pipeline.colorAttachments[0].rgbBlendOperation = MTLBlendOperationAdd;
  descriptor_state_pipeline.colorAttachments[0].alphaBlendOperation = MTLBlendOperationAdd;
  descriptor_state_pipeline.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
  descriptor_state_pipeline.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactorSourceAlpha;
  descriptor_state_pipeline.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
  descriptor_state_pipeline.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactorOneMinusSourceAlpha;

  descriptor_state_pipeline.depthAttachmentPixelFormat = metal_kit_view.depthStencilPixelFormat;
  descriptor_state_pipeline.stencilAttachmentPixelFormat = metal_kit_view.depthStencilPixelFormat;

  state_pipeline = [metal_kit_device
    newRenderPipelineStateWithDescriptor: descriptor_state_pipeline
    error: (void*)0
  ];
  descriptor_state_pipeline.fragmentFunction = (void*)0;

  state_pipeline_no_render = [metal_kit_device
    newRenderPipelineStateWithDescriptor: descriptor_state_pipeline
    error: (void*)0
  ];

  MTLDepthStencilDescriptor* descriptor_state_depth = [[MTLDepthStencilDescriptor alloc] init];
  descriptor_state_depth.depthCompareFunction = MTLCompareFunctionLessEqual;
  descriptor_state_depth.depthWriteEnabled = 1;
  depth_state = [metal_kit_device newDepthStencilStateWithDescriptor:descriptor_state_depth];

  descriptor_state_depth.depthWriteEnabled = 0;
  depth_state_writes_disable = [metal_kit_device newDepthStencilStateWithDescriptor: descriptor_state_depth];

  for (
    unsigned int index_buffer = 0;
    index_buffer < count_max_frames;
    ++index_buffer
  ) {
    data_buffer_frame[
      index_buffer
    ] = [metal_kit_device
      newBufferWithLength: sizeof(metal_kit_data_frame)
      options:MTLResourceStorageModeShared
    ];
  }

  command_queue = [metal_kit_device newCommandQueue];

  termination_on_function_add(
    c938_renderer_on_termination,
    self
  );

  scene_controller_on_scene_change_add(
    c938_renderer_on_scene_change,
    self
  );

  return self;
}

- (void) on_scene_change: (enum scene_id) scene_id {
  scene_destroy(
    &self->scene
  );

  switch (
    scene_id
  ) {
    case scene_id_unknown:
    case scene_id_menu_main:
      scene_menu_main_initialize(
        &self->scene,
        metal_kit_device
      );
      break;
    case scene_id_gameplay:
      scene_gameplay_initialize(
        &self->scene,
        self->metal_kit_device
      );
      break;
  }
}

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view {
  const unsigned int _frame = (
    self->rendering_properties.frame++
  );

  if (_frame == 0) {
    audio_data.muted = 0;
  }

  if (
    self->rendering_properties.frame + 1 >= UINT_MAX - 1
  ) {
    self->rendering_properties.frame = 1;
  }

  self->rendering_properties.count_completed_frames = (
    self->rendering_properties.count_completed_frames - 1
  );

  if (
    self->rendering_properties.count_completed_frames <= 0
  ) {
    pthread_mutex_lock(
      &self->rendering_properties.mutex_frame
    );
  }

  index_data_buffer_frame = (index_data_buffer_frame + 1) % count_max_frames;

  id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];

  MTLRenderPassDescriptor* descriptor_render_pass = metal_kit_view.currentRenderPassDescriptor;
  descriptor_render_pass.colorAttachments[0].clearColor = MTLClearColorMake(
    0.9f,
    0.95f,
    1.0f,
    1.0f
  );

  encoder_render = [command_buffer renderCommandEncoderWithDescriptor: descriptor_render_pass];

  [encoder_render setRenderPipelineState: state_pipeline];
  [encoder_render setDepthStencilState: depth_state];

  [self poll: _frame];
  [self render];

  [encoder_render endEncoding];

  [command_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
    self->rendering_properties.count_completed_frames = (
      self->rendering_properties.count_completed_frames + 1
    );

    if (
      self->rendering_properties.count_completed_frames == 0 ||
      self->rendering_properties.count_completed_frames == 1
    ) {
      pthread_mutex_unlock(
        &self->rendering_properties.mutex_frame
      );
    }
  }];

  [command_buffer presentDrawable: metal_kit_view.currentDrawable];
  [command_buffer commit];
}

- (void) poll_object: (struct object*) object {
  metal_kit_data_frame_object* data = object->data.contents;

  data->position.x = object->position.x;
  data->position.y = object->position.y;
  data->position.z = object->position.z;

  if (
    object->mesh.positioning == mesh_positioning_normal ||
    object->mesh.positioning == mesh_positioning_player
  ) {
    struct clic3_vector3_float position = {
      .x = object->position.x - self->scene.player.position.x,
      .y = object->position.y - self->scene.player.position.y - 4.0f,
      .z = object->position.z - self->scene.player.position.z
    };

    data->view_model_matrix_projection = matrix_multiply(
      self->rendering_properties.camera.matrix_viewport_projection,
      (
        (matrix_float4x4) {{
          { 1, 0, 0, 0 },
          { 0, cos(self->scene.player.rotation.x), sin(self->scene.player.rotation.x), 0 },
          { 0, -sin(self->scene.player.rotation.x), cos(self->scene.player.rotation.x), 0 },
          {
            1,
            1,
            1,
            1
          }
        }}
      )
    );

    if (object->mesh.positioning != mesh_positioning_player) {
      data->view_model_matrix_projection = matrix_multiply(
        data->view_model_matrix_projection,
        (
          (matrix_float4x4) {{
            { cos(self->scene.player.rotation.y), 0, -sin(self->scene.player.rotation.y), 0 },
            { 0, 1, 0, 0 },
            { sin(self->scene.player.rotation.y), 0, cos(self->scene.player.rotation.y), 0 },
            {
              1,
              1,
              1,
              1
            }
          }}
        )
      );
    }

    data->view_model_matrix_projection = matrix_multiply(
      data->view_model_matrix_projection,
      (matrix_float4x4) {{
        { 1, 0, 0, 0 },
        { 0, 1, 0, 0 },
        { 0, 0, 1, 0 },
        {
          position.x,
          position.y,
          position.z,
          1
        }
      }}
    );
  } else {
    data->view_model_matrix_projection = (matrix_float4x4) {{
      { 1, 0, 0, 0 },
      { 0, 1, 0, 0 },
      { 0, 0, 1, 0 },
      {
        object->position.x,
        object->position.y,
        object->position.z,
        1
      }
    }};
  }

  data->width = object->mesh.size.x;
  data->height = object->mesh.size.y;
  data->depth = object->mesh.size.z;
}

- (void) poll: (unsigned int) _frame {
  controller_poll();

  unsigned long int time = time_milliseconds_get();

  scene_poll_input(
    &self->scene,
    time
  );
  
  scene_poll(
    &self->scene,
    time
  );

  metal_kit_data_frame* data_frame = (data_buffer_frame[index_data_buffer_frame]).contents;
  data_frame->frame = _frame;

  data_frame->rotation_camera.x = self->scene.player.rotation.x;
  data_frame->rotation_camera.y = self->scene.player.rotation.y;
  data_frame->rotation_camera.z = self->scene.player.rotation.z;

  data_frame->position_player.x = self->scene.player.position.x;
  data_frame->position_player.y = self->scene.player.position.y;
  data_frame->position_player.z = self->scene.player.position.z;

  data_frame->brightness = (
    self->scene.rendering_properties.brightness *
    self->rendering_properties.brightness
  );
  data_frame->brightness_text = (
    self->scene.rendering_properties.brightness_text *
    self->rendering_properties.brightness_text
  );

  for (
    unsigned short int index_object = 0;
    index_object < self->scene.length_objects;
    ++index_object
  ) {
    [self poll_object: self->scene.objects[index_object]];
  }
}

- (void) render_object: (struct object*) object {
  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metal_kit_vertex_input_index_frame_data
  ];

  [encoder_render
    setFragmentTexture: object->texture
    atIndex: 0
  ];

  if (
    object->texture_secondary != (void*)0
  ) {
    [encoder_render
      setFragmentTexture: object->texture_secondary
      atIndex: 1
    ];
  }

  [encoder_render
    setVertexBuffer: object->vertices
    offset: 0
    atIndex: metal_kit_vertex_input_index_positions
  ];
  
  [encoder_render
    setVertexBuffer: object->data
    offset: 0
    atIndex: metal_kit_vertex_input_index_data
  ];
  
  [encoder_render
    drawIndexedPrimitives: MTLPrimitiveTypeTriangle
    indexCount: object->mesh.length_indices
    indexType: MTLIndexTypeUInt32
    indexBuffer: object->indices
    indexBufferOffset: 0
  ];
}

- (void) render {
  for (
    unsigned short int index_object = 0;
    index_object < self->scene.length_objects;
    ++index_object
  ) {
    [self render_object: self->scene.objects[index_object]];
  }
}

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size {}

- (void) drawableSizeWillChange: (CGSize) size {
  camera_ratio_aspect_set(
    &self->rendering_properties.camera, (
      (float) size.width /
      (float) size.height
    )
  );
}

- (void) destroy {
  scene_destroy(
    &self->scene
  );

  rendering_properties_destory(
    &self->rendering_properties
  );
}

@end

void c938_renderer_on_scene_change(
  enum scene_id scene_id,
  void* _Nonnull reference
) {
  c938_renderer* renderer = (c938_renderer*) reference;

  [renderer on_scene_change: scene_id];
}

void c938_renderer_on_termination(
  void* _Nonnull reference
) {
  c938_renderer* renderer = (c938_renderer*) reference;

  [renderer destroy];
}
