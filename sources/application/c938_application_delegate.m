#include <application/c938_application_delegate.h>

#include <termination.h>

@implementation c938_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  termination_terminate();
}

@end
