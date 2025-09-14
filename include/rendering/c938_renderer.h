#ifndef __c938_renderer_h
#define __c938_renderer_h

#include <object.h>
#include <rendering/rendering_properties.h>
#include <scenes/scene.h>

#include <MetalKit/MetalKit.h>

@interface c938_renderer : NSObject<MTKViewDelegate> {
  struct rendering_properties rendering_properties;

  struct scene scene;

  id<MTLDevice> metal_kit_device;
  
  id<MTLBuffer> data_buffer_frame[count_max_frames];
  id<MTLBuffer> index_buffer_mesh_current;

  id<MTLCommandQueue> command_queue;

  id<MTLRenderCommandEncoder> encoder_render;

  id<MTLRenderPipelineState> state_pipeline;
  id<MTLRenderPipelineState> state_pipeline_no_render;

  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disable;

  unsigned char index_data_buffer_frame;
}

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view;

- (void) on_scene_change: (enum scene_id) scene_id;

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size;
- (void) drawableSizeWillChange: (CGSize) size;

- (void) poll: (unsigned int) _frame;
- (void) poll_object: (nonnull struct object*) object;

- (void) render;
- (void) render_object: (nonnull struct object*) object;

- (void) destroy;

@end

void c938_renderer_on_scene_change(
  enum scene_id,
  void* _Nonnull
);
void c938_renderer_on_termination(void* _Nonnull);

#endif
