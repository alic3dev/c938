#include <menus/menu_main_custom.h>

#include <data/parameters_gameplay.h>

#include <metil_menus/metil_menu.h>
#include <metil_menus/metil_menu_item.h>

void menu_main_custom_initialize(
  struct metil_menu* menu,
  struct parameters_gameplay* parameters_gameplay
) {
  metil_menu_initialize(
    menu
  );

  for (
    unsigned char index_menu_item = 0;
    index_menu_item < menus_menu_main_custom_length;
    ++index_menu_item
  ) {
    switch (
      index_menu_item
    ) {
      case menus_menu_main_custom_index_length_buildings: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->index = (
          parameters_gameplay->length_buildings
        );

        metil_menu_item_data_scroll->length = (
          50000
        );

        break;
      }
      case menus_menu_main_custom_index_multiplier_buildings: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->index = (
          parameters_gameplay->multiplier_buildings *
          100
        );

        metil_menu_item_data_scroll->length = (
          50000
        );

        break;
      }
      case menus_menu_main_custom_index_length_enemies: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->index = (
          parameters_gameplay->length_enemies
        );

        metil_menu_item_data_scroll->length = (
          50000
        );

        break;
      }
      case menus_menu_main_custom_index_multiplier_enemies: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->index = (
          parameters_gameplay->multiplier_enemies *
          100
        );

        metil_menu_item_data_scroll->length = (
          50000
        );

        break;
      }
      case menus_menu_main_custom_index_speed_movement: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->index = (
          parameters_gameplay->speed_movement
        );

        metil_menu_item_data_scroll->length = (
          50000
        );

        break;
      }
      case menus_menu_main_custom_index_multiplier_speed_movement: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->index = (
          parameters_gameplay->multiplier_speed_movement *
          100
        );

        metil_menu_item_data_scroll->length = (
          50000
        );

        break;
      }
      case menus_menu_main_custom_index_mode: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_scroll,
          metil_menu_item_action_none,
          (void*) 0
        );

        struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
          menu->items[
            index_menu_item
          ].data_menu_item
        );

        metil_menu_item_data_scroll->length = 2;

        break;
      }
      default: {
        metil_menu_item_add(
          menu,
          metil_menu_item_type_selection,
          metil_menu_item_action_select,
          (void*) 0
        );

        break;
      }
    }
  }
}
