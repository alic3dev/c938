#include <audio/io_procs/io_proc_scene_menu_main.h>

#include <metil_audio/metil_audio_io_proc.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif

metil_audio_io_proc_macro_definition(
  c938_audio_io_proc_scene_menu_main
) {
  metil_audio_io_proc_macro_definition_frame_loop {
    metil_audio_io_proc_macro_definition_frame_set(
      0x00
    )
  }

  metil_audio_io_proc_macro_definition_return;
}
