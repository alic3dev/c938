#include <menus/menu_main.h>

#include <metil_menus/menu.h>
#include <metil_menus/menu_item.h>

void menu_main_initialize(
  struct metil_menu* menu
) {
  metil_menu_initialize(menu);

  metil_menu_item_add(
    menu,
    metil_menu_item_type_selection,
    metil_menu_item_action_select,
    (void*)0
  );

  metil_menu_item_add(
    menu,
    metil_menu_item_type_selection,
    metil_menu_item_action_select,
    (void*)0
  );
}
