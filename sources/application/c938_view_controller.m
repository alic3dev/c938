#include <application/c938_view_controller.h>

#include <application/c938_view.h>
#include <rendering/c938_renderer.h>

@implementation c938_view_controller {
  c938_view* view;
  c938_renderer* renderer;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  view = (c938_view*) self.view;
  view.device = MTLCreateSystemDefaultDevice();

  renderer = [
    [c938_renderer alloc]
    initWithMetalKitView: view
  ];

  [renderer
    drawableSizeWillChange: view.bounds.size
  ];

  view.delegate = self;
}

- (void) drawInMTKView: (nonnull c938_view*) _view {
  [renderer
    drawInMTKView: _view
  ];
}

- (void) mtkView: (nonnull c938_view*) _view drawableSizeWillChange: (CGSize) size {
  [renderer
    drawableSizeWillChange: _view.bounds.size
  ];
}

@end
