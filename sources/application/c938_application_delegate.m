#if target_os_ios
#include <application/c938_application_delegate.h>

// #include <io_proc.h>

#include <metil_termination.h>

@implementation c938_application_delegate {}

- (BOOL) application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions {
  return 1;
}

- (void) applicationWillTerminate: (NSNotification*) notification {
  // io_proc_audio_destroy();
  metil_termination_terminate();
}

@end
#endif
