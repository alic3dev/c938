#include <logging/c938_logging.h>

#include <data/c938_data.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <math_c_minimum.h>
#include <math_c_vector.h>

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

  c938_logging->length_buffer_logs = 0;
  c938_logging->buffer_logs = (
    clic3_memory_allocate_raw(
      0
    )
  );

  c938_logging->position_y = 1.0f;
  c938_logging->scale = 0.5f;

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

  c938_logging->length_buffer_logs = (
    c938_logging->length_buffer_logs +
    1
  );

  clic3_memory_reallocate_raw(
    &c938_logging->buffer_logs,
    (
      sizeof(
        void*
      ) *
      c938_logging->length_buffer_logs
    )
  );

  c938_logging->buffer_logs[
    c938_logging->length_buffer_logs -
    1
  ] = (
    clic3_char_arrays_concatenate(
      log,
      ""
    )
  );

  pthread_mutex_unlock(
    &c938_logging->mutex
  );
}

void c938_render_log(
  struct metil* metil,
  char* log
) {
  struct c938_data* c938_data = (
    metil->data
  );

  struct c938_logging* c938_logging = &(
    c938_data->logging
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

  for (
    unsigned char index_vertex = 0;
    index_vertex < metil_object_log->mesh.length_vertices;
    ++index_vertex
  ) {
    struct math_c_vector4_float* vertices = (
      metil_object_log->buffers_vertex[
        metil_object_buffer_default_index_vertices
      ].buffer.contents
    );

    vertices[
      index_vertex
    ].x = (
      (
        vertices[
          index_vertex
        ].x +
        metil_object_log->mesh.size.x /
        2.0f
      ) *
      c938_logging->scale
    );

    vertices[
      index_vertex
    ].y = (
      (
        vertices[
          index_vertex
        ].y -
        metil_object_log->mesh.size.y /
        2.0f
      ) *
      c938_logging->scale
    );
  }

  metil_object_log->position.x = (
    -1.0f
  );

  metil_object_log->mesh.size.x = (
    metil_object_log->mesh.size.x *
    c938_logging->scale
  );

  metil_object_log->mesh.size.y = (
    metil_object_log->mesh.size.y *
    c938_logging->scale
  );

  metil_object_log->position.y = (
    c938_logging->position_y
  );

  c938_logging->position_y = (
    c938_logging->position_y -
    metil_object_log->mesh.size.y
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

  for (
    unsigned int index_buffer_log = 0;
    index_buffer_log < c938_logging->length_buffer_logs;
    ++index_buffer_log
  ) {
    c938_render_log(
      metil,
      c938_logging->buffer_logs[
        index_buffer_log
      ]
    );
  }

  if (
    c938_logging->length_buffer_logs > 0
  ) {
    c938_logging->length_buffer_logs = 0;

    clic3_memory_reallocate_raw(
      &c938_logging->buffer_logs,
      0
    );
  }

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
      math_c_minimum_float(
        (
          (float) time_elapsed /
          (float) c938_logging_time_display_length
        ),
        1.0f
      )
    );

    if (
      time_elapsed >= c938_logging_time_display_length
    ) {
      c938_logging->position_y = (
        c938_logging->position_y +
        metil_object_log->mesh.size.y
      );

      for (
        unsigned short int index_log_positioning = (
          index_log +
          1
        );
        index_log_positioning < metil_group_logging->length;
        ++index_log_positioning
      ) {
        struct metil_object* metil_object_log_positioning = (
           metil_group_logging->renderables[
            index_log_positioning
          ]->renderable
        );

        metil_object_log_positioning->position.y = (
          metil_object_log_positioning->position.y +
          metil_object_log->mesh.size.y
        );
      }

      metil_group_destroy_renderable_at_index(
        metil,
        metil_group_logging,
        index_log
      );
      
      for (
        unsigned int index_stopwatch = index_log;
        index_stopwatch < metil_group_logging->length;
        ++index_stopwatch
      ) {
        clic3_bytes_copy(
          &c938_logging->stopwatches[
            index_stopwatch
          ],
          &c938_logging->stopwatches[
            index_stopwatch +
            1
          ],
          sizeof(
            struct metil_stopwatch
          )
        );
      }

      clic3_memory_reallocate_raw(
        &c938_logging->stopwatches,
        (
          sizeof(
            struct metil_stopwatch
          ) *
          metil_group_logging->length
        )
      );

      continue;
    }

    struct metil_renderer_data_object* data = (
      metil_object_log->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    data->colour.w = (
      1.0f -
      time_elapsed_percentage
    );

    data->colour.y = (
      1.0f -
      time_elapsed_percentage
    );

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
  for (
    unsigned int index_buffer_log = 0;
    index_buffer_log < c938_logging->length_buffer_logs;
    ++index_buffer_log
  ) {
    clic3_memory_free_raw(
      c938_logging->buffer_logs[
        index_buffer_log
      ]
    );
  }

  clic3_memory_free_raw(
    c938_logging->buffer_logs
  );

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
