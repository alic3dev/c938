#include <c938_logging.h>

#include <data/c938_data.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object_text.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_utilities/metil_stopwatch.h>

void c938_logging_initialize(
  struct c938_logging* c938_logging
) {
  metil_group_initialize(
    &c938_logging->group
  );

  c938_logging->stopwatches = (
    clic3_memory_allocate_raw(
      0
    )
  );

  pthread_mutex_init(
    &c938_logging->mutex,
    0
  );
}

void c938_logging_log(
  struct metil* metil,
  char* log
) {
  struct c938_data* c938_data = (
    metil->data
  );

  struct c938_logging* c938_logging = &(
    c938_data->logging
  );

  pthread_mutex_lock(
    &c938_logging->mutex
  );

  struct metil_group* metil_group_logging = &(
    c938_logging->group
  );

  metil_group_add_initialize(
    metil_group_logging,
    metil_renderable_type_object
  );

  struct metil_object* metil_object_log = (
    metil_group_logging->renderables[
      metil_group_logging->length -
      1
    ]->renderable
  );

  clic3_memory_reallocate_raw(
    &c938_logging->stopwatches,
    (
      sizeof(
        struct metil_stopwatch
      ) *
      metil_group_logging->length
    )
  );

  struct metil_stopwatch* metil_stopwatch_log = (
    &c938_logging->stopwatches[
      metil_group_logging->length -
      1
    ]
  );

  metil_stopwatch_start(
    metil_stopwatch_log
  );

  metil_object_text_initialize(
    metil,
    metil_object_log,
    log
  );

  pthread_mutex_unlock(
    &c938_logging->mutex
  );
}

void c938_logging_poll(
  struct metil* metil
) {
  struct c938_data* c938_data = (
    metil->data
  );

  struct c938_logging* c938_logging = &(
    c938_data->logging
  );

  pthread_mutex_lock(
    &c938_logging->mutex
  );

  struct metil_group* metil_group_logging = (
    &c938_logging->group
  );

  struct metil_object* metil_object_log;
  struct metil_stopwatch* metil_stopwatch_log;

  for (
    unsigned short int index_log = 0;
    index_log < metil_group_logging->length;
  ) {
    metil_object_log = (
      metil_group_logging->renderables[
        index_log
      ]->renderable
    );

    metil_stopwatch_log = &(
      c938_logging->stopwatches[
        index_log
      ]
    );

    unsigned long int time_elapsed = (
      metil_stopwatch_elapsed(
        metil_stopwatch_log
      )
    );

    float time_elapsed_percentage = (
      (float) time_elapsed /
      (float) c938_logging_time_display_length
    );

    if (
      // time_elapsed_percentage > 1.0f
      0
    ) {
      // printf("WHAT\n");
      // metil_group_destroy_renderable_at_index(
      //   metil,
      //   metil_group_logging,
      //   index_log
      // );

      // for (
      //   unsigned int index_stopwatch = index_log;
      //   index_stopwatch < metil_group_logging->length;
      //   ++index_stopwatch
      // ) {
      //   c938_logging->stopwatches[
      //     index_log
      //   ] = (
      //     c938_logging->stopwatches[
      //       index_log +
      //       1
      //     ]
      //   );
      // }

      // clic3_memory_reallocate_raw(
      //   &c938_logging->stopwatches,
      //   (
      //     sizeof(
      //       struct metil_stopwatch
      //     ) *
      //     metil_group_logging->length
      //   )
      // );

      // continue;
    }

    metil_object_log->position.x = (
      metil_object_log->position.x + 0.01f
    );    

    // struct metil_renderer_data_object* data = (
    //   metil_object_log->buffers_vertex[
    //     metil_object_buffer_default_index_data
    //   ].buffer.contents
    // );

    // data->color.w = (
    //   time_elapsed_percentage
    // );

    index_log = (
      index_log +
      1
    );
  }

  pthread_mutex_unlock(
    &c938_logging->mutex
  );
}

void c938_logging_destroy(
  struct metil* metil,
  struct c938_logging* c938_logging
) {
  metil_group_destroy(
    metil,
    &c938_logging->group
  );

  clic3_memory_free_raw(
    c938_logging->stopwatches
  );

  pthread_mutex_destroy(
    &c938_logging->mutex
  );
}
