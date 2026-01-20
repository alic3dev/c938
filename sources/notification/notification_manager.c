#include <notification/notification_manager.h>

#include <clic3_memory.h>

#include <pthread.h>

void notification_manager_initialize(
  struct notification_manager* notification_manager
) {
  notification_manager->length_notification_on_functions = (
    0
  );

  notification_manager->notification_on_functions = (
    clic3_memory_allocate_raw(
      0
    )
  );

  notification_manager->notification_on_functions_data = (
    clic3_memory_allocate_raw(
      0
    )
  );

  pthread_mutex_init(
    &notification_manager->mutex_notification,
    0
  );
}

void notification_manager_notification_on_add(
  struct notification_manager* notification_manager,
  notification_manager_notification_on notification_on_function,
  void* notification_on_function_data
) {
  pthread_mutex_lock(
    &notification_manager->mutex_notification
  );

  notification_manager->length_notification_on_functions = (
    notification_manager->length_notification_on_functions +
    1
  );

  clic3_memory_reallocate_raw(
    &notification_manager->notification_on_functions,
    (
      sizeof(
        notification_manager_notification_on
      ) *
      notification_manager->length_notification_on_functions
    )
  );

  clic3_memory_reallocate_raw(
    &notification_manager->notification_on_functions_data,
    (
      sizeof(
        void*
      ) *
      notification_manager->length_notification_on_functions
    )
  );

  notification_manager->notification_on_functions[
    notification_manager->length_notification_on_functions -
    1
  ] = (
    notification_on_function
  );

  notification_manager->notification_on_functions_data[
    notification_manager->length_notification_on_functions -
    1
  ] = (
    notification_on_function_data
  );

  pthread_mutex_unlock(
    &notification_manager->mutex_notification
  );
}

void notification_manager_notification_on_remove(
  struct notification_manager* notification_manager,
  notification_manager_notification_on notification_manager_notification_on
) {
  pthread_mutex_lock(
    &notification_manager->mutex_notification
  );

  for (
    unsigned int index_notification_on = 0;
    index_notification_on < notification_manager->length_notification_on_functions;
  ) {
    if (
      notification_manager->notification_on_functions[
        index_notification_on
      ] == (
        notification_manager_notification_on
      )
    ) {
      for (
        unsigned int index_shift_notification_on = index_notification_on;
        index_shift_notification_on < (
          notification_manager->length_notification_on_functions -
          1
        );
        ++index_shift_notification_on
      ) {
        notification_manager->notification_on_functions[
          index_shift_notification_on
        ] = (
          notification_manager->notification_on_functions[
            index_shift_notification_on +
            1
          ]
        );

        notification_manager->notification_on_functions_data[
          index_shift_notification_on
        ] = (
          notification_manager->notification_on_functions_data[
            index_shift_notification_on +
            1
          ]
        );
      }

      notification_manager->length_notification_on_functions = (
        notification_manager->length_notification_on_functions -
        1
      );

      clic3_memory_reallocate_raw(
        &notification_manager->notification_on_functions,
        (
          sizeof(
            notification_manager_notification_on
          ) *
          notification_manager->length_notification_on_functions
        )
      );

      clic3_memory_reallocate_raw(
        &notification_manager->notification_on_functions_data,
        (
          sizeof(
            void*
          ) *
          notification_manager->length_notification_on_functions
        )
      );
    }

    index_notification_on = (
      index_notification_on +
      1
    );
  }

  pthread_mutex_unlock(
    &notification_manager->mutex_notification
  );
}

void notification_manager_send(
  struct notification_manager* notification_manager,
  char* message,
  unsigned char id
) {
  pthread_mutex_lock(
    &notification_manager->mutex_notification
  );

  for (
    unsigned int index_notification_on = 0;
    index_notification_on < notification_manager->length_notification_on_functions;
    ++index_notification_on
  ) {
    notification_manager->notification_on_functions[
      index_notification_on
    ](
      message,
      id,
      notification_manager->notification_on_functions_data[
        index_notification_on
      ]
    );
  }

  pthread_mutex_unlock(
    &notification_manager->mutex_notification
  );
}

void notification_manager_destroy(
  struct notification_manager* notification_manager
) {
  clic3_memory_free_raw(
    notification_manager->notification_on_functions
  );

  clic3_memory_free_raw(
    notification_manager->notification_on_functions_data
  );

  pthread_mutex_destroy(
    &notification_manager->mutex_notification
  );
}
