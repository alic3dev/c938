#include <menus/menu_main_custom.h>

#include <metil_menus/metil_menu.h>
#include <metil_menus/metil_menu_item.h>

void menu_main_custom_initialize(
  struct metil_menu* menu
) {
  metil_menu_initialize(
    menu
  );

  for (
    unsigned char index_menu_item = 0;
    index_menu_item < menus_menu_main_custom_length;
    ++index_menu_item
  ) {
    metil_menu_item_add(
      menu,
      metil_menu_item_type_selection,
      metil_menu_item_action_select,
      (void*) 0
    );
  }
}
