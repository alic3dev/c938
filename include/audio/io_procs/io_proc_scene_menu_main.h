#ifndef __c938_audio_io_procs_io_proc_scene_menu_main_h
#define __c938_audio_io_procs_io_proc_scene_menu_main_h

#include <metil_audio/metil_audio_io_proc.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

metil_audio_io_proc_macro_type(
  c938_audio_io_proc_scene_menu_main
);

#endif
