#ifndef __application_c938_application_delegate_h
#define __application_c938_application_delegate_h

#include <AppKit/AppKit.h>

@interface c938_application_delegate: NSObject<NSApplicationDelegate>

- (void) applicationWillTerminate:(NSNotification*) notification;

@end

#endif
